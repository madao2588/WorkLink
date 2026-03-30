from fastapi import APIRouter, Depends, Query, Request
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.deps import get_current_user
from app.core.response import paginated_response, success_response
from app.db.session import get_db
from app.models.entities import Notification, User

router = APIRouter()


@router.get("")
def notification_list(
    request: Request,
    type: str | None = Query(default=None),
    isRead: bool | None = Query(default=None),
    page: int = Query(default=1, ge=1),
    pageSize: int = Query(default=20, ge=1, le=100),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    query = select(Notification).where(Notification.user_id == current_user.id)
    if type:
        query = query.where(Notification.type == type.upper())
    if isRead is not None:
        query = query.where(Notification.is_read == isRead)
    notifications = db.scalars(query.order_by(Notification.created_at.desc())).all()
    items = [
        {
            "id": item.id,
            "title": item.title,
            "content": item.content,
            "type": item.type,
            "bizId": item.biz_id,
            "isRead": item.is_read,
            "createdAt": item.created_at.isoformat(),
        }
        for item in notifications
    ]
    total = len(items)
    start = (page - 1) * pageSize
    end = start + pageSize
    return success_response(request, paginated_response(page=page, page_size=pageSize, total=total, items=items[start:end]))


@router.post("/{notification_id}/read")
def mark_notification_read(
    notification_id: str,
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    notification = db.get(Notification, notification_id)
    if notification and notification.user_id == current_user.id:
        notification.is_read = True
        db.commit()
    return success_response(request, {"id": notification_id, "isRead": True})
