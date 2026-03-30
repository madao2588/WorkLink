# WorkLink Backend

这里是 WorkLink 的 FastAPI 后端，负责为 Flutter 前端提供真实接口，逐步替换前端内置的 mock 数据。

## 技术栈

- FastAPI
- SQLAlchemy
- DuckDB 本地开发数据库
- PostgreSQL 生产数据库
- JWT Access Token / Refresh Token
- WebSocket

## 已实现模块

- `Auth`：登录、刷新令牌、登出、当前用户、设备记录
- `Org`：通讯录、部门树、用户详情
- `Chat`：会话列表、消息历史、发送消息、已读、会话偏好、WebSocket
- `Approval`：审批列表、详情、发起、通过、拒绝、撤回、汇总
- `Attendance`：今日考勤、打卡、历史
- `Profile`：个人概览、工资条、勋章、账号安全、设置、反馈
- `Workplace`：工作台聚合数据
- `Notifications`：通知列表与已读

## 本地开发

### 1. 创建并激活虚拟环境

```powershell
cd backend
python -m venv .venv
.\.venv\Scripts\activate
pip install -r requirements.txt
```

### 2. 使用默认开发数据库启动

```powershell
Copy-Item .env.example .env
python -m app.scripts.init_db --seed
uvicorn app.main:app --reload
```

默认开发数据库是 `backend/worklink.duckdb`。数据库初始化、迁移和种子数据注入现在通过独立脚本完成，不再在应用启动时自动执行。

## PostgreSQL 模式

### 启动本地 PostgreSQL

```powershell
cd backend
docker compose up -d
```

### 切换到 PostgreSQL 配置

```powershell
Copy-Item .env.postgres.example .env
.\.venv\Scripts\activate
pip install -r requirements.txt
python -m app.scripts.init_db --seed
uvicorn app.main:app --reload
```

默认 PostgreSQL 连接信息：

- Host：`127.0.0.1`
- Port：`5432`
- Database：`worklink`
- Username：`worklink`
- Password：`worklink123`

## 与 Flutter 前端联调

后端默认地址：

- API：`http://127.0.0.1:8000/api/v1`
- Swagger UI：`http://127.0.0.1:8000/docs`
- OpenAPI：`http://127.0.0.1:8000/openapi.json`

前端现在支持通过 `WORKLINK_API_BASE_URL` 覆盖接口地址，例如：

```powershell
flutter run --dart-define=WORKLINK_API_BASE_URL=http://127.0.0.1:8000/api/v1
```

如果是 Android 模拟器，本地联调通常使用 `http://10.0.2.2:8000/api/v1`。

## 默认测试账号

- 登录名：`zhangsan`
- 密码：`123456`

## 测试

```powershell
cd backend
.\.venv\Scripts\python.exe -m pytest
```

## 关键环境变量

- `APP_NAME`
- `APP_ENV`
- `APP_DEBUG`
- `APP_LOG_LEVEL`
- `APP_EXPOSE_INTERNAL_ERRORS`
- `API_V1_PREFIX`
- `SECRET_KEY`
- `ACCESS_TOKEN_EXPIRE_MINUTES`
- `DATABASE_URL`
- `ALLOWED_ORIGIN_REGEX`
- `ALLOWED_ORIGINS`

## 目录结构

```text
backend/
  app/
    api/
    core/
    db/
    models/
    schemas/
    services/
    main.py
  tests/
  docker-compose.yml
  requirements.txt
```

## 建议联调顺序

1. `/api/v1/auth/login`
2. `/api/v1/auth/me`
3. `/api/v1/chat/conversations`
4. `/api/v1/chat/conversations/{id}/messages`
5. `/api/v1/approval/instances`
6. `/api/v1/attendance/today`
7. `/api/v1/profile/overview`
8. `/api/v1/workplace/dashboard`
