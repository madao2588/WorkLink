from typing import Any

from fastapi import status


class AppException(Exception):
    def __init__(
        self,
        *,
        code: str,
        message: str,
        status_code: int = status.HTTP_400_BAD_REQUEST,
        data: Any | None = None,
    ) -> None:
        super().__init__(message)
        self.code = code
        self.message = message
        self.status_code = status_code
        self.data = data


class UnauthorizedException(AppException):
    def __init__(self, message: str = "Unauthorized", code: str = "AUTH_401") -> None:
        super().__init__(code=code, message=message, status_code=status.HTTP_401_UNAUTHORIZED)


class ForbiddenException(AppException):
    def __init__(self, message: str = "Forbidden", code: str = "AUTH_403") -> None:
        super().__init__(code=code, message=message, status_code=status.HTTP_403_FORBIDDEN)


class NotFoundException(AppException):
    def __init__(self, message: str = "Resource not found", code: str = "RES_404") -> None:
        super().__init__(code=code, message=message, status_code=status.HTTP_404_NOT_FOUND)


class ValidationException(AppException):
    def __init__(self, message: str = "Invalid request", data: Any | None = None) -> None:
        super().__init__(
            code="REQ_422",
            message=message,
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            data=data,
        )
