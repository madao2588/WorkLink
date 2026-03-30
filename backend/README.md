# WorkLink Backend

这是给当前 Flutter 项目配套的一套后端服务，目标是直接替换前端现有的 mock 数据，进入真实接口联调阶段。

## 技术栈

- FastAPI
- SQLAlchemy
- DuckDB 开发数据库
- PostgreSQL 正式数据库
- JWT Access Token
- Refresh Token
- WebSocket

## 已实现模块

- Auth：登录、刷新令牌、登出、当前用户、设备记录
- Org：通讯录、部门树、用户详情
- Chat：会话列表、消息历史、发送消息、已读、会话偏好、WebSocket
- Approval：审批列表、详情、发起、通过、拒绝、撤回、汇总
- Attendance：今日考勤、打卡、历史
- Profile：个人概览、工资条、勋章、账号安全、设置、反馈
- Workplace：工作台聚合数据
- Notifications：通知列表与已读

## 本地开发

1. 创建并激活虚拟环境

```powershell
cd backend
python -m venv .venv
.\.venv\Scripts\activate
pip install -r requirements.txt
```

2. 使用默认开发库启动

```powershell
Copy-Item .env.example .env
uvicorn app.main:app --reload
```

默认开发数据库是 `backend/worklink.duckdb`，启动时会自动建表并注入种子数据。

## 配置 PostgreSQL

### 一键启动数据库

```powershell
cd backend
docker compose up -d
```

### 切换后端到 PostgreSQL

```powershell
Copy-Item .env.postgres.example .env
.\.venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

默认 PostgreSQL 配置如下：

- Host：`127.0.0.1`
- Port：`5432`
- Database：`worklink`
- Username：`worklink`
- Password：`worklink123`

应用启动时会自动建表并注入种子数据，所以不需要额外执行迁移脚本。

## 默认测试账号

- 登录名：`zhangsan`
- 密码：`123456`

## 接口文档

- Swagger UI：`http://127.0.0.1:8000/docs`
- OpenAPI：`http://127.0.0.1:8000/openapi.json`

## 关键环境变量

- `APP_NAME`
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

## 联调建议顺序

1. `/api/v1/auth/login`
2. `/api/v1/auth/me`
3. `/api/v1/chat/conversations`
4. `/api/v1/chat/conversations/{id}/messages`
5. `/api/v1/approval/instances`
6. `/api/v1/attendance/today`
7. `/api/v1/profile/overview`
8. `/api/v1/workplace/dashboard`
