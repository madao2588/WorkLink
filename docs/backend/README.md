# WorkLink 后端设计文档

这组文档用于把当前 Flutter 前端从本地 mock 方案推进到可联调的真实后端方案。

文档分为 4 部分：

1. [backend_architecture.md](d:/FlutterProjects/my_first_app/docs/backend/backend_architecture.md)
   说明整体后端架构、模块边界、部署方案、缓存与安全设计。
2. [api_spec.md](d:/FlutterProjects/my_first_app/docs/backend/api_spec.md)
   说明接口分组、请求响应规范、主要接口清单、WebSocket 事件设计。
3. [database_design.md](d:/FlutterProjects/my_first_app/docs/backend/database_design.md)
   说明数据库分层、核心表设计、字段建议、索引和关系设计。
4. [frontend_backend_mapping.md](d:/FlutterProjects/my_first_app/docs/backend/frontend_backend_mapping.md)
   说明当前前端模型与后端接口字段如何一一映射，便于联调。

建议阅读顺序：

1. 先看整体架构
2. 再看数据库设计
3. 再看接口规范
4. 最后按前后端映射开始联调

当前设计目标：

- 支持你现有的消息、通讯录、工作台、我的四大模块
- 第一阶段采用模块化单体，便于快速开发
- 第二阶段可平滑拆分为聊天、通知、文件等独立服务
- 所有接口都预留真实联调所需的鉴权、分页、错误码和状态字段
