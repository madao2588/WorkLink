# WorkLink 接口设计说明

## 1. 接口规范

### 1.1 基础路径

- Base URL：`/api/v1`

### 1.2 统一响应结构

成功响应：

```json
{
  "code": "OK",
  "message": "success",
  "data": {},
  "traceId": "b8b57e2b9a0e4c5b"
}
```

失败响应：

```json
{
  "code": "AUTH_401",
  "message": "token expired",
  "data": null,
  "traceId": "b8b57e2b9a0e4c5b"
}
```

### 1.3 分页结构

```json
{
  "page": 1,
  "pageSize": 20,
  "total": 158,
  "items": []
}
```

### 1.4 通用请求头

- `Authorization: Bearer <access_token>`
- `X-Trace-Id`
- `X-Client-Platform`
- `X-Client-Version`

## 2. 认证模块

### 2.1 登录

- Method：`POST`
- Path：`/auth/login`

请求字段：

- `loginId`
- `password`
- `deviceName`
- `platform`

响应字段：

- `accessToken`
- `refreshToken`
- `expiresIn`
- `user`

### 2.2 刷新 token

- Method：`POST`
- Path：`/auth/refresh-token`

请求字段：

- `refreshToken`

响应字段：

- `accessToken`
- `refreshToken`
- `expiresIn`

### 2.3 登出

- Method：`POST`
- Path：`/auth/logout`

请求字段：

- `refreshToken`

### 2.4 获取当前用户

- Method：`GET`
- Path：`/auth/me`

响应字段：

- `id`
- `name`
- `avatar`
- `department`
- `position`
- `isOnline`
- `employeeNo`

### 2.5 设备列表

- Method：`GET`
- Path：`/auth/devices`

响应字段：

- `deviceId`
- `deviceName`
- `platform`
- `ip`
- `lastLoginAt`
- `current`

## 3. 用户与组织模块

### 3.1 获取通讯录列表

- Method：`GET`
- Path：`/org/contacts`

查询参数：

- `keyword`
- `departmentId`
- `onlineOnly`
- `page`
- `pageSize`

列表项字段：

- `id`
- `name`
- `avatar`
- `department`
- `departmentId`
- `position`
- `isOnline`
- `mobileMasked`

### 3.2 获取部门树

- Method：`GET`
- Path：`/org/departments/tree`

节点字段：

- `id`
- `name`
- `parentId`
- `children`
- `memberCount`

### 3.3 获取用户详情

- Method：`GET`
- Path：`/org/users/{userId}`

响应字段：

- `id`
- `name`
- `avatar`
- `department`
- `departmentId`
- `position`
- `email`
- `mobileMasked`
- `employeeNo`
- `joinDate`
- `isOnline`

## 4. 消息模块

### 4.1 获取会话摘要列表

- Method：`GET`
- Path：`/chat/conversations`

查询参数：

- `keyword`
- `onlyUnread`
- `page`
- `pageSize`

列表项字段：

- `conversationId`
- `conversationType`
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

说明：

- 这组字段可以直接映射你当前前端的 `ConversationSummary`

### 4.2 获取聊天详情头部信息

- Method：`GET`
- Path：`/chat/conversations/{conversationId}`

响应字段：

- `conversationId`
- `conversationType`
- `name`
- `avatar`
- `department`
- `isOnline`
- `memberCount`

### 4.3 获取消息历史

- Method：`GET`
- Path：`/chat/conversations/{conversationId}/messages`

查询参数：

- `cursor`
- `pageSize`

列表项字段：

- `messageId`
- `senderId`
- `senderName`
- `content`
- `messageType`
- `sentAt`
- `isMe`
- `isRead`
- `attachments`

### 4.4 发送消息

- Method：`POST`
- Path：`/chat/conversations/{conversationId}/messages`

请求字段：

- `messageType`
- `content`
- `clientMessageId`
- `attachments`

响应字段：

- `messageId`
- `clientMessageId`
- `sentAt`
- `status`

### 4.5 标记会话已读

- Method：`POST`
- Path：`/chat/conversations/{conversationId}/read`

请求字段：

- `lastReadMessageId`

### 4.6 更新会话偏好

- Method：`PATCH`
- Path：`/chat/conversations/{conversationId}/preferences`

请求字段：

- `isPinned`
- `isMuted`

## 5. 审批模块

### 5.1 获取审批列表

- Method：`GET`
- Path：`/approval/instances`

查询参数：

- `status`
- `scope`
- `page`
- `pageSize`

列表项字段：

- `id`
- `title`
- `applicant`
- `applicantId`
- `startTime`
- `reason`
- `status`
- `currentNodeName`

说明：

- 这组字段可以直接映射你当前前端的 `ApprovalModel`

### 5.2 获取审批详情

- Method：`GET`
- Path：`/approval/instances/{approvalId}`

响应字段：

- `id`
- `title`
- `templateCode`
- `applicant`
- `applicantId`
- `department`
- `status`
- `startTime`
- `reason`
- `formData`
- `nodes`
- `logs`
- `attachments`
- `canApprove`
- `canReject`
- `canRevoke`

### 5.3 发起审批

- Method：`POST`
- Path：`/approval/instances`

请求字段：

