import json
from collections import defaultdict
from datetime import UTC, datetime

from fastapi import APIRouter, Depends, Query, Request
from sqlalchemy import or_, select
from sqlalchemy.orm import Session

from app.core.exceptions import ForbiddenException, NotFoundException, ValidationException
from app.core.deps import get_current_user, require_any_permission
from app.core.response import paginated_response, success_response
from app.db.session import get_db
from app.models.entities import ChangeRequest, Department, User
from app.schemas.api import (
    CreateChangeRequestRequest,
    UpdateAccountRequest,
    UpdateDepartmentRequest,
    UpdateEmployeeRequest,
    UpdatePositionRequest,
)
from app.services.access_control import resolve_access_profile

router = APIRouter()


def _build_change_request_no() -> str:
    return f"CR-{datetime.now(UTC).strftime('%Y%m%d%H%M%S%f')}"


def _mask_mobile(mobile: str) -> str:
    if len(mobile) < 7:
        return mobile
    return f"{mobile[:3]}****{mobile[-4:]}"


def _resolve_position_level(position_name: str) -> str:
    normalized = position_name.lower()
    if "manager" in normalized or "lead" in normalized:
        return "M1"
    if "hrbp" in normalized:
        return "P4"
    if "engineer" in normalized or "developer" in normalized:
        return "P5"
    if "specialist" in normalized or "operator" in normalized:
        return "P3"
    return "P2"


def _build_position_id(department_id: str, position_name: str) -> str:
    normalized = "".join(
        char if char.isalnum() else "-"
        for char in position_name.strip().lower()
    ).strip("-")
    if not normalized:
        normalized = "unassigned"
    return f"position-{department_id}-{normalized}"


def _build_department_tree(departments: list[Department], users: list[User]) -> list[dict]:
    by_parent: dict[str | None, list[Department]] = defaultdict(list)
    for department in departments:
        by_parent[department.parent_id].append(department)

    users_by_department: dict[str, list[User]] = defaultdict(list)
    for user in users:
        users_by_department[user.department_id].append(user)

    def build_node(parent_id: str | None) -> list[dict]:
        result: list[dict] = []
        for department in by_parent.get(parent_id, []):
            department_users = users_by_department.get(department.id, [])
            leader_name = department_users[0].name if department_users else ""
            result.append(
                {
                    "id": department.id,
                    "name": department.name,
                    "parentId": department.parent_id,
                    "leader": leader_name,
                    "memberCount": len(department_users),
                    "description": f"{department.name} org unit",
                    "children": build_node(department.id),
                }
            )
        return result

    return build_node(None)


def _flatten_department_nodes(nodes: list[dict]) -> list[dict]:
    flattened: list[dict] = []
    for node in nodes:
        flattened.append(
            {
                "id": node["id"],
                "name": node["name"],
                "leader": node["leader"],
                "memberCount": node["memberCount"],
                "description": node["description"],
            }
        )
        children = node.get("children")
        if isinstance(children, list) and children:
            flattened.extend(_flatten_department_nodes(children))
    return flattened


def _load_applied_overrides(
    db: Session,
    entity_type: str,
) -> dict[str, dict[str, str]]:
    change_requests = db.scalars(
        select(ChangeRequest)
        .where(
            ChangeRequest.entity_type == entity_type,
            ChangeRequest.status == "APPLIED",
        )
        .order_by(ChangeRequest.submitted_at.desc())
    ).all()

    overrides: dict[str, dict[str, str]] = {}
    for change_request in change_requests:
        if change_request.entity_id in overrides:
            continue
        try:
            snapshot = json.loads(change_request.snapshot or "{}")
        except json.JSONDecodeError:
            continue
        if not isinstance(snapshot, dict):
            continue
        overrides[change_request.entity_id] = {
            str(key): str(value)
            for key, value in snapshot.items()
            if value is not None
        }
    return overrides


def _required_permission_for_entity(entity_type: str) -> str | None:
    mapping = {
        "employee": "manageEmployees",
        "department": "manageDepartments",
        "position": "managePositions",
        "account": "manageAccounts",
    }
    return mapping.get(entity_type)


