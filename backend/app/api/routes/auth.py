from datetime import UTC, datetime, timedelta

from fastapi import APIRouter, Depends, Request
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.deps import get_current_user
from app.core.exceptions import UnauthorizedException
from app.core.response import success_response
from app.core.security import create_access_token, create_refresh_token, verify_password
from app.db.session import get_db
from app.models.entities import LoginLog, RefreshToken, User
from app.schemas.api import LoginRequest, LogoutRequest, RefreshTokenRequest
from app.schemas.response import BooleanResponse, LoginResponse, TokenResponse, UserInfoResponse

router = APIRouter()


def _mask_mobile(mobile: str) -> str:
    if len(mobile) < 7:
        return mobile
    return f"{mobile[:3]}****{mobile[-4:]}"


@router.post("/login", response_model=LoginResponse)
def login(payload: LoginRequest, request: Request, db: Session = Depends(get_db)) -> dict:
    user = db.scalar(select(User).where(User.login_id == payload.loginId))
    if not user or not verify_password(payload.password, user.password_hash):
        raise UnauthorizedException(message="Invalid credentials")

    access_token = create_access_token(user.id)
    refresh_token = create_refresh_token()
    expires_at = datetime.now(UTC) + timedelta(days=7)

    db.add(
        RefreshToken(
            user_id=user.id,
            token=refresh_token,
            device_name=payload.deviceName,
            platform=payload.platform,
            expires_at=expires_at,
        )
    )
    db.add(
        LoginLog(
            user_id=user.id,
            device_name=payload.deviceName,
            platform=payload.platform,
            ip=request.client.host if request.client else "",
            status="SUCCESS",
        )
    )
    user.is_online = True
    db.commit()

    return success_response(
        request,
        {
            "accessToken": access_token,
            "refreshToken": refresh_token,
            "expiresIn": 60 * 60 * 2,
            "user": {
                "id": user.id,
                "name": user.name,
                "avatar": user.avatar,
                "department": user.department.name,
                "position": user.position,
                "isOnline": user.is_online,
                "employeeNo": user.employee_no,
            },
        },
    )


@router.post("/refresh-token", response_model=TokenResponse)
def refresh_access_token(payload: RefreshTokenRequest, request: Request, db: Session = Depends(get_db)) -> dict:
    token_record = db.scalar(select(RefreshToken).where(RefreshToken.token == payload.refreshToken))
    if not token_record or token_record.revoked or token_record.expires_at < datetime.now(UTC):
        raise UnauthorizedException(message="Invalid refresh token")

    access_token = create_access_token(token_record.user_id)
    return success_response(
        request,
        {
            "accessToken": access_token,
            "refreshToken": token_record.token,
            "expiresIn": 60 * 60 * 2,
        },
    )


@router.post("/logout", response_model=BooleanResponse)
def logout(payload: LogoutRequest, request: Request, db: Session = Depends(get_db)) -> dict:
    token_record = db.scalar(select(RefreshToken).where(RefreshToken.token == payload.refreshToken))
    if token_record:
        token_record.revoked = True
        db.commit()
    return success_response(request, {"loggedOut": True})


@router.get("/me", response_model=UserInfoResponse)
def me(request: Request, user: User = Depends(get_current_user)) -> dict:
    return success_response(
        request,
        {
            "id": user.id,
            "name": user.name,
            "avatar": user.avatar,
            "department": user.department.name,
            "departmentId": user.department_id,
            "position": user.position,
            "isOnline": user.is_online,
            "employeeNo": user.employee_no,
            "email": user.email,
            "mobileMasked": _mask_mobile(user.mobile),
        },
    )


@router.get("/devices")
def devices(
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    tokens = db.scalars(
        select(RefreshToken).where(RefreshToken.user_id == current_user.id).order_by(RefreshToken.created_at.desc())
    ).all()
    return success_response(
        request,
        [
            {
                "deviceId": str(token.id),
                "deviceName": token.device_name,
                "platform": token.platform,
                "ip": "127.0.0.1",
                "lastLoginAt": token.created_at.isoformat(),
                "current": index == 0,
            }
            for index, token in enumerate(tokens)
        ],
    )