- `templateCode`
- `title`
- `reason`
- `formData`
- `attachments`

### 5.4 审批通过

- Method：`POST`
- Path：`/approval/instances/{approvalId}/approve`

请求字段：

- `comment`

### 5.5 审批拒绝

- Method：`POST`
- Path：`/approval/instances/{approvalId}/reject`

请求字段：

- `comment`

### 5.6 撤回审批

- Method：`POST`
- Path：`/approval/instances/{approvalId}/revoke`

请求字段：

- `reason`

### 5.7 工作台审批汇总

- Method：`GET`
- Path：`/approval/summary`

响应字段：

- `pendingCount`
- `approvedCount`
- `rejectedCount`
- `todoCount`

## 6. 考勤模块

### 6.1 获取今日考勤状态

- Method：`GET`
- Path：`/attendance/today`

响应字段：

- `date`
- `status`
- `hasCheckedIn`
- `checkInTime`
- `checkOutTime`
- `ruleName`
- `isLate`

说明：

- 这组字段可直接支撑你当前前端里的 `status / hasCheckedIn / time`

### 6.2 打卡

- Method：`POST`
- Path：`/attendance/check-in`

请求字段：

- `deviceId`
- `latitude`
- `longitude`
- `address`

响应字段：

- `status`
- `checkInTime`
- `hasCheckedIn`

### 6.3 考勤历史

- Method：`GET`
- Path：`/attendance/records`

查询参数：

- `month`
- `page`
- `pageSize`

列表项字段：

- `date`
- `checkInTime`
- `checkOutTime`
- `status`
- `isLate`
- `isAbsent`

## 7. 个人中心模块

### 7.1 获取个人主页概览

- Method：`GET`
- Path：`/profile/overview`

响应字段：

- `user`
- `attendance`
- `approval`
- `chat`

说明：

- 这个接口可以直接服务“我的”页顶部指标区

### 7.2 获取工资条列表

- Method：`GET`
- Path：`/profile/salary-slips`

查询参数：

- `year`
- `page`
- `pageSize`

列表项字段：

- `salarySlipId`
- `month`
- `netAmount`
- `grossAmount`
- `status`
- `issuedAt`

### 7.3 获取工资条详情

- Method：`GET`
- Path：`/profile/salary-slips/{salarySlipId}`

响应字段：

- `salarySlipId`
- `month`
- `grossAmount`
- `netAmount`
- `items`
- `issuedAt`

### 7.4 获取勋章列表

- Method：`GET`
- Path：`/profile/badges`

列表项字段：

- `badgeId`
- `name`
- `description`
- `icon`
- `earnedAt`

### 7.5 获取账号安全信息

- Method：`GET`
- Path：`/profile/account-security`

响应字段：

- `mobileMasked`
- `emailMasked`
- `passwordUpdatedAt`
- `devices`
- `mfaEnabled`

### 7.6 获取通用设置

- Method：`GET`
- Path：`/profile/settings`

响应字段：

- `notificationsEnabled`
- `soundEnabled`
- `language`
- `themeMode`
- `cacheSize`

### 7.7 更新通用设置

- Method：`PUT`
- Path：`/profile/settings`

请求字段：

- `notificationsEnabled`
- `soundEnabled`
- `language`
- `themeMode`

### 7.8 提交帮助反馈

- Method：`POST`
- Path：`/profile/feedback`

请求字段：

- `category`
- `content`
- `contact`
- `attachments`

## 8. 工作台模块

### 8.1 获取工作台首页数据

- Method：`GET`
- Path：`/workplace/dashboard`

响应字段：

- `greeting`
- `dateLabel`
- `attendanceCard`
- `approvalCard`
- `messageCard`
- `noticeCards`
- `shortcutCards`

说明：

- 工作台不建议完全靠前端自己聚合，建议后端输出一份已经整理好的 dashboard DTO

## 9. 通知模块

### 9.1 获取通知列表

- Method：`GET`
- Path：`/notifications`

查询参数：

- `type`
- `isRead`
- `page`
- `pageSize`

### 9.2 标记通知已读

- Method：`POST`
- Path：`/notifications/{notificationId}/read`

## 10. WebSocket 设计

### 10.1 连接地址

- `/ws`

### 10.2 鉴权方式

- 建连时携带 access token

### 10.3 客户端订阅事件

- `message.new`
- `message.read`
- `conversation.updated`
- `notification.new`
- `user.presence.changed`

### 10.4 新消息事件结构

- `event`
- `conversationId`
- `message`

### 10.5 会话更新事件结构

- `event`
- `conversationId`
- `latestPreview`
- `latestMessageTime`
- `unreadCount`

## 11. 错误码建议

建议统一错误码分层：

- `AUTH_401` 未登录或 token 无效
- `AUTH_403` 无权限
- `VALIDATION_400` 参数错误
- `BIZ_404` 业务对象不存在
- `BIZ_409` 状态冲突
- `SYS_500` 系统异常

## 12. API 设计原则

- 列表页优先返回摘要对象，不把 UI 拼装压力甩给前端
- 所有时间字段统一返回 ISO 8601
- 所有状态字段统一用可枚举值，不返回展示文案
- 所有敏感接口都必须走鉴权和数据权限检查
- 所有更新类接口都建议写审计日志
