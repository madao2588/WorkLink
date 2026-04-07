from __future__ import annotations

from dataclasses import dataclass
import json

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.models.entities import ChangeRequest
from app.models.entities import User


@dataclass(frozen=True)
class AccessProfile:
    role: str
    permissions: list[str]
    enabled: bool


PERMISSIONS_BY_ROLE: dict[str, list[str]] = {
    "superAdmin": [
        "manageEmployees",
        "manageDepartments",
        "managePositions",
        "manageAccounts",
        "exportData",
        "viewDashboard",
    ],
    "hrManager": [
        "manageEmployees",
        "manageDepartments",
        "managePositions",
        "exportData",
        "viewDashboard",
    ],
    "departmentManager": [
        "manageEmployees",
        "viewDashboard",
    ],
    "viewer": [
        "viewDashboard",
    ],
}


def _default_role_for_user(user: User) -> str:
    if user.login_id in {"admin", "madao"}:
        return "superAdmin"
    if user.department_id == "dept-hr":
        return "hrManager"
    if user.department_id == "dept-rd":
        return "departmentManager"
    return "viewer"


def _load_account_override(
    db: Session,
    user_id: str,
) -> dict[str, str] | None:
    change_request = db.scalar(
        select(ChangeRequest)
        .where(
            ChangeRequest.entity_type == "account",
            ChangeRequest.entity_id == user_id,
            ChangeRequest.status == "APPLIED",
        )
        .order_by(ChangeRequest.submitted_at.desc())
        .limit(1)
    )
    if not change_request:
        return None
    try:
        payload = json.loads(change_request.snapshot or "{}")
    except json.JSONDecodeError:
        return None
    if not isinstance(payload, dict):
        return None
    return {
        str(key): str(value)
        for key, value in payload.items()
        if value is not None
    }


def resolve_access_profile(
    user: User,
    *,
    db: Session | None = None,
    account_override: dict[str, str] | None = None,
) -> AccessProfile:
    effective_override = account_override
    if effective_override is None and db is not None:
        effective_override = _load_account_override(db, user.id)

    role = _default_role_for_user(user)
    if effective_override is not None:
        role = effective_override.get("role", role)
    if role not in PERMISSIONS_BY_ROLE:
        role = "viewer"

    enabled = True
    if effective_override is not None:
        enabled = effective_override.get("enabled", "true").lower() == "true"

    return AccessProfile(
        role=role,
        permissions=list(PERMISSIONS_BY_ROLE.get(role, PERMISSIONS_BY_ROLE["viewer"]))
        if enabled
        else [],
        enabled=enabled,
    )
