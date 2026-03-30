from fastapi import APIRouter, Request

from app.core.response import success_response
from app.schemas.response import HealthResponse

router = APIRouter()


@router.get("/health", response_model=HealthResponse)
def health_check(request: Request) -> dict:
    return success_response(request, {"status": "ok"})
