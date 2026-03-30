import argparse

from app.core.config import get_settings
from app.core.logging import configure_logging
from app.services.database_setup import initialize_database


def main() -> None:
    parser = argparse.ArgumentParser(description="Initialize the WorkLink database")
    parser.add_argument("--seed", action="store_true", help="Insert demo seed data after schema setup")
    parser.add_argument(
        "--skip-migrations",
        action="store_true",
        help="Create tables without running migration steps",
    )
    args = parser.parse_args()

    settings = get_settings()
    configure_logging(settings.log_level)
    initialize_database(run_migrations=not args.skip_migrations, seed=args.seed)
    print(
        "Database initialized successfully "
        f"(environment={settings.environment}, seed={args.seed}, migrations={not args.skip_migrations})"
    )


if __name__ == "__main__":
    main()
