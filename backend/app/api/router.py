from fastapi import APIRouter

from app.api.routes import approval, attendance, auth, chat, health, notifications, org, profile, workplace

api_router = APIRouter()
api_router.include_router(health.router, tags=["health"])
api_router.include_router(auth.router, prefix="/auth", tags=["auth"])
api_router.include_router(org.router, prefix="/org", tags=["org"])
api_router.include_router(chat.router, prefix="/chat", tags=["chat"])
api_router.include_router(approval.router, prefix="/approval", tags=["approval"])
api_router.include_router(attendance.router, prefix="/attendance", tags=["attendance"])
api_router.include_router(profile.router, prefix="/profile", tags=["profile"])
api_router.include_router(workplace.router, prefix="/workplace", tags=["workplace"])
api_router.include_router(notifications.router, prefix="/notifications", tags=["notifications"])
