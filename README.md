# WorkLink

WorkLink 是一个企业协作示例项目，前端使用 Flutter，后端使用 FastAPI，覆盖登录、消息、通讯录、工作台、审批、考勤和个人中心等常见办公场景。

## 给普通使用者

如果你只是想下载后直接运行，不需要本地安装 Flutter 或 Python。

### 下载方式

优先从 GitHub 的 `Releases` 页面下载 Windows 便携包：

- 文件名形如 `WorkLink-windows-x.y.z.zip`
- 下载后解压到任意目录

如果当前还没有正式 Release，也可以在 GitHub Actions 的 `Windows Portable Bundle` 工作流里下载构建产物。

### 运行方式

在解压后的目录中：

1. 双击 `Start WorkLink.bat`
2. 首次启动会自动拉起本地后端并打开桌面客户端
3. 关闭客户端后，如果想彻底停止本地后端，双击 `Stop WorkLink Backend.bat`

默认测试账号：

- 用户名：`zhangsan`
- 密码：`123456`

### 目录说明

Windows 便携包包含：

- `app/`：Flutter Windows 桌面客户端
- `backend/`：打包后的本地后端服务
- `logs/`：启动日志
- `Start WorkLink.bat`：一键启动
- `Stop WorkLink Backend.bat`：停止本地后端

## 给开发者

### 技术栈

- 前端：Flutter、Provider、GoRouter、HTTP
- 后端：FastAPI、SQLAlchemy、DuckDB、PostgreSQL、JWT、WebSocket

### 本地开发

先启动后端：

```powershell
cd backend
python -m venv .venv
.\.venv\Scripts\activate
pip install -r requirements.txt
Copy-Item .env.example .env
python -m app.scripts.init_db --seed
uvicorn app.main:app --reload
```

后端默认地址：

- API：`http://127.0.0.1:8000/api/v1`
- Swagger UI：`http://127.0.0.1:8000/docs`

再启动 Flutter 前端：

```powershell
flutter pub get
flutter run
```

可通过 `--dart-define` 覆盖接口地址：

```powershell
flutter run --dart-define=WORKLINK_API_BASE_URL=http://127.0.0.1:8000/api/v1
```

如果只传服务根地址，也会自动补齐 `/api/v1`：

```powershell
flutter run --dart-define=WORKLINK_API_BASE_URL=http://192.168.1.20:8000
```

默认 API 地址：

- Web、Windows、macOS、Linux、iOS 模拟器：`http://127.0.0.1:8000/api/v1`
- Android 模拟器：`http://10.0.2.2:8000/api/v1`

### 测试与检查

Flutter：

```powershell
flutter analyze
flutter test
```

Backend：

```powershell
cd backend
.\.venv\Scripts\python.exe -m pytest
```

### Windows 便携包打包

仓库内置了本地打包脚本：

```powershell
.\scripts\package_windows.ps1 -Version 1.0.0
```

它会完成这些事情：

- 构建 Flutter Windows 桌面版
- 用 PyInstaller 打包 FastAPI 后端
- 生成带演示数据的本地 DuckDB
- 组装便携目录
- 输出可直接分享的 zip 文件

默认输出位置：

- 目录：`dist/windows/WorkLink-windows-<version>/`
- 压缩包：`dist/windows/WorkLink-windows-<version>.zip`

### GitHub 自动构建

仓库包含 `Windows Portable Bundle` 工作流：

- 手动触发：生成可下载 artifact
- 推送 `v*` 标签：生成 artifact，并自动发布到 GitHub Release

建议发布流程：

```powershell
git tag v1.0.0
git push origin v1.0.0
```

## 仓库结构

```text
.
├─ lib/                  Flutter 应用源码
├─ test/                 Flutter 测试
├─ backend/              FastAPI 后端服务
├─ docs/backend/         后端设计与联调文档
├─ packaging/windows/    Windows 便携版启动脚本模板
├─ scripts/              本地打包脚本
├─ .github/workflows/    CI 与发布工作流
└─ README.md
```

## 文档索引

- [backend/README.md](backend/README.md)
- [docs/backend/README.md](docs/backend/README.md)
- [docs/backend/api_spec.md](docs/backend/api_spec.md)
- [docs/backend/database_design.md](docs/backend/database_design.md)
- [docs/backend/frontend_backend_mapping.md](docs/backend/frontend_backend_mapping.md)
