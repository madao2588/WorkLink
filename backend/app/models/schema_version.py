from datetime import UTC, datetime
from uuid import uuid4

from sqlalchemy import DateTime, Integer, String
from sqlalchemy.orm import Mapped, mapped_column

from app.db.session import Base


class SchemaVersion(Base):
    __tablename__ = 'schema_versions'

    id: Mapped[str] = mapped_column(String(40), primary_key=True, default=lambda: f"sv_{uuid4().hex[:12]}")
    version: Mapped[int] = mapped_column(Integer, nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(UTC))
