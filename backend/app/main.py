import logging
from pathlib import Path
from uuid import uuid4

from fastapi import FastAPI, HTTPException, Request
from fastapi.exceptions import RequestValidationError
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse

from app.api.router import api_router
from app.core.config import get_settings
from app.core.exceptions import AppException
from app.core.logging import configure_logging
from app.core.response import error_response

logger = logging.getLogger(__name__)
BACKEND_ROOT = Path(__file__).resolve().parents[1]
RESERVED_FRONTEND_PREFIXES = ("/api", "/docs", "/redoc", "/openapi.json")


def _map_http_error_code(status_code: int) -> str:
    mapping = {
        400: "REQ_400",
        401: "AUTH_401",
        403: "AUTH_403",
        404: "RES_404",
        422: "REQ_422",
    }
    return mapping.get(status_code, f"HTTP_{status_code}")


def _resolve_frontend_root(frontend_web_root: str) -> Path:
    candidate = Path(frontend_web_root)
    if not candidate.is_absolute():
        candidate = BACKEND_ROOT / candidate
    return candidate.resolve()


def _is_frontend_request(path: str, api_v1_prefix: str) -> bool:
    if path.startswith(api_v1_prefix):
        return False
    return not path.startswith(RESERVED_FRONTEND_PREFIXES)


def _resolve_requested_frontend_file(frontend_root: Path, requested_path: str) -> Path | None:
    relative_path = requested_path.lstrip("/")
    candidate = (frontend_root / relative_path).resolve()
    try:
        candidate.relative_to(frontend_root)
    except ValueError:
        return None

    if candidate.is_dir():
        candidate = candidate / "index.html"

    return candidate


def create_app() -> FastAPI:
    settings = get_settings()
    configure_logging(settings.log_level)
    frontend_root = _resolve_frontend_root(settings.frontend_web_root)

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

    if settings.serve_frontend and frontend_root.joinpath("index.html").exists():
        @app.api_route("/", methods=["GET", "HEAD"], include_in_schema=False)
        @app.api_route("/{full_path:path}", methods=["GET", "HEAD"], include_in_schema=False)
        async def serve_frontend(request: Request, full_path: str = ""):
            if not _is_frontend_request(request.url.path, settings.api_v1_prefix):
                raise HTTPException(status_code=404, detail="Not found")

            requested_file = _resolve_requested_frontend_file(frontend_root, full_path)
            if requested_file is None:
                raise HTTPException(status_code=404, detail="Not found")

            if requested_file.is_file():
                response = FileResponse(requested_file)
                if requested_file.name == "index.html":
                    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
                return response

            if Path(full_path).suffix:
                raise HTTPException(status_code=404, detail="Not found")

            response = FileResponse(frontend_root / "index.html")
            response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
            return response
    elif settings.serve_frontend:
        logger.warning("Frontend serving enabled, but index.html was not found at %s", frontend_root)

    return app


app = create_app()