def _allowed_change_request_entity_types(
    *,
    user: User,
    db: Session,
) -> set[str]:
    access_profile = resolve_access_profile(user, db=db)
    allowed: set[str] = set()
    for entity_type in ("employee", "department", "position", "account"):
        required_permission = _required_permission_for_entity(entity_type)
        if required_permission and required_permission in access_profile.permissions:
            allowed.add(entity_type)
    return allowed


def _assert_change_request_permission(
    *,
    user: User,
    change_request: ChangeRequest,
    db: Session,
) -> None:
    required_permission = _required_permission_for_entity(change_request.entity_type)
    if required_permission is None:
        raise ValidationException(message="Unsupported change request entity type")
    access_profile = resolve_access_profile(user, db=db)
    if required_permission not in access_profile.permissions:
        raise ForbiddenException(message="Insufficient permissions")


def _serialize_employee(
    user: User,
    override: dict[str, str] | None = None,
    *,
    department_names: dict[str, str] | None = None,
    position_title: str | None = None,
) -> dict:
    override = override or {}
    effective_department_id = override.get("departmentId", user.department_id)
    base_position_name = override.get("position", user.position).strip() or "Unassigned"
    effective_department_name = (
        department_names.get(effective_department_id)
        if department_names is not None
        else None
    ) or override.get("department", user.department.name)
    return {
        "id": user.id,
        "name": user.name,
        "employeeNo": user.employee_no,
        "departmentId": effective_department_id,
        "department": effective_department_name,
        "positionId": _build_position_id(effective_department_id, base_position_name),
        "position": position_title or base_position_name,
        "mobile": override.get("mobile", user.mobile),
        "mobileMasked": _mask_mobile(override.get("mobile", user.mobile)),
        "email": override.get("email", user.email),
        "status": override.get("status", "Active"),
    }


def _build_position_items(
    users: list[User],
    employee_overrides: dict[str, dict[str, str]],
    department_names: dict[str, str],
    position_overrides: dict[str, dict[str, str]],
) -> tuple[list[dict], dict[tuple[str, str], dict[str, str]]]:
    positions_by_id: dict[str, dict] = {}
    title_override_lookup: dict[tuple[str, str], dict[str, str]] = {}

    for user in users:
        employee_override = employee_overrides.get(user.id, {})
        department_id = employee_override.get("departmentId", user.department_id)
        department_name = department_names.get(department_id, user.department.name)
        base_position_name = employee_override.get("position", user.position).strip() or "Unassigned"
        position_id = _build_position_id(department_id, base_position_name)
        position_override = position_overrides.get(position_id, {})
        effective_title = position_override.get("title", base_position_name)

        title_override_lookup[(department_id, base_position_name)] = {
            "positionId": position_id,
            "title": effective_title,
        }

        if position_id not in positions_by_id:
            positions_by_id[position_id] = {
                "id": position_id,
                "title": effective_title,
                "level": position_override.get(
                    "level",
                    _resolve_position_level(base_position_name),
                ),
                "departmentName": department_name,
                "headcount": 0,
                "openQuota": int(position_override.get("openQuota", "0")),
            }
        positions_by_id[position_id]["headcount"] += 1

    return list(positions_by_id.values()), title_override_lookup


