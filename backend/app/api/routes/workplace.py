from fastapi import APIRouter, Depends, Request
from sqlalchemy.orm import Session

from app.core.deps import get_current_user
from app.core.response import success_response
from app.db.session import get_db
from app.models.entities import User
from app.services.dashboard import build_workplace_dashboard

router = APIRouter()


@router.get("/dashboard")
def dashboard(
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    return success_response(request, build_workplace_dashboard(db, current_user))
