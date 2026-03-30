import logging


def configure_logging(level: str) -> None:
    resolved_level = getattr(logging, level.upper(), logging.INFO)
    root_logger = logging.getLogger()

    if root_logger.handlers:
        root_logger.setLevel(resolved_level)
        return

    logging.basicConfig(
        level=resolved_level,
        format="%(asctime)s | %(levelname)s | %(name)s | %(message)s",
    )
