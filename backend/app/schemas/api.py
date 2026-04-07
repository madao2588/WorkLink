from typing import Any

from pydantic import BaseModel, Field


class LoginRequest(BaseModel):
    loginId: str
    password: str
    deviceName: str = "Desktop"
    platform: str = "windows"


class RefreshTokenRequest(BaseModel):
    refreshToken: str


class LogoutRequest(BaseModel):
    refreshToken: str


class SendMessageRequest(BaseModel):
    messageType: str = "TEXT"
    content: str
    clientMessageId: str | None = None
    attachments: list[dict[str, Any]] = Field(default_factory=list)


class MarkReadRequest(BaseModel):
    lastReadMessageId: str | None = None


class ConversationPreferenceRequest(BaseModel):
    isPinned: bool | None = None
    isMuted: bool | None = None


class ApprovalActionRequest(BaseModel):
    comment: str | None = None
    reason: str | None = None


class CreateApprovalRequest(BaseModel):
    templateCode: str
    title: str
    reason: str
    formData: dict[str, Any] = Field(default_factory=dict)
    attachments: list[dict[str, Any]] = Field(default_factory=list)


class CheckInRequest(BaseModel):
    deviceId: str = "desktop-default"
    latitude: float | None = None
    longitude: float | None = None
    address: str | None = None


class UpdateSettingRequest(BaseModel):
    notificationsEnabled: bool
    soundEnabled: bool
    language: str
    themeMode: str


class FeedbackRequest(BaseModel):
    category: str = "general"
    content: str
    contact: str | None = None
    attachments: list[dict[str, Any]] = Field(default_factory=list)


class CreateChangeRequestRequest(BaseModel):
    entityType: str
    entityId: str
    entityName: str
    changeType: str
    note: str
    snapshot: dict[str, str] = Field(default_factory=dict)


class UpdateEmployeeRequest(BaseModel):
    departmentId: str
    position: str
    email: str
    mobile: str


class UpdateDepartmentRequest(BaseModel):
    name: str
    leader: str
    description: str


class UpdateAccountRequest(BaseModel):
    role: str
    enabled: bool


class UpdatePositionRequest(BaseModel):
    title: str
    level: str
    openQuota: int
