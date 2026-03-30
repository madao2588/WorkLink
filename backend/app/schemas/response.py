from __future__ import annotations

from typing import Any, Generic, TypeVar

from pydantic import BaseModel

T = TypeVar('T')


class ApiResponse(BaseModel, Generic[T]):
    code: str
    message: str
    data: T | None
    traceId: str | None


class UserInfo(BaseModel):
    id: str
    name: str
    avatar: str
    department: str
    departmentId: str | None = None
    position: str
    isOnline: bool
    employeeNo: str
    email: str | None = None
    mobileMasked: str | None = None


class AuthTokens(BaseModel):
    accessToken: str
    refreshToken: str
    expiresIn: int


class LoginData(AuthTokens):
    user: UserInfo


class LoginResponse(ApiResponse[LoginData]):
    pass


class TokenResponse(ApiResponse[AuthTokens]):
    pass


class UserInfoResponse(ApiResponse[UserInfo]):
    pass


class HealthResponse(ApiResponse[dict[str, str]]):
    pass


class BooleanResponse(ApiResponse[dict[str, bool]]):
    pass
