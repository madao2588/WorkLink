# WorkLink 数据库设计说明

## 1. 数据库选型

推荐使用 PostgreSQL 作为主数据库。

原因：

- 强关系建模能力适合组织、审批、工资条
- 事务能力强
- 支持 JSONB，便于处理审批表单等半结构化数据
- 后续扩展全文索引和统计也更稳

## 2. 统一字段规范

所有核心业务表建议统一具备以下基础字段：

- `id`
- `tenant_id`
- `created_at`
- `updated_at`
- `created_by`
- `updated_by`
- `is_deleted`
- `version`

说明：

- `tenant_id` 即使现阶段只有单企业，也建议预留
- `version` 用于乐观锁
- `is_deleted` 用于软删除

## 3. 数据域划分

建议按业务域做逻辑分组：

- `auth_*`
- `user_*`
- `org_*`
- `chat_*`
- `approval_*`
- `attendance_*`
- `profile_*`
- `notification_*`
- `audit_*`

## 4. 核心表设计

### 4.1 认证域

#### `auth_user`

字段建议：

- `id`
- `tenant_id`
- `login_id`
- `password_hash`
- `mobile`
- `email`
- `status`
- `last_login_at`
- `password_updated_at`

约束建议：

- `login_id` 唯一
- `mobile` 唯一
- `email` 唯一

#### `auth_role`

字段建议：

- `id`
- `tenant_id`
- `role_code`
- `role_name`
- `status`

#### `auth_permission`

字段建议：

- `id`
- `permission_code`
- `permission_name`
- `module`

#### `auth_user_role`

字段建议：

- `id`
- `user_id`
- `role_id`

#### `auth_refresh_token`

字段建议：

- `id`
- `user_id`
- `device_id`
- `refresh_token_hash`
- `expired_at`
- `revoked_at`

#### `auth_login_log`

字段建议：

- `id`
- `user_id`
- `device_name`
- `platform`
- `ip`
- `login_at`
- `status`

#### `auth_device`

字段建议：

- `id`
- `user_id`
- `device_name`
- `platform`
- `last_login_at`
- `last_ip`
- `is_current`

### 4.2 用户与组织域

#### `user_profile`

字段建议：

- `id`
- `tenant_id`
- `user_id`
- `name`
- `avatar_url`
- `avatar_text`
- `gender`
- `employee_no`
- `join_date`
- `status`

#### `org_department`

字段建议：

- `id`
- `tenant_id`
- `parent_id`
- `name`
- `code`
- `manager_user_id`
- `sort_no`

说明：

- 用 `parent_id` 形成部门树

#### `org_position`

字段建议：

- `id`
- `tenant_id`
- `name`
- `code`

#### `org_user_department`

字段建议：

- `id`
- `user_id`
- `department_id`
- `is_primary`

#### `org_user_position`

字段建议：

- `id`
- `user_id`
- `position_id`

#### `org_reporting_line`

字段建议：

- `id`
- `user_id`
- `manager_user_id`

### 4.3 消息域

#### `chat_conversation`

字段建议：

- `id`
- `tenant_id`
- `conversation_type`
- `name`
- `avatar_url`
- `latest_message_id`
- `latest_message_time`
- `status`

说明：

- 单聊和群聊统一建模

#### `chat_conversation_member`

字段建议：

- `id`
- `conversation_id`
- `user_id`
- `joined_at`
- `role`

索引建议：

- `(conversation_id, user_id)` 唯一索引

#### `chat_message`

字段建议：

- `id`
- `conversation_id`
- `sender_id`
- `message_type`
- `content`
- `client_message_id`
- `sent_at`
- `status`

说明：

- `message_type` 支持 text、image、file、system

#### `chat_message_read`

字段建议：

- `id`
- `message_id`
- `user_id`
- `read_at`

#### `chat_user_session`

字段建议：

- `id`
- `conversation_id`
- `user_id`
- `unread_count`
- `last_read_message_id`
- `is_pinned`
- `is_muted`
- `last_seen_at`

说明：

- 会话摘要和未读数核心表

#### `chat_online_status`

字段建议：

- `id`
- `user_id`
- `status`
- `last_active_at`
- `device_id`

### 4.4 审批域

#### `approval_template`

字段建议：

- `id`
- `tenant_id`
- `template_code`
- `template_name`
- `category`
- `form_schema`
- `status`

说明：

- `form_schema` 可用 JSONB

#### `approval_instance`

字段建议：

- `id`
- `tenant_id`
- `template_id`
- `applicant_id`
- `title`
- `reason`
- `status`
- `current_node_id`
- `started_at`
- `finished_at`

#### `approval_instance_form`

字段建议：

- `id`
- `instance_id`
- `form_data`

说明：

- 使用 JSONB 存表单数据

#### `approval_node`

字段建议：

- `id`
- `template_id`
- `node_name`
- `node_type`
- `sort_no`
- `approver_rule`

#### `approval_instance_node`

字段建议：

- `id`
- `instance_id`
- `node_id`
- `approver_id`
- `status`
- `acted_at`
- `comment`

