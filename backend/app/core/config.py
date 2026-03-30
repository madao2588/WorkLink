from functools import lru_cache

from pydantic import field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "WorkLink Backend"
    api_v1_prefix: str = "/api/v1"
    environment: str = "development"
    secret_key: str = "change-this-in-production"
    access_token_expire_minutes: int = 120
    database_url: str = "duckdb:///./worklink.duckdb"
    allowed_origin_regex: str = r"^https?://(localhost|127\.0\.0\.1)(:\d+)?$"
    allowed_origins: list[str] = [
        "http://localhost:3000",
        "http://localhost:8080",
        "http://localhost:5173",
        "http://127.0.0.1:8000",
    ]

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        enable_decoding=False,
    )

    @field_validator("allowed_origins", mode="before")
    @classmethod
    def parse_allowed_origins(cls, value: object) -> object:
        if isinstance(value, str):
            return [item.strip() for item in value.split(",") if item.strip()]
        return value

    @field_validator("secret_key")
    @classmethod
    def validate_secret_key(cls, value: str, info: field_validator) -> str:
        if info.data.get("environment") == "production" and value == "change-this-in-production":
            raise ValueError("SECRET_KEY must be changed before running in production")
        return value


@lru_cache
def get_settings() -> Settings:
    return Settings()
