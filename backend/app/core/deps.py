from fastapi import Depends, Header
from sqlalchemy.orm import Session

from app.core.exceptions import UnauthorizedException
from app.core.security import get_subject_from_token
from app.db.session import get_db
from app.models.entities import User


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
    return user
