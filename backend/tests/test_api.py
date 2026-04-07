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
    assert data["user"]["role"] == "departmentManager"
    assert "manageEmployees" in data["user"]["permissions"]
    token = data["accessToken"]
    response = client.get("/api/v1/auth/me", headers={"Authorization": f"Bearer {token}"})
    assert response.status_code == 200
    assert response.json()["data"]["loginId"] == "zhangsan"
    assert response.json()["data"]["role"] == "departmentManager"
    assert "manageEmployees" in response.json()["data"]["permissions"]


def test_madao_has_super_admin_permissions() -> None:
    response = client.post(
        "/api/v1/auth/login",
        json={
            "loginId": "madao",
            "password": "123456",
            "deviceName": "Pytest",
            "platform": "windows",
        },
    )
    assert response.status_code == 200
    user = response.json()["data"]["user"]
    assert user["loginId"] == "madao"
    assert user["role"] == "superAdmin"
    assert "manageAccounts" in user["permissions"]
    assert "exportData" in user["permissions"]


def test_viewer_cannot_open_enterprise_admin_overview() -> None:
    response = client.post(
        "/api/v1/auth/login",
        json={
            "loginId": "lisi",
            "password": "123456",
            "deviceName": "Pytest",
            "platform": "windows",
        },
    )
    assert response.status_code == 200
    token = response.json()["data"]["accessToken"]
    overview = client.get(
        "/api/v1/org/admin/overview",
        headers={"Authorization": f"Bearer {token}"},
    )
    assert overview.status_code == 403
    assert overview.json()["message"] == "Insufficient permissions"


def test_contacts_and_dashboard() -> None:
    data = _login()
    token = data["accessToken"]
    contacts = client.get("/api/v1/org/contacts", headers={"Authorization": f"Bearer {token}"})
    admin_overview = client.get("/api/v1/org/admin/overview", headers={"Authorization": f"Bearer {token}"})
    dashboard = client.get("/api/v1/workplace/dashboard", headers={"Authorization": f"Bearer {token}"})
    profile = client.get("/api/v1/profile/overview", headers={"Authorization": f"Bearer {token}"})
    assert contacts.status_code == 200
    assert admin_overview.status_code == 200
    assert dashboard.status_code == 200
    assert profile.status_code == 200
    assert contacts.json()["data"]["total"] >= 1
    assert admin_overview.json()["data"]["employees"]
    assert admin_overview.json()["data"]["departments"]
    assert admin_overview.json()["data"]["positions"]
    assert admin_overview.json()["data"]["accounts"]
    assert "attendanceCard" in dashboard.json()["data"]
    assert "chat" in profile.json()["data"]


def test_create_change_request() -> None:
    data = _login()
    token = data["accessToken"]
    response = client.post(
        "/api/v1/org/change-requests",
        headers={"Authorization": f"Bearer {token}"},
        json={
            "entityType": "employee",
            "entityId": "u_me",
            "entityName": "zhangsan",
            "changeType": "profile_fix",
            "note": "Update profile note from pytest",
            "snapshot": {
                "employeeNo": "WK1001",
                "department": "RD",
            },
        },
    )
    assert response.status_code == 200
    body = response.json()["data"]
    assert body["entityType"] == "employee"
    assert body["entityId"] == "u_me"
    assert body["changeType"] == "profile_fix"
    assert body["status"] == "DRAFTED"
    assert body["requestNo"].startswith("CR-")


def test_list_change_requests() -> None:
    data = _login()
    token = data["accessToken"]
    create = client.post(
        "/api/v1/org/change-requests",
        headers={"Authorization": f"Bearer {token}"},
        json={
            "entityType": "employee",
            "entityId": "u_me",
            "entityName": "zhangsan",
            "changeType": "profile_fix",
            "note": "List view smoke test",
            "snapshot": {
                "employeeNo": "WK1001",
            },
        },
    )
    assert create.status_code == 200
    response = client.get(
        "/api/v1/org/change-requests",
        headers={"Authorization": f"Bearer {token}"},
    )
    assert response.status_code == 200
    body = response.json()["data"]
    assert body["total"] >= 1
    assert body["items"][0]["requestNo"].startswith("CR-")
    assert body["items"][0]["requesterName"]


