from contextlib import asynccontextmanager
from uuid import uuid4

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.api.router import api_router
from app.core.config import get_settings
from app.db.session import Base, SessionLocal, engine
from app.services.bootstrap import seed_database
from app.services.migration import apply_migrations

settings = get_settings()


def initialize_database() -> None:
    Base.metadata.create_all(bind=engine)
    db = SessionLocal()
    try:
        apply_migrations(db)
        seed_database(db)
    finally:
        db.close()


@asynccontextmanager
async def lifespan(_: FastAPI):
    initialize_database()
    yield


app = FastAPI(title=settings.app_name, version="1.0.0", lifespan=lifespan)
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


@app.exception_handler(Exception)
async def unhandled_exception_handler(request: Request, exc: Exception):
    return JSONResponse(
        status_code=500,
        content={
            "code": "SYS_500",
            "message": str(exc),
            "data": None,
            "traceId": getattr(request.state, "trace_id", None),
        },
    )


app.include_router(api_router, prefix=settings.api_v1_prefix)
