from datetime import UTC, date, datetime

from fastapi import APIRouter, Depends, Query, Request
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.deps import get_current_user
from app.core.response import paginated_response, success_response
from app.db.session import get_db
from app.models.entities import AttendanceRecord, User
from app.schemas.api import CheckInRequest

router = APIRouter()


@router.get("/today")
def attendance_today(
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    record = db.scalar(
        select(AttendanceRecord).where(
            AttendanceRecord.user_id == current_user.id,
            AttendanceRecord.record_date == date.today(),
        )
    )
    return success_response(
        request,
        {
            "date": date.today().isoformat(),
            "status": record.status if record else "NOT_CHECKED_IN",
            "hasCheckedIn": bool(record and record.check_in_time),
            "checkInTime": record.check_in_time.isoformat() if record and record.check_in_time else None,
            "checkOutTime": record.check_out_time.isoformat() if record and record.check_out_time else None,
            "ruleName": "标准班次",
            "isLate": record.is_late if record else False,
        },
    )


@router.post("/check-in")
def check_in(
    _: CheckInRequest,
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    record = db.scalar(
        select(AttendanceRecord).where(
            AttendanceRecord.user_id == current_user.id,
            AttendanceRecord.record_date == date.today(),
        )
    )
    now = datetime.now(UTC)
    if not record:
        record = AttendanceRecord(
            user_id=current_user.id,
            record_date=date.today(),
            check_in_time=now,
            status="CHECKED_IN",
            is_late=False,
        )
        db.add(record)
    else:
        record.check_in_time = record.check_in_time or now
        record.status = "CHECKED_IN"
    db.commit()
    return success_response(
        request,
        {
            "status": record.status,
            "checkInTime": record.check_in_time.isoformat() if record.check_in_time else None,
            "hasCheckedIn": True,
        },
    )


@router.get("/records")
def attendance_records(
    request: Request,
    month: str | None = Query(default=None),
    page: int = Query(default=1, ge=1),
    pageSize: int = Query(default=20, ge=1, le=100),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    records = db.scalars(
        select(AttendanceRecord).where(AttendanceRecord.user_id == current_user.id).order_by(AttendanceRecord.record_date.desc())
    ).all()
    if month:
        records = [record for record in records if record.record_date.isoformat().startswith(month)]
    items = [
        {
            "date": record.record_date.isoformat(),
            "checkInTime": record.check_in_time.isoformat() if record.check_in_time else None,
            "checkOutTime": record.check_out_time.isoformat() if record.check_out_time else None,
            "status": record.status,
            "isLate": record.is_late,
            "isAbsent": record.status == "ABSENT",
        }
        for record in records
    ]
    total = len(items)
    start = (page - 1) * pageSize
    end = start + pageSize
    return success_response(request, paginated_response(page=page, page_size=pageSize, total=total, items=items[start:end]))
