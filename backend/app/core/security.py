from datetime import UTC, datetime, timedelta
from hashlib import pbkdf2_hmac
from secrets import token_hex, token_urlsafe
from typing import Any

from jose import JWTError, jwt

from app.core.config import get_settings

ALGORITHM = "HS256"


def _hash_bytes(password: str, salt: str) -> bytes:
    return pbkdf2_hmac("sha256", password.encode("utf-8"), salt.encode("utf-8"), 120000)


def get_password_hash(password: str) -> str:
    salt = token_hex(16)
    digest = _hash_bytes(password, salt).hex()
    return f"{salt}${digest}"


def verify_password(password: str, password_hash: str) -> bool:
    try:
        salt, expected = password_hash.split("$", 1)
    except ValueError:
        return False
    return _hash_bytes(password, salt).hex() == expected


def create_access_token(subject: str, expires_minutes: int | None = None) -> str:
    settings = get_settings()
    expire_delta = timedelta(minutes=expires_minutes or settings.access_token_expire_minutes)
    expire = datetime.now(UTC) + expire_delta
    payload: dict[str, Any] = {"sub": subject, "type": "access", "exp": expire}
    return jwt.encode(payload, settings.secret_key, algorithm=ALGORITHM)


def decode_token(token: str) -> dict[str, Any]:
    settings = get_settings()
    return jwt.decode(token, settings.secret_key, algorithms=[ALGORITHM])


def create_refresh_token() -> str:
    return token_urlsafe(32)


def get_subject_from_token(token: str) -> str | None:
    try:
        payload = decode_token(token)
    except JWTError:
        return None
    if payload.get("type") != "access":
        return None
    return payload.get("sub")
