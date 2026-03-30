from fastapi import APIRouter, Depends, Query, Request
from sqlalchemy import or_, select
from sqlalchemy.orm import Session

from app.core.deps import get_current_user
from app.core.response import paginated_response, success_response
from app.db.session import get_db
from app.models.entities import Department, User

router = APIRouter()


def _mask_mobile(mobile: str) -> str:
    if len(mobile) < 7:
        return mobile
    return f"{mobile[:3]}****{mobile[-4:]}"


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
    by_parent: dict[str | None, list[Department]] = {}
    for department in departments:
        by_parent.setdefault(department.parent_id, []).append(department)

    def build_node(parent_id: str | None) -> list[dict]:
        result = []
        for department in by_parent.get(parent_id, []):
            result.append(
                {
                    "id": department.id,
                    "name": department.name,
                    "parentId": department.parent_id,
                    "memberCount": len([user for user in users if user.department_id == department.id]),
                    "children": build_node(department.id),
                }
            )
        return result

    return success_response(request, build_node(None))


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