@router.get("/contacts")
def contacts(
    request: Request,
    keyword: str | None = Query(default=None),
    departmentId: str | None = Query(default=None),
    onlineOnly: bool = Query(default=False),
    page: int = Query(default=1, ge=1),
    pageSize: int = Query(default=20, ge=1, le=100),
    _: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    query = select(User)
    if keyword:
        query = query.where(or_(User.name.contains(keyword), User.position.contains(keyword)))
    if departmentId:
        query = query.where(User.department_id == departmentId)
    if onlineOnly:
        query = query.where(User.is_online.is_(True))

    users = db.scalars(query.order_by(User.name.asc())).all()
    total = len(users)
    start = (page - 1) * pageSize
    end = start + pageSize
    items = [
        {
            "id": user.id,
            "name": user.name,
            "avatar": user.avatar,
            "department": user.department.name,
            "departmentId": user.department_id,
            "position": user.position,
            "isOnline": user.is_online,
            "mobileMasked": _mask_mobile(user.mobile),
        }
        for user in users[start:end]
    ]
    return success_response(request, paginated_response(page=page, page_size=pageSize, total=total, items=items))


@router.get("/departments/tree")
def department_tree(
    request: Request,
    _: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    departments = db.scalars(select(Department).order_by(Department.sort_no.asc())).all()
    users = db.scalars(select(User)).all()
    return success_response(request, _build_department_tree(departments, users))


@router.get("/admin/overview")
def admin_overview(
    request: Request,
    _: User = Depends(
        require_any_permission(
            "manageEmployees",
            "manageDepartments",
            "managePositions",
            "manageAccounts",
            "exportData",
        )
    ),
    db: Session = Depends(get_db),
) -> dict:
    departments = db.scalars(select(Department).order_by(Department.sort_no.asc())).all()
    users = db.scalars(select(User).order_by(User.name.asc())).all()
    employee_overrides = _load_applied_overrides(db, "employee")
    department_overrides = _load_applied_overrides(db, "department")
    position_overrides = _load_applied_overrides(db, "position")
    account_overrides = _load_applied_overrides(db, "account")

    department_tree_data = _build_department_tree(departments, users)
    department_items = []
    for department in _flatten_department_nodes(department_tree_data):
        override = department_overrides.get(department["id"], {})
        department_items.append(
            {
                **department,
                "name": override.get("name", department["name"]),
                "leader": override.get("leader", department["leader"]),
                "description": override.get("description", department["description"]),
            }
        )
    department_name_by_id = {
        department["id"]: department["name"] for department in department_items
    }
    position_items, position_title_lookup = _build_position_items(
        users,
        employee_overrides,
        department_name_by_id,
        position_overrides,
    )
    employees = [
        _serialize_employee(
            user,
            employee_overrides.get(user.id),
            department_names=department_name_by_id,
            position_title=position_title_lookup.get(
                (
                    employee_overrides.get(user.id, {}).get(
                        "departmentId",
                        user.department_id,
                    ),
                    employee_overrides.get(user.id, {}).get(
                        "position",
                        user.position,
                    ).strip()
                    or "Unassigned",
                ),
                {},
            ).get("title"),
        )
        for user in users
    ]
    employee_count_by_department: dict[str, int] = defaultdict(int)
    for employee in employees:
        employee_count_by_department[employee["departmentId"]] += 1

    accounts = [
        {
            "id": f"account-{user.id}",
            "name": user.name,
            "loginId": user.login_id,
            "role": resolve_access_profile(
                user,
                account_override=account_overrides.get(user.id),
            ).role,
            "permissions": resolve_access_profile(
                user,
                account_override=account_overrides.get(user.id),
            ).permissions,
            "enabled": resolve_access_profile(
                user,
                account_override=account_overrides.get(user.id),
            ).enabled,
            "boundUserIds": [user.id],
            "boundNames": [user.name],
            "boundDepartmentIds": [
                employee_overrides.get(user.id, {}).get("departmentId", user.department_id)
            ],
        }
        for user in users
    ]

    department_items = [
        {
            **department,
            "memberCount": employee_count_by_department.get(department["id"], 0),
        }
        for department in department_items
    ]
    position_items.sort(
        key=lambda item: (
            item["departmentName"],
            item["title"],
        )
    )

    return success_response(
        request,
        {
            "employees": employees,
            "departments": department_items,
            "positions": position_items,
            "accounts": accounts,
        },
    )


@router.get("/change-requests")
def list_change_requests(
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    allowed_entity_types = _allowed_change_request_entity_types(
        user=current_user,
        db=db,
    )
    if not allowed_entity_types:
        raise ForbiddenException(message="Insufficient permissions")
    requesters = {
        user.id: user.name
        for user in db.scalars(select(User)).all()
    }
    change_requests = db.scalars(
        select(ChangeRequest)
        .where(ChangeRequest.entity_type.in_(allowed_entity_types))
        .order_by(ChangeRequest.submitted_at.desc())
    ).all()
    items = [
        {
            "id": item.id,
            "requestNo": item.request_no,
            "entityType": item.entity_type,
            "entityId": item.entity_id,
            "entityName": item.entity_name,
            "changeType": item.change_type,
            "note": item.note,
            "status": item.status,
            "requesterName": requesters.get(item.requester_id, ""),
            "submittedAt": item.submitted_at.isoformat(),
        }
        for item in change_requests
    ]
    return success_response(
        request,
        paginated_response(
            page=1,
            page_size=len(items),
            total=len(items),
            items=items,
        ),
    )


@router.get("/change-requests/{request_id}")
def change_request_detail(
    request_id: str,
    request: Request,
    current_user: User = Depends(
        require_any_permission(
            "manageEmployees",
            "manageDepartments",
            "managePositions",
            "manageAccounts",
            "exportData",
        )
    ),
    db: Session = Depends(get_db),
) -> dict:
    change_request = db.get(ChangeRequest, request_id)
    if not change_request:
        raise NotFoundException(message="Change request not found")
    _assert_change_request_permission(
        user=current_user,
        change_request=change_request,
        db=db,
    )

    requester = db.get(User, change_request.requester_id)
    try:
        snapshot = json.loads(change_request.snapshot or "{}")
    except json.JSONDecodeError:
        snapshot = {}
    if not isinstance(snapshot, dict):
        snapshot = {}

    return success_response(
        request,
        {
            "id": change_request.id,
            "requestNo": change_request.request_no,
            "entityType": change_request.entity_type,
            "entityId": change_request.entity_id,
            "entityName": change_request.entity_name,
            "changeType": change_request.change_type,
            "note": change_request.note,
            "status": change_request.status,
            "requesterName": requester.name if requester else "",
            "submittedAt": change_request.submitted_at.isoformat(),
            "snapshot": {
                str(key): "" if value is None else str(value)
                for key, value in snapshot.items()
            },
        },
    )


@router.patch("/change-requests/{request_id}/approve")
def approve_change_request(
    request_id: str,
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    change_request = db.get(ChangeRequest, request_id)
    if not change_request:
        raise NotFoundException(message="Change request not found")
    _assert_change_request_permission(
        user=current_user,
        change_request=change_request,
        db=db,
    )
    if change_request.status != "DRAFTED":
        raise ValidationException(message="Only drafted change requests can be approved")

    change_request.status = "APPLIED"
    db.add(change_request)
    db.commit()
    db.refresh(change_request)

    requester = db.get(User, change_request.requester_id)
    try:
        snapshot = json.loads(change_request.snapshot or "{}")
    except json.JSONDecodeError:
        snapshot = {}
    if not isinstance(snapshot, dict):
        snapshot = {}

    return success_response(
        request,
        {
            "id": change_request.id,
            "requestNo": change_request.request_no,
            "entityType": change_request.entity_type,
            "entityId": change_request.entity_id,
            "entityName": change_request.entity_name,
            "changeType": change_request.change_type,
            "note": change_request.note,
            "status": change_request.status,
            "requesterName": requester.name if requester else "",
            "submittedAt": change_request.submitted_at.isoformat(),
            "snapshot": {
                str(key): "" if value is None else str(value)
                for key, value in snapshot.items()
            },
        },
    )


@router.patch("/change-requests/{request_id}/reject")
def reject_change_request(
    request_id: str,
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    change_request = db.get(ChangeRequest, request_id)
    if not change_request:
        raise NotFoundException(message="Change request not found")
    _assert_change_request_permission(
        user=current_user,
        change_request=change_request,
        db=db,
    )
    if change_request.status != "DRAFTED":
        raise ValidationException(message="Only drafted change requests can be rejected")

    change_request.status = "REJECTED"
    db.add(change_request)
    db.commit()
    db.refresh(change_request)

    requester = db.get(User, change_request.requester_id)
    try:
        snapshot = json.loads(change_request.snapshot or "{}")
    except json.JSONDecodeError:
        snapshot = {}
    if not isinstance(snapshot, dict):
        snapshot = {}

    return success_response(
        request,
        {
            "id": change_request.id,
            "requestNo": change_request.request_no,
            "entityType": change_request.entity_type,
            "entityId": change_request.entity_id,
            "entityName": change_request.entity_name,
            "changeType": change_request.change_type,
            "note": change_request.note,
            "status": change_request.status,
            "requesterName": requester.name if requester else "",
            "submittedAt": change_request.submitted_at.isoformat(),
            "snapshot": {
                str(key): "" if value is None else str(value)
                for key, value in snapshot.items()
            },
        },
    )


@router.get("/users/{user_id}")
def user_detail(
    user_id: str,
    request: Request,
    _: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    user = db.get(User, user_id)
    if not user:
        return success_response(request, None, message="user not found")
    return success_response(
        request,
        {
            "id": user.id,
            "name": user.name,
            "avatar": user.avatar,
            "department": user.department.name,
            "departmentId": user.department_id,
            "position": user.position,
            "email": user.email,
            "mobileMasked": _mask_mobile(user.mobile),
            "employeeNo": user.employee_no,
            "joinDate": user.created_at.isoformat(),
            "isOnline": user.is_online,
        },
    )


@router.patch("/admin/employees/{employee_id}")
def update_employee(
    employee_id: str,
    payload: UpdateEmployeeRequest,
    request: Request,
    current_user: User = Depends(require_any_permission("manageEmployees")),
    db: Session = Depends(get_db),
) -> dict:
    user = db.get(User, employee_id)
    if not user:
        raise NotFoundException(message="Employee not found")

    department = db.get(Department, payload.departmentId)
    if not department:
        raise ValidationException(message="Department not found")

    position = payload.position.strip()
    email = payload.email.strip()
    mobile = payload.mobile.strip()
    if not position or not email or not mobile:
        raise ValidationException(message="Position, email and mobile are required")

    snapshot = {
        "departmentId": department.id,
        "department": department.name,
        "position": position,
        "email": email,
        "mobile": mobile,
        "status": "Active",
    }
    applied_change = ChangeRequest(
        request_no=_build_change_request_no(),
        requester_id=current_user.id,
        entity_type="employee",
        entity_id=user.id,
        entity_name=user.name,
        change_type="direct_edit",
        note="Direct edit applied from enterprise admin",
        snapshot=json.dumps(snapshot, ensure_ascii=False),
        status="APPLIED",
    )
    db.add(applied_change)
    db.commit()
    db.refresh(applied_change)

    return success_response(request, _serialize_employee(user, snapshot))


@router.patch("/admin/departments/{department_id}")
def update_department(
    department_id: str,
    payload: UpdateDepartmentRequest,
    request: Request,
    current_user: User = Depends(require_any_permission("manageDepartments")),
    db: Session = Depends(get_db),
) -> dict:
    department = db.get(Department, department_id)
    if not department:
        raise NotFoundException(message="Department not found")

    name = payload.name.strip()
    leader = payload.leader.strip()
    description = payload.description.strip()
    if not name or not leader or not description:
        raise ValidationException(message="Name, leader and description are required")

    member_count = len(
        db.scalars(select(User).where(User.department_id == department_id)).all()
    )
    snapshot = {
        "name": name,
        "leader": leader,
        "description": description,
    }
    applied_change = ChangeRequest(
        request_no=_build_change_request_no(),
        requester_id=current_user.id,
        entity_type="department",
        entity_id=department.id,
        entity_name=department.name,
        change_type="direct_edit",
        note="Direct edit applied from enterprise admin",
        snapshot=json.dumps(snapshot, ensure_ascii=False),
        status="APPLIED",
    )
    db.add(applied_change)
    db.commit()
    db.refresh(applied_change)

    return success_response(
        request,
        {
            "id": department.id,
            "name": name,
            "leader": leader,
            "memberCount": member_count,
            "description": description,
        },
    )


@router.patch("/admin/accounts/{user_id}")
def update_account(
    user_id: str,
    payload: UpdateAccountRequest,
    request: Request,
    current_user: User = Depends(require_any_permission("manageAccounts")),
    db: Session = Depends(get_db),
) -> dict:
    user = db.get(User, user_id)
    if not user:
        raise NotFoundException(message="Account not found")
    if payload.role not in {"superAdmin", "hrManager", "departmentManager", "viewer"}:
        raise ValidationException(message="Role not supported")

    snapshot = {
        "role": payload.role,
        "enabled": str(payload.enabled).lower(),
    }
    applied_change = ChangeRequest(
        request_no=_build_change_request_no(),
        requester_id=current_user.id,
        entity_type="account",
        entity_id=user.id,
        entity_name=user.name,
        change_type="direct_edit",
        note="Direct edit applied from enterprise admin",
        snapshot=json.dumps(snapshot, ensure_ascii=False),
        status="APPLIED",
    )
    db.add(applied_change)
    db.commit()
    db.refresh(applied_change)

    profile = resolve_access_profile(user, account_override=snapshot)
    return success_response(
        request,
        {
            "id": f"account-{user.id}",
            "name": user.name,
            "loginId": user.login_id,
            "role": profile.role,
            "permissions": profile.permissions,
            "enabled": profile.enabled,
            "boundUserIds": [user.id],
            "boundNames": [user.name],
            "boundDepartmentIds": [user.department_id],
        },
    )


@router.patch("/admin/positions/{position_id}")
def update_position(
    position_id: str,
    payload: UpdatePositionRequest,
    request: Request,
    current_user: User = Depends(require_any_permission("managePositions")),
    db: Session = Depends(get_db),
) -> dict:
    users = db.scalars(select(User).order_by(User.name.asc())).all()
    employee_overrides = _load_applied_overrides(db, "employee")
    department_overrides = _load_applied_overrides(db, "department")
    position_overrides = _load_applied_overrides(db, "position")

    department_name_by_id = {}
    for department in db.scalars(select(Department).order_by(Department.sort_no.asc())).all():
        override = department_overrides.get(department.id, {})
        department_name_by_id[department.id] = override.get("name", department.name)

    position_items, _ = _build_position_items(
        users,
        employee_overrides,
        department_name_by_id,
        position_overrides,
    )
    current_position = next(
        (item for item in position_items if item["id"] == position_id),
        None,
    )
    if current_position is None:
        raise NotFoundException(message="Position not found")

    title = payload.title.strip()
    level = payload.level.strip()
    if not title or not level:
        raise ValidationException(message="Title and level are required")
    if payload.openQuota < 0:
        raise ValidationException(message="Vacancy must be zero or greater")

    snapshot = {
        "title": title,
        "level": level,
        "openQuota": str(payload.openQuota),
    }
    applied_change = ChangeRequest(
        request_no=_build_change_request_no(),
        requester_id=current_user.id,
        entity_type="position",
        entity_id=position_id,
        entity_name=current_position["title"],
        change_type="direct_edit",
        note="Direct edit applied from enterprise admin",
        snapshot=json.dumps(snapshot, ensure_ascii=False),
        status="APPLIED",
    )
    db.add(applied_change)
    db.commit()
    db.refresh(applied_change)

    return success_response(
        request,
        {
            **current_position,
            "title": title,
            "level": level,
            "openQuota": payload.openQuota,
        },
    )


@router.post("/change-requests")
def create_change_request(
    payload: CreateChangeRequestRequest,
    request: Request,
    current_user: User = Depends(
        require_any_permission(
            "manageEmployees",
            "manageDepartments",
            "managePositions",
            "manageAccounts",
        )
    ),
    db: Session = Depends(get_db),
) -> dict:
    change_request = ChangeRequest(
        request_no=_build_change_request_no(),
        requester_id=current_user.id,
        entity_type=payload.entityType,
        entity_id=payload.entityId,
        entity_name=payload.entityName,
        change_type=payload.changeType,
        note=payload.note,
        snapshot=json.dumps(payload.snapshot, ensure_ascii=False),
        status="DRAFTED",
    )
    db.add(change_request)
    db.commit()
    db.refresh(change_request)
    return success_response(
        request,
        {
            "id": change_request.id,
            "requestNo": change_request.request_no,
            "entityType": change_request.entity_type,
            "entityId": change_request.entity_id,
            "entityName": change_request.entity_name,
            "changeType": change_request.change_type,
            "note": change_request.note,
            "status": change_request.status,
            "submittedAt": change_request.submitted_at.isoformat(),
        },
    )
