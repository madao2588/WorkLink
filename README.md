# WorkLink

WorkLink 是一个企业协作示例项目，使用 Flutter 构建多端前端，使用 FastAPI 提供后端接口，覆盖了登录、消息、通讯录、工作台、审批、考勤和个人中心等典型办公场景。

## 技术栈

- 前端：Flutter、Provider、GoRouter、HTTP
- 后端：FastAPI、SQLAlchemy、DuckDB、PostgreSQL、JWT、WebSocket
- 文档：`docs/backend/` 下提供架构、接口、数据库和前后端字段映射说明

## 目录结构

```text
.
├─ lib/                  Flutter 应用源码
├─ test/                 Flutter 测试
├─ backend/              FastAPI 后端服务
├─ docs/backend/         后端设计与联调文档
├─ android/ ios/ web/
├─ linux/ macos/ windows/ Flutter 多平台工程文件
└─ README.md
```

## 已实现能力

- 登录鉴权与本地凭证持久化
- 消息列表、聊天详情、发送消息
- 通讯录与组织信息展示
- 工作台聚合卡片
- 审批列表与状态流转
- 今日考勤信息
- 个人中心、工资条、勋章、账号安全、设置和反馈
- 后端健康检查、种子数据初始化和基础接口测试

## 快速开始

### 1. 启动后端

```powershell
cd backend
python -m venv .venv
.\.venv\Scripts\activate
pip install -r requirements.txt
Copy-Item .env.example .env
uvicorn app.main:app --reload
```

默认会启动在 `http://127.0.0.1:8000`，并自动初始化本地 DuckDB 数据库。

### 2. 启动 Flutter 前端

在仓库根目录执行：

```powershell
flutter pub get
flutter run
```

默认 API 地址：

- Web、Windows、macOS、Linux、iOS 模拟器：`http://127.0.0.1:8000/api/v1`
- Android 模拟器：`http://10.0.2.2:8000/api/v1`

### 3. 自定义前端 API 地址

现在前端支持通过 `--dart-define` 覆盖接口地址，不需要再改源码：

```powershell
flutter run --dart-define=WORKLINK_API_BASE_URL=http://127.0.0.1:8000/api/v1
```

如果只传服务根地址，也会自动补成 `/api/v1`：

```powershell
flutter run --dart-define=WORKLINK_API_BASE_URL=http://192.168.1.20:8000
```

这在真机联调、局域网调试和切换测试环境时会更方便。

## 测试与检查

### Flutter

```powershell
flutter analyze
flutter test
```

### Backend

```powershell
cd backend
.\.venv\Scripts\python.exe -m pytest
```

## 默认测试账号

- 用户名：`zhangsan`
- 密码：`123456`

## 文档索引

- 后端运行说明：[backend/README.md](backend/README.md)
- 后端文档总览：[docs/backend/README.md](docs/backend/README.md)
- 接口设计：[docs/backend/api_spec.md](docs/backend/api_spec.md)
- 数据库设计：[docs/backend/database_design.md](docs/backend/database_design.md)
- 前后端字段映射：[docs/backend/frontend_backend_mapping.md](docs/backend/frontend_backend_mapping.md)

## 开发说明

- 仓库新增了 `.editorconfig`，统一文本文件按 UTF-8 保存，减少中文文档和跨平台协作时的编码问题。
- `pubspec.lock` 当前已纳入版本控制，适合团队协作时固定依赖版本。
- 后端默认使用 DuckDB 进行本地开发，如需切换 PostgreSQL，可参考 [backend/README.md](backend/README.md)。
