import os
from pathlib import Path

from fastapi.testclient import TestClient

test_db_path = Path(__file__).resolve().parent / "test_worklink.duckdb"
if test_db_path.exists():
    test_db_path.unlink()

os.environ["APP_ENV"] = "test"
os.environ["DATABASE_URL"] = f"duckdb:///{test_db_path}"

from app.main import app
from app.services.database_setup import initialize_database

initialize_database(seed=True)
client = TestClient(app)


def _login() -> dict:
    response = client.post(
        "/api/v1/auth/login",
        json={
            "loginId": "zhangsan",
            "password": "123456",
            "deviceName": "Pytest",
            "platform": "windows",
        },
    )
    assert response.status_code == 200
    return response.json()["data"]


def test_health() -> None:
    response = client.get("/api/v1/health")
    assert response.status_code == 200
    assert response.json()["data"]["status"] == "ok"


def test_login_and_me() -> None:
    data = _login()
    token = data["accessToken"]
    response = client.get("/api/v1/auth/me", headers={"Authorization": f"Bearer {token}"})
    assert response.status_code == 200
    assert response.json()["data"]["name"] == "张三"


def test_contacts_and_dashboard() -> None:
    data = _login()
    token = data["accessToken"]
    contacts = client.get("/api/v1/org/contacts", headers={"Authorization": f"Bearer {token}"})
    dashboard = client.get("/api/v1/workplace/dashboard", headers={"Authorization": f"Bearer {token}"})
    profile = client.get("/api/v1/profile/overview", headers={"Authorization": f"Bearer {token}"})
    assert contacts.status_code == 200
    assert dashboard.status_code == 200
    assert profile.status_code == 200
    assert contacts.json()["data"]["total"] >= 1
    assert "attendanceCard" in dashboard.json()["data"]
    assert "chat" in profile.json()["data"]


def test_chat_send_message() -> None:
    data = _login()
    token = data["accessToken"]
    response = client.post(
        "/api/v1/chat/conversations/c_1/messages",
        headers={"Authorization": f"Bearer {token}"},
        json={"messageType": "TEXT", "content": "pytest message"},
    )
    assert response.status_code == 200
    assert response.json()["data"]["status"] == "SENT"


def test_invalid_login_returns_unified_error() -> None:
    response = client.post(
        "/api/v1/auth/login",
        json={
            "loginId": "zhangsan",
            "password": "wrong-password",
            "deviceName": "Pytest",
            "platform": "windows",
        },
    )
    assert response.status_code == 401
    body = response.json()
    assert body["code"] == "AUTH_401"
    assert body["message"] == "Invalid credentials"
    assert body["data"] is None
    assert body["traceId"] is not None


def test_missing_bearer_returns_unified_error() -> None:
    response = client.get("/api/v1/auth/me")
    assert response.status_code == 401
    body = response.json()
    assert body["code"] == "AUTH_401"
    assert body["message"] == "Missing bearer token"
    assert body["data"] is None
