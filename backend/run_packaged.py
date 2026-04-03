from __future__ import annotations

import os
import sys
from pathlib import Path

import uvicorn


def _runtime_dir() -> Path:
    if getattr(sys, "frozen", False):
        return Path(sys.executable).resolve().parent
    return Path(__file__).resolve().parent


def main() -> None:
    runtime_dir = _runtime_dir()
    os.chdir(runtime_dir)

    os.environ.setdefault("APP_ENV", "production")
    os.environ.setdefault("APP_DEBUG", "false")
    os.environ.setdefault("APP_EXPOSE_INTERNAL_ERRORS", "false")
    os.environ.setdefault("APP_LOG_LEVEL", "INFO")
    os.environ.setdefault("SECRET_KEY", "worklink-portable-local-secret-key")
    os.environ.setdefault("SERVE_FRONTEND", "false")
    os.environ.setdefault("DATABASE_URL", f"duckdb:///{(runtime_dir / 'worklink.duckdb').as_posix()}")

    from app.main import app

    uvicorn.run(
        app,
        host="127.0.0.1",
        port=8000,
        reload=False,
        log_level="info",
    )


if __name__ == "__main__":
    main()