def test_change_request_detail() -> None:
    response = client.post(
        "/api/v1/auth/login",
        json={
            "loginId": "madao",
            "password": "123456",
            "deviceName": "Pytest",
            "platform": "windows",
        },
    )
    assert response.status_code == 200
    token = response.json()["data"]["accessToken"]
    create = client.post(
        "/api/v1/org/change-requests",
        headers={"Authorization": f"Bearer {token}"},
        json={
            "entityType": "position",
            "entityId": "position-dept-rd-mobile-engineer",
            "entityName": "移动端工程师",
            "changeType": "org_adjustment",
            "note": "Update quota and title",
            "snapshot": {
                "title": "移动端平台主管",
                "openQuota": "1",
            },
        },
    )
    assert create.status_code == 200
    request_id = create.json()["data"]["id"]

    response = client.get(
        f"/api/v1/org/change-requests/{request_id}",
        headers={"Authorization": f"Bearer {token}"},
    )
    assert response.status_code == 200
    body = response.json()["data"]
    assert body["id"] == request_id
    assert body["entityType"] == "position"
    assert body["snapshot"]["title"] == "移动端平台主管"
    assert body["snapshot"]["openQuota"] == "1"


def test_approve_change_request_applies_overview() -> None:
    response = client.post(
        "/api/v1/auth/login",
        json={
            "loginId": "madao",
            "password": "123456",
            "deviceName": "Pytest",
            "platform": "windows",
        },
    )
    assert response.status_code == 200
    token = response.json()["data"]["accessToken"]

    overview_before = client.get(
        "/api/v1/org/admin/overview",
        headers={"Authorization": f"Bearer {token}"},
    )
    assert overview_before.status_code == 200
    employee = next(
        item for item in overview_before.json()["data"]["employees"] if item["id"] == "u_me"
    )

    draft = client.post(
        "/api/v1/org/change-requests",
        headers={"Authorization": f"Bearer {token}"},
        json={
            "entityType": "position",
            "entityId": employee["positionId"],
            "entityName": employee["position"],
            "changeType": "org_adjustment",
            "note": "Approve and apply new staffing plan",
            "snapshot": {
                "title": "移动端平台主管",
                "level": "P6",
                "openQuota": "3",
            },
        },
    )
    assert draft.status_code == 200
    request_id = draft.json()["data"]["id"]

    approve = client.patch(
        f"/api/v1/org/change-requests/{request_id}/approve",
        headers={"Authorization": f"Bearer {token}"},
        json={},
    )
    assert approve.status_code == 200
    assert approve.json()["data"]["status"] == "APPLIED"

    overview_after = client.get(
        "/api/v1/org/admin/overview",
        headers={"Authorization": f"Bearer {token}"},
    )
    assert overview_after.status_code == 200
    data = overview_after.json()["data"]
    assert any(
        item["id"] == employee["positionId"]
        and item["title"] == "移动端平台主管"
        and item["level"] == "P6"
        and item["openQuota"] == 3
        for item in data["positions"]
    )
    assert any(
        item["id"] == "u_me" and item["position"] == "移动端平台主管"
        for item in data["employees"]
    )


def test_reject_change_request_marks_rejected() -> None:
    response = client.post(
        "/api/v1/auth/login",
        json={
            "loginId": "madao",
            "password": "123456",
            "deviceName": "Pytest",
            "platform": "windows",
        },
    )
    assert response.status_code == 200
    token = response.json()["data"]["accessToken"]
    draft = client.post(
        "/api/v1/org/change-requests",
        headers={"Authorization": f"Bearer {token}"},
        json={
            "entityType": "department",
            "entityId": "dept-rd",
            "entityName": "研发部",
            "changeType": "org_adjustment",
            "note": "Reject this department draft",
            "snapshot": {
                "name": "平台研发中心",
            },
        },
    )
    assert draft.status_code == 200
    request_id = draft.json()["data"]["id"]

    reject = client.patch(
        f"/api/v1/org/change-requests/{request_id}/reject",
        headers={"Authorization": f"Bearer {token}"},
        json={},
    )
    assert reject.status_code == 200
    assert reject.json()["data"]["status"] == "REJECTED"

    detail = client.get(
        f"/api/v1/org/change-requests/{request_id}",
        headers={"Authorization": f"Bearer {token}"},
    )
    assert detail.status_code == 200
    assert detail.json()["data"]["status"] == "REJECTED"


def test_update_employee() -> None:
    response = client.post(
        "/api/v1/auth/login",
        json={
            "loginId": "madao",
            "password": "123456",
            "deviceName": "Pytest",
            "platform": "windows",
        },
    )
    assert response.status_code == 200
    token = response.json()["data"]["accessToken"]

    update = client.patch(
        "/api/v1/org/admin/employees/u_me",
        headers={"Authorization": f"Bearer {token}"},
        json={
            "departmentId": "dept-hr",
            "position": "HRBP",
            "email": "zhangsan.updated@worklink.local",
            "mobile": "13912345678",
        },
    )
    assert update.status_code == 200
    body = update.json()["data"]
    assert body["id"] == "u_me"
    assert body["departmentId"] == "dept-hr"
    assert body["department"] == "人事部"
    assert body["position"] == "HRBP"
    assert body["email"] == "zhangsan.updated@worklink.local"
    assert body["mobile"] == "13912345678"


