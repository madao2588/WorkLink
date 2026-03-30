import logging
from uuid import uuid4

from fastapi import FastAPI, HTTPException, Request
from fastapi.exceptions import RequestValidationError
from fastapi.middleware.cors import CORSMiddleware

from app.api.router import api_router
from app.core.config import get_settings
from app.core.exceptions import AppException
from app.core.logging import configure_logging
from app.core.response import error_response

logger = logging.getLogger(__name__)


def _map_http_error_code(status_code: int) -> str:
    mapping = {
        400: "REQ_400",
        401: "AUTH_401",
        403: "AUTH_403",
        404: "RES_404",
        422: "REQ_422",
    }
    return mapping.get(status_code, f"HTTP_{status_code}")


def create_app() -> FastAPI:
    settings = get_settings()
    configure_logging(settings.log_level)

    app = FastAPI(title=settings.app_name, version="1.0.0", debug=settings.debug)
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.allowed_origins,
        allow_origin_regex=settings.allowed_origin_regex,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    @app.middleware("http")
    async def trace_middleware(request: Request, call_next):
        request.state.trace_id = request.headers.get("X-Trace-Id", uuid4().hex[:16])
        response = await call_next(request)
        response.headers["X-Trace-Id"] = request.state.trace_id
        return response

    @app.exception_handler(AppException)
    async def app_exception_handler(request: Request, exc: AppException):
        return error_response(
            request,
            status_code=exc.status_code,
            code=exc.code,
            message=exc.message,
            data=exc.data,
        )

    @app.exception_handler(HTTPException)
    async def http_exception_handler(request: Request, exc: HTTPException):
        message = exc.detail if isinstance(exc.detail, str) else "Request failed"
        return error_response(
            request,
            status_code=exc.status_code,
            code=_map_http_error_code(exc.status_code),
            message=message,
        )

    @app.exception_handler(RequestValidationError)
    async def validation_exception_handler(request: Request, exc: RequestValidationError):
        return error_response(
            request,
            status_code=422,
            code="REQ_422",
            message="Invalid request parameters",
            data=exc.errors(),
        )

    @app.exception_handler(Exception)
    async def unhandled_exception_handler(request: Request, exc: Exception):
        logger.error("Unhandled exception on %s", request.url.path, exc_info=exc)
        message = str(exc) if settings.expose_internal_errors else "Internal server error"
        return error_response(
            request,
            status_code=500,
            code="SYS_500",
            message=message,
        )

    app.include_router(api_router, prefix=settings.api_v1_prefix)
    return app


app = create_app()
