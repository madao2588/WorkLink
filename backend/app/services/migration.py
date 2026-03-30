from sqlalchemy import select
from sqlalchemy.orm import Session

from app.models.schema_version import SchemaVersion

CURRENT_SCHEMA_VERSION = 1


def apply_migrations(db: Session) -> None:
    current_version = db.scalar(select(SchemaVersion.version).order_by(SchemaVersion.id.desc()).limit(1))
    if current_version is None:
        db.add(SchemaVersion(version=CURRENT_SCHEMA_VERSION))
        db.commit()
        return

    if current_version >= CURRENT_SCHEMA_VERSION:
        return

    # Placeholder for future migration steps.
    # Each version bump should be implemented here as a migration block.
    for next_version in range(int(current_version) + 1, CURRENT_SCHEMA_VERSION + 1):
        _apply_migration(db, next_version)
    db.add(SchemaVersion(version=CURRENT_SCHEMA_VERSION))
    db.commit()


def _apply_migration(db: Session, version: int) -> None:
    if version == 1:
        # Version 1 is the initial schema; it is created by metadata already.
        return
    raise RuntimeError(f'Unsupported migration version: {version}')
