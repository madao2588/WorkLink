from functools import lru_cache
from typing import Literal

from pydantic import Field, field_validator, model_validator
from pydantic_settings import BaseSettings, SettingsConfigDict

AppEnvironment = Literal["development", "test", "production"]
DEFAULT_SECRET_KEY = "change-this-in-production"


class Settings(BaseSettings):
    app_name: str = "WorkLink Backend"
    api_v1_prefix: str = "/api/v1"
    environment: AppEnvironment = Field(default="development", validation_alias="APP_ENV")
    debug: bool = Field(default=False, validation_alias="APP_DEBUG")
    log_level: str = Field(default="INFO", validation_alias="APP_LOG_LEVEL")
    expose_internal_errors: bool = Field(default=False, validation_alias="APP_EXPOSE_INTERNAL_ERRORS")
    secret_key: str = DEFAULT_SECRET_KEY
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

    @field_validator("environment", mode="before")
    @classmethod
    def normalize_environment(cls, value: object) -> object:
        if isinstance(value, str):
            return value.lower()
        return value

    @field_validator("log_level")
    @classmethod
    def normalize_log_level(cls, value: str) -> str:
        return value.upper()

    @field_validator("allowed_origins", mode="before")
    @classmethod
    def parse_allowed_origins(cls, value: object) -> object:
        if isinstance(value, str):
            return [item.strip() for item in value.split(",") if item.strip()]
        return value

    @model_validator(mode="after")
    def validate_production_settings(self) -> "Settings":
        if self.environment == "production" and self.secret_key == DEFAULT_SECRET_KEY:
            raise ValueError("SECRET_KEY must be changed before running in production")
        if self.environment == "production" and self.debug:
            raise ValueError("DEBUG must be false in production")
        if self.environment == "production" and self.expose_internal_errors:
            raise ValueError("EXPOSE_INTERNAL_ERRORS must be false in production")
        return self

    @property
    def is_production(self) -> bool:
        return self.environment == "production"


@lru_cache
def get_settings() -> Settings:
    return Settings()


def clear_settings_cache() -> None:
    get_settings.cache_clear()
