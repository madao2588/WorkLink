from fastapi import APIRouter, Depends, Request
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.deps import get_current_user
from app.core.response import success_response
from app.db.session import get_db
from app.models.entities import Badge, Feedback, RefreshToken, SalarySlip, User, UserSetting
from app.schemas.api import FeedbackRequest, UpdateSettingRequest
from app.services.dashboard import build_profile_overview

router = APIRouter()


def _mask_value(value: str) -> str:
    if not value:
        return value
    if "@" in value:
        name, domain = value.split("@", 1)
        return f"{name[:2]}***@{domain}"
    if len(value) >= 7:
        return f"{value[:3]}****{value[-4:]}"
    return value


@router.get("/overview")
def profile_overview(
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    return success_response(request, build_profile_overview(db, current_user))


@router.get("/salary-slips")
def salary_slips(
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    items = db.scalars(
        select(SalarySlip).where(SalarySlip.user_id == current_user.id).order_by(SalarySlip.salary_month.desc())
    ).all()
    return success_response(
        request,
        [
            {
                "salarySlipId": item.id,
                "month": item.salary_month,
                "netAmount": float(item.net_amount),
                "grossAmount": float(item.gross_amount),
                "status": item.status,
                "issuedAt": item.issued_at.isoformat(),
            }
            for item in items
        ],
    )


@router.get("/salary-slips/{salary_slip_id}")
def salary_slip_detail(
    salary_slip_id: str,
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    item = db.get(SalarySlip, salary_slip_id)
    if not item or item.user_id != current_user.id:
        return success_response(request, None, message="salary slip not found")
    return success_response(
        request,
        {
            "salarySlipId": item.id,
            "month": item.salary_month,
            "grossAmount": float(item.gross_amount),
            "netAmount": float(item.net_amount),
            "items": [
                {"itemName": "基本工资", "itemType": "income", "amount": float(item.gross_amount) - 1200},
                {"itemName": "绩效奖金", "itemType": "income", "amount": 1200.0},
                {"itemName": "社保个税", "itemType": "deduction", "amount": float(item.gross_amount) - float(item.net_amount)},
            ],
            "issuedAt": item.issued_at.isoformat(),
        },
    )


@router.get("/badges")
def badges(
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    items = db.scalars(select(Badge).where(Badge.user_id == current_user.id).order_by(Badge.earned_at.desc())).all()
    return success_response(
        request,
        [
            {
                "badgeId": item.id,
                "name": item.name,
                "description": item.description,
                "icon": item.icon,
                "earnedAt": item.earned_at.isoformat(),
            }
            for item in items
        ],
    )


@router.get("/account-security")
def account_security(
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    devices = db.scalars(
        select(RefreshToken).where(RefreshToken.user_id == current_user.id).order_by(RefreshToken.created_at.desc())
    ).all()
    return success_response(
        request,
        {
            "mobileMasked": _mask_value(current_user.mobile),
            "emailMasked": _mask_value(current_user.email),
            "passwordUpdatedAt": current_user.created_at.isoformat(),
            "devices": [
                {
                    "deviceId": str(device.id),
                    "deviceName": device.device_name,
                    "platform": device.platform,
                    "lastLoginAt": device.created_at.isoformat(),
                    "current": index == 0,
                }
                for index, device in enumerate(devices)
            ],
            "mfaEnabled": False,
        },
    )


@router.get("/settings")
def get_settings(
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    setting = db.get(UserSetting, current_user.id)
    return success_response(
        request,
        {
            "notificationsEnabled": setting.notifications_enabled if setting else True,
            "soundEnabled": setting.sound_enabled if setting else True,
            "language": setting.language if setting else "zh-CN",
            "themeMode": setting.theme_mode if setting else "light",
            "cacheSize": "18.2 MB",
        },
    )


@router.put("/settings")
def update_settings(
    payload: UpdateSettingRequest,
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    setting = db.get(UserSetting, current_user.id)
    if not setting:
        setting = UserSetting(user_id=current_user.id)
        db.add(setting)
    setting.notifications_enabled = payload.notificationsEnabled
    setting.sound_enabled = payload.soundEnabled
    setting.language = payload.language
    setting.theme_mode = payload.themeMode
    db.commit()
    return success_response(
        request,
        {
            "notificationsEnabled": setting.notifications_enabled,
            "soundEnabled": setting.sound_enabled,
            "language": setting.language,
            "themeMode": setting.theme_mode,
            "cacheSize": "18.2 MB",
        },
    )


@router.post("/feedback")
def submit_feedback(
    payload: FeedbackRequest,
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    feedback = Feedback(
        user_id=current_user.id,
        category=payload.category,
        content=payload.content,
        contact=payload.contact or "",
    )
    db.add(feedback)
    db.commit()
    return success_response(
        request,
        {
            "feedbackId": feedback.id,
            "status": feedback.status,
            "submittedAt": feedback.submitted_at.isoformat(),
        },
    )
