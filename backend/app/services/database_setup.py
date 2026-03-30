import logging

from app.db.session import Base, SessionLocal, engine
from app.services.bootstrap import seed_database
from app.services.migration import apply_migrations

logger = logging.getLogger(__name__)


def initialize_database(*, run_migrations: bool = True, seed: bool = False) -> None:
    Base.metadata.create_all(bind=engine)
    db = SessionLocal()
    try:
        if run_migrations:
            logger.info("Applying database migrations")
            apply_migrations(db)
        if seed:
            logger.info("Seeding database")
            seed_database(db)
    finally:
        db.close()
