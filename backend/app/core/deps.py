from collections.abc import Callable

from fastapi import Depends, Header
from sqlalchemy.orm import Session

from app.core.exceptions import ForbiddenException, UnauthorizedException
from app.core.security import get_subject_from_token
from app.db.session import get_db
from app.models.entities import User
from app.services.access_control import resolve_access_profile


def get_current_user(
    authorization: str | None = Header(default=None),
    db: Session = Depends(get_db),
) -> User:
    if not authorization or not authorization.lower().startswith("bearer "):
        raise UnauthorizedException(message="Missing bearer token")
    token = authorization.split(" ", 1)[1]
    subject = get_subject_from_token(token)
    if not subject:
        raise UnauthorizedException(message="Invalid token")
    user = db.get(User, subject)
    if not user:
        raise UnauthorizedException(message="User not found")
    access_profile = resolve_access_profile(user, db=db)
    if not access_profile.enabled:
        raise UnauthorizedException(message="Account disabled")
    return user


def require_any_permission(*permissions: str) -> Callable[[User], User]:
    def dependency(
        user: User = Depends(get_current_user),
        db: Session = Depends(get_db),
    ) -> User:
        access_profile = resolve_access_profile(user, db=db)
        if any(permission in access_profile.permissions for permission in permissions):
            return user
        raise ForbiddenException(message="Insufficient permissions")

    return dependency
