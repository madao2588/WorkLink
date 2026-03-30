# WorkLink 前后端字段映射说明

这份文档用于把当前 Flutter 前端模型和未来后端 DTO 对齐，减少联调时字段来回改名。

## 1. 用户模型映射

当前前端模型：

- 文件：[user_model.dart](d:/FlutterProjects/my_first_app/lib/app/shared/models/user_model.dart)

前端字段：

- `id`
- `name`
- `avatar`
- `department`
- `isOnline`

建议后端 DTO：

- `id`
- `name`
- `avatar`
- `department`
- `departmentId`
- `position`
- `isOnline`

映射规则：

- 前端 `avatar` 目前是字母头像，可先直接返回展示文本
- 后续如果接入真实头像，可保持字段名 `avatar`，值改为头像 URL
- `department` 建议继续保留，方便列表直接展示

## 2. 消息会话摘要映射

当前前端模型：

- 文件：[conversation_summary.dart](d:/FlutterProjects/my_first_app/lib/features/chat/domain/models/conversation_summary.dart)

前端字段：

- `user`
- `latestPreview`
- `latestMessageTime`
- `unreadCount`

当前前端派生字段：

- `userId`
- `name`
- `avatar`
- `department`
- `isOnline`
- `hasUnread`

建议后端列表项 DTO：

- `conversationId`
- `userId`
- `name`
- `avatar`
- `department`
- `isOnline`
- `latestPreview`
- `latestMessageTime`
- `unreadCount`
- `isPinned`
- `isMuted`

对接建议：

- 后端直接返回会话摘要，不让前端再自行聚合消息
- 前端 `ConversationSummary` 可在 repository 层把上述 DTO 转成当前模型
- `latestMessageTime` 统一返回 ISO 8601 字符串

## 3. 聊天消息映射

当前前端模型：

- 文件：[chat_message_model.dart](d:/FlutterProjects/my_first_app/lib/features/chat/domain/models/chat_message_model.dart)

建议后端消息 DTO：

- `messageId`
- `conversationId`
- `senderId`
- `senderName`
- `content`
- `messageType`
- `sentAt`
- `isRead`
- `attachments`

映射建议：

- 前端 `isMe` 不建议后端直接存储，可由 `senderId == currentUser.id` 推导
- 客户端发送消息时带 `clientMessageId`，便于回执对齐

## 4. 审批模型映射

当前前端模型：

- 文件：[approval_model.dart](d:/FlutterProjects/my_first_app/lib/features/approval/domain/models/approval_model.dart)

前端字段：

- `id`
- `title`
- `applicant`
- `startTime`
- `reason`
- `status`

建议后端列表项 DTO：

- `id`
- `title`
- `applicant`
- `applicantId`
- `startTime`
- `reason`
- `status`
- `currentNodeName`

映射建议：

- 前端枚举 `pending / approved / rejected` 与后端建议状态码一一映射
- 若后端使用大写枚举，则 repository 层完成转换

## 5. 考勤状态映射

当前前端来源：

- 文件：[attendance_provider.dart](d:/FlutterProjects/my_first_app/lib/features/attendance/presentation/providers/attendance_provider.dart)

当前前端关注字段：

- `hasCheckedIn`
- `status`
- `time`

建议后端 DTO：

- `date`
- `hasCheckedIn`
- `status`
- `checkInTime`
- `checkOutTime`
- `isLate`

映射规则：

- 前端 `time` 对应后端 `checkInTime`
- 前端 `status` 不建议后端返回中文文案，建议返回状态码，由前端做本地文案映射

## 6. 我的页概览映射

当前前端页面：

- 文件：[profile_screen.dart](d:/FlutterProjects/my_first_app/lib/features/profile/presentation/screens/profile_screen.dart)

当前前端指标依赖：

- 考勤状态
- 待审批数量
- 消息记录数量

建议后端 DTO：

```json
{
  "user": {
    "id": "u_001",
    "name": "张三",
    "avatar": "ZS",
    "department": "研发部",
    "isOnline": true
  },
  "attendance": {
    "status": "CHECKED_IN",
    "hasCheckedIn": true,
    "checkInTime": "2026-03-29T08:55:00Z"
  },
  "approval": {
    "pendingCount": 3
  },
  "chat": {
    "totalMessageCount": 28,
    "unreadCount": 2
  }
}
```

说明：

- 这个 DTO 可以直接支撑“我的”页顶部和指标区
- 后续还可以补本月出勤、已完成审批数等更多统计

## 7. 通讯录映射

当前通讯录卡片关注字段：

- `id`
- `name`
- `avatar`
- `department`
- `isOnline`

建议后端 DTO：

- `id`
- `name`
- `avatar`
- `department`
- `departmentId`
- `position`
- `isOnline`
- `mobileMasked`

## 8. 工作台映射

当前工作台需要的不是单一实体，而是一组聚合摘要。

建议后端直接返回 dashboard DTO：

- `greeting`
- `dateLabel`
- `attendanceCard`
- `approvalCard`
- `messageCard`
- `shortcutCards`

这样前端不必同时调用多个接口再自己拼装首页。

## 9. 推荐命名规范

为了减少联调摩擦，建议统一以下规则：

- ID 字段统一为 `id` 或 `{entity}Id`
- 时间字段统一 `xxxAt`
- 布尔字段统一 `isXxx` / `hasXxx`
- 状态字段统一返回英文枚举码
- 金额字段统一 `amount`

## 10. 联调建议

推荐分 3 步联调：

1. 先对齐登录、当前用户、通讯录、消息会话摘要
2. 再对齐聊天详情、审批列表、今日考勤
3. 最后对齐工资条、设置、反馈、通知

## 11. 一句话结论

这套字段映射的核心原则是：后端返回稳定的业务字段，前端 repository 做少量适配，Screen 和 Provider 不直接承担字段拼装责任。
