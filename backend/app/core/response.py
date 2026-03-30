from typing import Any

from fastapi import Request
from fastapi.responses import JSONResponse


def success_response(request: Request, data: Any, message: str = "success") -> dict[str, Any]:
    return {
        "code": "OK",
        "message": message,
        "data": data,
        "traceId": getattr(request.state, "trace_id", None),
    }


def error_response(
    request: Request,
    *,
    status_code: int,
    code: str,
    message: str,
    data: Any | None = None,
) -> JSONResponse:
    return JSONResponse(
        status_code=status_code,
        content={
            "code": code,
            "message": message,
            "data": data,
            "traceId": getattr(request.state, "trace_id", None),
        },
    )


def paginated_response(*, page: int, page_size: int, total: int, items: list[dict]) -> dict[str, Any]:
    return {
        "page": page,
        "pageSize": page_size,
        "total": total,
        "items": items,
    }