def test_update_department() -> None:
    response = client.post(
        "/api/v1/auth/login",
        json={
            "loginId": "madao",
            "password": "123456",
            "deviceName": "Pytest",
            "platform": "windows",
        },
    )
    assert response.status_code == 200
    token = response.json()["data"]["accessToken"]

    update = client.patch(
        "/api/v1/org/admin/departments/dept-rd",
        headers={"Authorization": f"Bearer {token}"},
        json={
            "name": "平台研发中心",
            "leader": "王五",
            "description": "负责平台与业务研发",
        },
    )
    assert update.status_code == 200
    body = update.json()["data"]
    assert body["id"] == "dept-rd"
    assert body["name"] == "平台研发中心"
    assert body["leader"] == "王五"
    assert body["description"] == "负责平台与业务研发"

    overview = client.get(
        "/api/v1/org/admin/overview",
        headers={"Authorization": f"Bearer {token}"},
    )
    assert overview.status_code == 200
    departments = overview.json()["data"]["departments"]
    assert any(
        item["id"] == "dept-rd" and item["name"] == "平台研发中心"
        for item in departments
    )

def test_update_position() -> None:
    response = client.post(
        "/api/v1/auth/login",
        json={
            "loginId": "madao",
            "password": "123456",
            "deviceName": "Pytest",
            "platform": "windows",
        },
    )
    assert response.status_code == 200
    token = response.json()["data"]["accessToken"]

    overview_before = client.get(
        "/api/v1/org/admin/overview",
        headers={"Authorization": f"Bearer {token}"},
    )
    assert overview_before.status_code == 200
    overview_data = overview_before.json()["data"]
    employee = next(
        item for item in overview_data["employees"] if item["id"] == "u_me"
    )
    position = next(
        item
        for item in overview_data["positions"]
        if item["id"] == employee["positionId"]
    )

    update = client.patch(
        f"/api/v1/org/admin/positions/{position['id']}",
        headers={"Authorization": f"Bearer {token}"},
        json={
            "title": "Flutter Platform Engineer",
            "level": "P6",
            "openQuota": 2,
        },
    )
    assert update.status_code == 200
    body = update.json()["data"]
    assert body["id"] == position["id"]
    assert body["title"] == "Flutter Platform Engineer"
    assert body["level"] == "P6"
    assert body["openQuota"] == 2

    overview_after = client.get(
        "/api/v1/org/admin/overview",
        headers={"Authorization": f"Bearer {token}"},
    )
    assert overview_after.status_code == 200
    data = overview_after.json()["data"]
    assert any(
        item["id"] == position["id"]
        and item["title"] == "Flutter Platform Engineer"
        and item["level"] == "P6"
        and item["openQuota"] == 2
        for item in data["positions"]
    )
    assert any(
        item["id"] == "u_me" and item["position"] == "Flutter Platform Engineer"
        for item in data["employees"]
    )


def test_update_account_changes_role_and_blocks_disabled_login() -> None:
    response = client.post(
        "/api/v1/auth/login",
        json={
            "loginId": "madao",
            "password": "123456",
            "deviceName": "Pytest",
            "platform": "windows",
        },
    )
    assert response.status_code == 200
    token = response.json()["data"]["accessToken"]

    update_role = client.patch(
        "/api/v1/org/admin/accounts/u_me",
        headers={"Authorization": f"Bearer {token}"},
        json={
            "role": "viewer",
            "enabled": True,
        },
    )
    assert update_role.status_code == 200
    account_body = update_role.json()["data"]
    assert account_body["role"] == "viewer"
    assert account_body["enabled"] is True

    relogin = client.post(
        "/api/v1/auth/login",
        json={
            "loginId": "zhangsan",
            "password": "123456",
            "deviceName": "Pytest",
            "platform": "windows",
        },
    )
    assert relogin.status_code == 200
    assert relogin.json()["data"]["user"]["role"] == "viewer"
    assert relogin.json()["data"]["user"]["permissions"] == ["viewDashboard"]

    disabled = client.patch(
        "/api/v1/org/admin/accounts/u_2",
        headers={"Authorization": f"Bearer {token}"},
        json={
            "role": "hrManager",
            "enabled": False,
        },
    )
    assert disabled.status_code == 200
    assert disabled.json()["data"]["enabled"] is False

    disabled_login = client.post(
        "/api/v1/auth/login",
        json={
            "loginId": "wangwu",
            "password": "123456",
            "deviceName": "Pytest",
            "platform": "windows",
        },
    )
    assert disabled_login.status_code == 401
    assert disabled_login.json()["message"] == "Account disabled"


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