#### `approval_action_log`

字段建议：

- `id`
- `instance_id`
- `action_type`
- `operator_id`
- `comment`
- `acted_at`

#### `approval_cc`

字段建议：

- `id`
- `instance_id`
- `user_id`
- `read_at`

### 4.5 考勤域

#### `attendance_rule`

字段建议：

- `id`
- `tenant_id`
- `name`
- `start_time`
- `end_time`
- `allow_late_minutes`
- `allow_remote`
- `status`

#### `attendance_record`

字段建议：

- `id`
- `user_id`
- `record_date`
- `check_type`
- `check_time`
- `latitude`
- `longitude`
- `address`
- `device_id`
- `result_status`

说明：

- `check_type` 支持 check_in、check_out

#### `attendance_daily_summary`

字段建议：

- `id`
- `user_id`
- `summary_date`
- `check_in_time`
- `check_out_time`
- `status`
- `is_late`
- `is_absent`
- `rule_id`

说明：

- 工作台和我的页优先查这张汇总表

#### `attendance_exception`

字段建议：

- `id`
- `user_id`
- `summary_date`
- `exception_type`
- `description`
- `status`

### 4.6 个人中心域

#### `profile_setting`

字段建议：

- `id`
- `user_id`
- `notifications_enabled`
- `sound_enabled`
- `language`
- `theme_mode`

#### `profile_badge`

字段建议：

- `id`
- `badge_code`
- `name`
- `description`
- `icon`

#### `profile_user_badge`

字段建议：

- `id`
- `user_id`
- `badge_id`
- `earned_at`

#### `salary_slip`

字段建议：

- `id`
- `user_id`
- `salary_month`
- `gross_amount`
- `net_amount`
- `status`
- `issued_at`

#### `salary_item`

字段建议：

- `id`
- `salary_slip_id`
- `item_name`
- `item_type`
- `amount`

说明：

- `item_type` 可区分 income、deduction

#### `feedback_ticket`

字段建议：

- `id`
- `user_id`
- `category`
- `content`
- `contact`
- `status`
- `submitted_at`

### 4.7 通知与审计域

#### `notification_message`

字段建议：

- `id`
- `tenant_id`
- `type`
- `title`
- `content`
- `biz_type`
- `biz_id`
- `sent_at`

#### `notification_user_inbox`

字段建议：

- `id`
- `notification_id`
- `user_id`
- `is_read`
- `read_at`

#### `audit_operation_log`

字段建议：

- `id`
- `user_id`
- `module`
- `action`
- `biz_id`
- `request_id`
- `ip`
- `created_at`

## 5. 关键关系设计

### 5.1 用户与组织

- `auth_user` 1 对 1 `user_profile`
- `user_profile` N 对 N `org_department`
- `user_profile` N 对 N `org_position`

### 5.2 聊天

- `chat_conversation` 1 对 N `chat_message`
- `chat_conversation` 1 对 N `chat_conversation_member`
- `chat_message` 1 对 N `chat_message_read`
- `chat_conversation` 1 对 N `chat_user_session`

### 5.3 审批

- `approval_template` 1 对 N `approval_node`
- `approval_instance` 1 对 1 `approval_instance_form`
- `approval_instance` 1 对 N `approval_instance_node`
- `approval_instance` 1 对 N `approval_action_log`

### 5.4 考勤

- `attendance_rule` 1 对 N `attendance_daily_summary`
- `attendance_daily_summary` 1 对 N `attendance_record`

## 6. 索引建议

推荐优先建立以下索引：

- `auth_user(login_id)`
- `user_profile(name)`
- `org_department(parent_id)`
- `chat_message(conversation_id, sent_at desc)`
- `chat_user_session(user_id, unread_count desc)`
- `chat_conversation(latest_message_time desc)`
- `approval_instance(applicant_id, started_at desc)`
- `approval_instance(status, started_at desc)`
- `attendance_daily_summary(user_id, summary_date desc)`
- `salary_slip(user_id, salary_month desc)`
- `notification_user_inbox(user_id, is_read)`

## 7. 数据库设计原则

- 主表表达业务对象
- 摘要信息通过聚合查询或缓存输出
- 审批表单、模板等结构化不稳定字段优先用 JSONB
- 金额字段统一用 decimal，不用 float
- 时间统一存 UTC，展示时由前端转换
- 所有状态字段统一用枚举码

## 8. 建议的状态枚举

### 8.1 审批状态

- `PENDING`
- `APPROVED`
- `REJECTED`
- `REVOKED`

### 8.2 考勤状态

- `NOT_CHECKED_IN`
- `CHECKED_IN`
- `LATE`
- `ABSENT`
- `ON_LEAVE`

### 8.3 消息类型

- `TEXT`
- `IMAGE`
- `FILE`
- `SYSTEM`

## 9. 一句话结论

这套数据库设计以关系型主模型为基础，兼顾审批表单和配置类 JSON 扩展，既能支撑当前 Flutter 页面，也适合继续往企业级协同系统演进。
