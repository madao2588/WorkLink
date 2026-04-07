// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get loginPleaseEnterAccountAndPassword => '请输入账号和密码';

  @override
  String get loginFailed => '登录失败';

  @override
  String get loginDemoAccount => '演示账号：zhangsan / 123456';

  @override
  String get loginHeroBrand => 'WORKLINK';

  @override
  String get loginHeroTitle => '连接团队协作工作流';

  @override
  String get loginHeroSubtitle => '登录以同步消息、审批、考勤、通讯录以及你的工作台总览。';

  @override
  String get loginTitleWelcomeBack => '欢迎回来';

  @override
  String get loginSubtitleDemoAccount => '使用后端演示账号进入已连接的工作空间。';

  @override
  String get loginLabelAccount => '账号';

  @override
  String get loginLabelPassword => '密码';

  @override
  String get loginConnecting => '正在连接...';

  @override
  String get loginEnterWorkLink => '进入 WorkLink';

  @override
  String contactsHeaderOnlineCount(int count) {
    return '$count 在线';
  }

  @override
  String get contactsTitle => '通讯录';

  @override
  String get contactsSubtitle => '由后端目录服务驱动，并与在线状态保持同步。';

  @override
  String get contactsDirectoryTitle => '目录';

  @override
  String get contactsDirectorySubtitleDefault => '按部门与在线状态浏览同事';

  @override
  String get contactsDirectorySubtitleFiltered => '结果已按姓名与部门筛选';

  @override
  String get contactsSearchHint => '搜索人员或部门';

  @override
  String get contactsOnlineNowTitle => '在线同事';

  @override
  String get contactsOnlineNowSubtitle => '优先联系更适合快速协作的同事';

  @override
  String get contactsNoOnlineMatched => '没有找到与当前搜索条件匹配的在线联系人';

  @override
  String contactsPeopleCount(int count) {
    return '$count 人';
  }

  @override
  String get contactsNoContactsMatched => '没有找到与搜索条件匹配的联系人';

  @override
  String get contactsTryAnotherKeyword => '尝试其他关键词或清除筛选条件';

  @override
  String get contactsOnline => '在线';

  @override
  String get contactsOffline => '离线';

  @override
  String get routerRecoveryFailedTitle => '页面恢复失败';

  @override
  String get routerReturnToApp => '返回应用';

  @override
  String get workplaceFallbackUserName => '同事';

  @override
  String get workplaceDateFormat => 'MMMd';

  @override
  String workplaceHeroSubtitle(String dateLabel) {
    return '$dateLabel · 今天也把重点工作推进一点';
  }

  @override
  String get workplaceHeroStatCheckedIn => '已打卡';

  @override
  String get workplaceHeroStatPendingCheckIn => '待打卡';

  @override
  String get workplaceHeroStatLate => '迟到';

  @override
  String get workplaceHeroStatMissing => '缺卡';

  @override
  String get workplaceSectionCommandTitle => '今日指挥台';

  @override
  String get workplaceSectionCommandSubtitle => '先处理最能减少今天阻力的那一步';

  @override
  String get workplaceSectionOverviewTitle => '今日概览';

  @override
  String get workplaceSectionOverviewSubtitle => '把核心状态集中放在一个地方查看';

  @override
  String get workplaceSectionActionsTitle => '高频入口';

  @override
  String get workplaceSectionActionsSubtitle => '保留最常用的工作动作，减少跳转负担';

  @override
  String get workplaceSectionFocusTitle => '待你处理';

  @override
  String get workplaceSectionFocusSubtitle => '先处理最影响今天推进效率的事项';

  @override
  String get workplaceSectionPulseTitle => '运行状态';

  @override
  String get workplaceSectionPulseSubtitle => '快速确认关键模块是否都在正常同步';

  @override
  String get workplaceSectionUpdatesTitle => '动态与节奏';

  @override
  String get workplaceSectionUpdatesSubtitle => '用公告和最近动态，帮助你在打开应用后快速找回上下文';

  @override
  String get workplaceSectionAnnouncementsTitle => '公告提醒';

  @override
  String get workplaceSectionAnnouncementsSubtitle => '开始工作前，先看几条和当日推进有关的提醒';

  @override
  String get workplaceSectionAnnouncementsTimelineTitle => '最近动态';

  @override
  String get workplaceSectionAnnouncementsTimelineSubtitle =>
      '把今天的审批、打卡和会话更新压缩到一条短时间线里';

  @override
  String get workplaceCommandRecommendedLabel => '建议先做';

  @override
  String get workplaceCommandQueueLabel => '当前队列';

  @override
  String get workplaceCommandQueueSubtitle => '把三条主工作流里仍待处理的事项压缩到一个紧凑视图里';

  @override
  String get workplaceMetricStatusLabel => '今日状态';

  @override
  String get workplaceMetricStatusHintCheckedIn => '状态已同步';

  @override
  String get workplaceMetricStatusHintPending => '待完成打卡';

  @override
  String get workplaceMetricCheckInLabel => '打卡时间';

  @override
  String get workplaceMetricCheckInHintRecorded => '已记录';

  @override
  String get workplaceMetricCheckInHintNotYet => '尚未打卡';

  @override
  String get workplaceMetricPendingApprovalsLabel => '待审批';

  @override
  String get workplaceMetricPendingApprovalsHint => '需要跟进的流程';

  @override
  String get workplaceMetricUnreadMessagesLabel => '未读消息';

  @override
  String workplaceMetricUnreadMessagesHint(int count) {
    return '$count 位同事在线 · 优先处理未读消息';
  }

  @override
  String get workplaceActionAttendanceTitle => '考勤打卡';

  @override
  String get workplaceActionAttendanceSubtitle => '快速记录今日到岗状态';

  @override
  String get workplaceActionApprovalTitle => '审批中心';

  @override
  String get workplaceActionApprovalSubtitle => '查看并处理待办申请';

  @override
  String get workplaceActionLogTitle => '工作日志';

  @override
  String get workplaceActionLogSubtitle => '沉淀进展，方便团队同步';

  @override
  String get workplaceActionNoticeTitle => '企业公告';

  @override
  String get workplaceActionNoticeSubtitle => '查看团队通知与制度更新';

  @override
  String get workplaceGreetingMorning => '早上好';

  @override
  String get workplaceGreetingAfternoon => '下午好';

  @override
  String get workplaceGreetingEvening => '晚上好';

  @override
  String get workplaceNotCheckedInValue => '未打卡';

  @override
  String get workplaceActionEnterNow => '立即进入';

  @override
  String get workplaceSnackBarAlreadyCheckedIn => '今天已经完成打卡了';

  @override
  String get workplaceSnackBarCheckInSuccess => '打卡成功，状态已更新';

  @override
  String get workplaceSnackBarLogReady => '最近动态已经展示在下方时间线里了';

  @override
  String get workplaceSnackBarNoticeReady => '公告提醒已经展示在下方面板里了';

  @override
  String get workplacePriorityAttendanceTitle => '今日考勤';

  @override
  String get workplacePriorityAttendancePendingSummary => '还没有完成今天的打卡';

  @override
  String get workplacePriorityAttendancePendingDetail => '建议先完成签到，再开始处理其他工作';

  @override
  String get workplacePriorityAttendanceDoneSummary => '今日考勤已记录';

  @override
  String workplacePriorityAttendanceDoneDetail(String time) {
    return '签到时间：$time';
  }

  @override
  String get workplacePriorityApprovalsTitle => '审批跟进';

  @override
  String get workplacePriorityApprovalsNoneSummary => '目前没有待处理审批';

  @override
  String get workplacePriorityApprovalsNoneDetail => '可以继续处理其他事项，审批中心保持清空状态';

  @override
  String workplacePriorityApprovalsPendingSummary(int count) {
    return '有 $count 条审批等待你处理';
  }

  @override
  String workplacePriorityApprovalsPendingDetail(
    int approvedCount,
    int rejectedCount,
  ) {
    return '已通过 $approvedCount 条 · 已驳回 $rejectedCount 条';
  }

  @override
  String get workplacePriorityMessagesTitle => '消息处理';

  @override
  String workplacePriorityMessagesUnreadSummary(int count) {
    return '还有 $count 个会话未读';
  }

  @override
  String workplacePriorityMessagesUnreadDetail(int onlineCount) {
    return '$onlineCount 位同事在线，适合快速协作';
  }

  @override
  String get workplacePriorityMessagesClearSummary => '消息队列已经处理完毕';

  @override
  String workplacePriorityMessagesClearDetail(int onlineCount) {
    return '$onlineCount 位同事在线，当前没有未读压力';
  }

  @override
  String get workplacePriorityLevelCritical => '优先';

  @override
  String get workplacePriorityLevelHigh => '较高';

  @override
  String get workplacePriorityLevelSteady => '平稳';

  @override
  String get workplacePulseAttendanceLabel => '考勤接口';

  @override
  String get workplacePulseApprovalsLabel => '审批接口';

  @override
  String get workplacePulseMessagesLabel => '消息接口';

  @override
  String get workplacePulseStateLoading => '同步中';

  @override
  String get workplacePulseStateHealthy => '已同步';

  @override
  String get workplacePulseStateError => '异常';

  @override
  String get workplacePulseDetailHealthy => '数据已准备好';

  @override
  String get workplacePulseDetailLoading => '正在拉取最新状态';

  @override
  String get workplaceAnnouncementTagPolicy => '制度';

  @override
  String get workplaceAnnouncementTagReminder => '提醒';

  @override
  String get workplaceAnnouncementTagCollaboration => '协作';

  @override
  String get workplaceAnnouncementApprovalPolicyTitle => '审批时效提醒已刷新';

  @override
  String get workplaceAnnouncementApprovalPolicyDetail =>
      '当天 18:00 前提交的申请，建议尽量在当日完成首轮处理。';

  @override
  String get workplaceAnnouncementAttendanceTitle => '考勤异常现在会优先显示';

  @override
  String get workplaceAnnouncementAttendanceDetail =>
      '迟到和缺卡状态会持续保留在工作台上，直到被处理为止。';

  @override
  String get workplaceAnnouncementCollaborationTitle => '未读会话会优先进入协作视野';

  @override
  String get workplaceAnnouncementCollaborationDetail =>
      '开始深度工作前，建议先清理未读会话，避免遗漏紧急沟通。';

  @override
  String get workplaceAnnouncementAction => '在工作台查看';

  @override
  String get workplaceTimelineAttendanceDoneTitle => '今日考勤已记录';

  @override
  String workplaceTimelineAttendanceDoneDetail(String time) {
    return '签到时间 $time';
  }

  @override
  String get workplaceTimelineAttendancePendingTitle => '今日考勤仍待处理';

  @override
  String get workplaceTimelineAttendancePendingDetail =>
      '今天还没有完成打卡，建议先补齐再处理其他事项。';

  @override
  String workplaceTimelineApprovalTitle(String applicant) {
    return '$applicant 提交了一条审批';
  }

  @override
  String workplaceTimelineApprovalPendingDetail(String title) {
    return '待继续跟进: $title';
  }

  @override
  String workplaceTimelineApprovalApprovedDetail(String title) {
    return '已通过并归档: $title';
  }

  @override
  String workplaceTimelineApprovalRejectedDetail(String title) {
    return '已退回修改: $title';
  }

  @override
  String workplaceTimelineMessageTitle(String name) {
    return '与 $name 的会话有更新';
  }

  @override
  String workplaceTimelineMessageUnreadDetail(String preview, int count) {
    return '$preview - 还有 $count 条未读';
  }

  @override
  String workplaceTimelineMessageReadDetail(String preview) {
    return '$preview';
  }

  @override
  String get workplaceTimelineTagAttendance => '考勤';

  @override
  String get workplaceTimelineTagAttention => '待处理';

  @override
  String get workplaceTimelineTagPending => '待审批';

  @override
  String get workplaceTimelineTagApproved => '已通过';

  @override
  String get workplaceTimelineTagRejected => '已退回';

  @override
  String get workplaceTimelineTagUnread => '未读';

  @override
  String get workplaceTimelineTagUpdated => '已更新';

  @override
  String get workplaceTimelineEmptyState => '审批、打卡和消息同步后，会在这里显示最近动态。';

  @override
  String workplaceTimelineTimeToday(String time) {
    return '今天 $time';
  }

  @override
  String get profilePleaseRelogin => '请重新登录';

  @override
  String get profileOverviewLoadFailed => '个人数据加载失败';

  @override
  String get profileMetricAttendanceLabel => '出勤状态';

  @override
  String get profileMetricAttendanceCaptionNotCheckedIn => '今日尚未打卡';

  @override
  String get profileMetricPendingApprovalsLabel => '待审批';

  @override
  String get profileMetricPendingApprovalsCaption => '待你跟进的流程事项';

  @override
  String get profileMetricMessagesLabel => '消息记录';

  @override
  String profileMetricMessagesCaption(int count) {
    return '未读 $count 条';
  }

  @override
  String get profileSectionManagementTitle => '管理能力';

  @override
  String get profileSectionManagementSubtitle => '只把真正和当前角色相关的后台入口展示出来';

  @override
  String get profileSectionWorkspaceTitle => '个人工作台';

  @override
  String get profileSectionWorkspaceSubtitle => '把常用入口整理成更容易查找的分组';

  @override
  String get profileSectionPersonalTitle => '个人事务';

  @override
  String get profileActionMyApprovalsTitle => '我的审批';

  @override
  String get profileActionMyApprovalsSubtitle => '查看申请记录与审批流转';

  @override
  String get profileActionSalarySlipsTitle => '工资条';

  @override
  String get profileActionSalarySlipsSubtitle => '查看薪资相关信息入口';

  @override
  String get profileActionBadgesTitle => '我的勋章';

  @override
  String get profileActionBadgesSubtitle => '沉淀阶段成果与荣誉记录';

  @override
  String get profileActionEnterpriseAdminTitle => '企业管理台';

  @override
  String profileActionEnterpriseAdminSubtitle(String role) {
    return '当前角色：$role';
  }

  @override
  String get profileSectionSettingsTitle => '系统设置';

  @override
  String get profileActionAccountSecurityTitle => '账号与安全';

  @override
  String get profileActionAccountSecuritySubtitle => '登录设备、隐私和安全设置';

  @override
  String get profileActionGeneralSettingsTitle => '通用设置';

  @override
  String get profileActionGeneralSettingsSubtitle => '通知、显示和常用偏好';

  @override
  String get profileActionHelpFeedbackTitle => '帮助与反馈';

  @override
  String get profileActionHelpFeedbackSubtitle => '提交问题或获取使用帮助';

  @override
  String get profileHeroOnline => '在线办公中';

  @override
  String get profileHeroVerified => '已认证账号';

  @override
  String get profileHeroUnreadMessagesLabel => '未读消息';

  @override
  String get profileLogoutButton => '退出登录';

  @override
  String profileActionComingSoon(String title) {
    return '$title 功能正在完善中';
  }

  @override
  String get profileLogoutDialogTitle => '退出登录';

  @override
  String get profileLogoutDialogContent => '确定要退出当前账号吗？';

  @override
  String get profileDialogCancel => '取消';

  @override
  String get profileDialogConfirmLogout => '退出';

  @override
  String get profileAttendanceCheckedIn => '已打卡';

  @override
  String get profileAttendanceLate => '迟到';

  @override
  String get profileAttendancePending => '待打卡';

  @override
  String profileCheckInTimeLabel(String time) {
    return '签到时间 $time';
  }

  @override
  String get profileReload => '重新加载';

  @override
  String get salarySlipsTitle => '工资条';

  @override
  String get salarySlipsRecentTitle => '最近薪资记录';

  @override
  String get salarySlipsEmpty => '暂无工资条数据';

  @override
  String get salarySlipsSummaryWaiting => '等待后端返回工资条数据';

  @override
  String salarySlipsSummaryLatest(String month) {
    return '最近一期为 $month，已在后端工资条接口中同步。';
  }

  @override
  String get salarySlipsSummaryCurrentNet => '本月实发';

  @override
  String get salarySlipsNetPayLabel => '实发工资';

  @override
  String get salarySlipsGrossPayLabel => '应发工资';

  @override
  String get salarySlipsIssuedAtLabel => '发放时间';

  @override
  String get badgesTitle => '我的勋章';

  @override
  String get badgesIntroEmpty => '勋章数据会从后端个人中心接口加载。';

  @override
  String badgesIntroCount(int count) {
    return '当前已同步 $count 枚勋章，记录你在协作中的阶段成果。';
  }

  @override
  String get badgesEmpty => '暂无勋章数据';

  @override
  String get accountSecurityTitle => '账号与安全';

  @override
  String get accountSecurityIntroEmpty => '账号安全信息将通过后端安全接口加载。';

  @override
  String get accountSecurityIntroLoaded => '已同步绑定方式、设备信息和安全策略，便于统一管理登录安全。';

  @override
  String get accountSecurityEmpty => '暂无账号安全数据';

  @override
  String get accountSecuritySectionAccountInfo => '账号信息';

  @override
  String get accountSecurityLabelMobile => '绑定手机';

  @override
  String get accountSecurityLabelEmail => '绑定邮箱';

  @override
  String get accountSecurityLabelPasswordUpdatedAt => '密码更新时间';

  @override
  String get accountSecurityLabelMfa => '多因素认证';

  @override
  String get accountSecurityMfaEnabled => '已开启';

  @override
  String get accountSecurityMfaDisabled => '未开启';

  @override
  String get accountSecuritySectionRecentDevices => '最近登录设备';

  @override
  String get accountSecurityCurrentDevice => '当前设备';

  @override
  String get generalSettingsTitle => '通用设置';

  @override
  String get generalSettingsEmpty => '暂无设置数据';

  @override
  String get generalSettingsSectionNotifications => '通知偏好';

  @override
  String get generalSettingsPushTitle => '消息推送';

  @override
  String get generalSettingsPushSubtitle => '收到聊天或审批时即时提醒';

  @override
  String get generalSettingsSoundTitle => '声音提醒';

  @override
  String get generalSettingsSoundSubtitle => '允许声音反馈和系统提示';

  @override
  String get generalSettingsSectionDisplay => '显示与偏好';

  @override
  String get generalSettingsLanguageTitle => '语言';

  @override
  String get generalSettingsLanguageSubtitle => '设置界面显示语言';

  @override
  String get generalSettingsLanguageZhHans => '简体中文';

  @override
  String get generalSettingsThemeTitle => '主题';

  @override
  String get generalSettingsThemeSubtitle => '后端已保存当前主题模式';

  @override
  String get generalSettingsThemeLight => '浅色';

  @override
  String get generalSettingsThemeDark => '深色';

  @override
  String get generalSettingsSectionOther => '其他';

  @override
  String get generalSettingsCacheSizeTitle => '缓存大小';

  @override
  String get generalSettingsVersionTitle => '当前版本';

  @override
  String get generalSettingsVersionValue => 'WorkLink 1.0.0';

  @override
  String get helpFeedbackTitle => '帮助与反馈';

  @override
  String get helpFeedbackIntro => '这页现在已经能把反馈真实提交到后端接口，方便你后续接工单、邮件或后台管理。';

  @override
  String get helpFeedbackFaqMessagesTitle => '为什么消息没有刷新？';

  @override
  String get helpFeedbackFaqMessagesAnswer =>
      '请先确认本地后端已启动，当前消息和个人中心已经开始依赖真实接口。';

  @override
  String get helpFeedbackFaqApprovalTitle => '审批提交后在哪里查看？';

  @override
  String get helpFeedbackFaqApprovalAnswer => '可以在“我的审批”或工作台入口进入审批中心查看最新记录。';

  @override
  String get helpFeedbackFaqLoginTitle => '登录失败怎么办？';

  @override
  String get helpFeedbackFaqLoginAnswer =>
      '先确认后端服务正常运行，再检查演示账号 zhangsan / 123456 是否可用。';

  @override
  String get helpFeedbackSubmitSectionTitle => '提交反馈';

  @override
  String get helpFeedbackCategoryFeature => '功能建议';

  @override
  String get helpFeedbackCategoryUi => '界面体验';

  @override
  String get helpFeedbackCategoryBug => 'Bug 反馈';

  @override
  String get helpFeedbackInputHint => '描述你的问题或建议，提交后会通过后端反馈接口保存。';

  @override
  String get helpFeedbackSubmitting => '提交中...';

  @override
  String get helpFeedbackSubmitButton => '提交反馈';

  @override
  String get helpFeedbackEmptyContent => '请先填写反馈内容';

  @override
  String get helpFeedbackSubmitSuccess => '反馈已提交到后端';

  @override
  String get approvalTitle => '我的审批';

  @override
  String get approvalEmpty => '暂无申请记录';

  @override
  String approvalReasonLabel(String reason) {
    return '申请原因：$reason';
  }

  @override
  String approvalSubmittedAtLabel(String time) {
    return '提交时间：$time';
  }

  @override
  String get approvalStatusPending => '审批中';

  @override
  String get approvalStatusApproved => '已通过';

  @override
  String get approvalStatusRejected => '已驳回';

  @override
  String get approvalDecisionTitle => '审批决策';

  @override
  String get approvalApproveAction => '同意申请';

  @override
  String get approvalRejectAction => '驳回申请';

  @override
  String get approvalSubmitDialogTitle => '发起申请';

  @override
  String get approvalSubmitDialogHint => '请输入申请原因（如：感冒请假）';

  @override
  String get approvalDialogCancel => '取消';

  @override
  String get approvalDialogSubmit => '提交';

  @override
  String get enterpriseAdminPermissionEmployees => '当前账号没有员工资料维护权限';

  @override
  String get enterpriseAdminPermissionDepartments => '当前账号没有部门维护权限';

  @override
  String get enterpriseAdminPermissionPositions => '当前账号没有岗位维护权限';

  @override
  String get enterpriseAdminPermissionAccounts => '当前账号没有账号权限配置权限';

  @override
  String get enterpriseAdminPermissionExport => '当前账号没有 Excel 导出权限';

  @override
  String get enterpriseAdminPermissionDashboard => '当前账号没有驾驶舱查看权限';

  @override
  String get enterpriseAdminTitle => '企业管理台';

  @override
  String get enterpriseAdminSubtitle => '按角色呈现组织数据、编制概览和可达管理能力，先把后台入口做轻但做稳。';

  @override
  String enterpriseAdminRoleChip(String role) {
    return '角色：$role';
  }

  @override
  String enterpriseAdminSessionChip(String name) {
    return '会话：$name';
  }

  @override
  String get enterpriseAdminFilterAll => '全部';

  @override
  String get enterpriseAdminDataSourceChipLive => '组织数据：后端同步';

  @override
  String get enterpriseAdminDataSourceChipFallback => '组织数据：演示回退';

  @override
  String get enterpriseAdminDataSourceChipLoading => '组织数据：同步中';

  @override
  String get enterpriseAdminSectionOverviewTitle => '总览';

  @override
  String get enterpriseAdminSectionOverviewSubtitle =>
      '先用一页轻量驾驶舱，把当前管理范围清晰展示出来';

  @override
  String get enterpriseAdminSectionModulesTitle => '模块权限';

  @override
  String get enterpriseAdminSectionModulesSubtitle => '每个管理域都会按当前角色显示可用或锁定状态';

  @override
  String get enterpriseAdminSectionActionsTitle => '操作中心';

  @override
  String get enterpriseAdminSectionActionsSubtitle =>
      '按当前权限执行同步与导出，先把真正能操作的动作集中起来';

  @override
  String get enterpriseAdminSectionPreviewTitle => '数据速览';

  @override
  String get enterpriseAdminSectionPreviewSubtitle =>
      '把当前角色真正能查看的数据做成轻量明细入口，先从只读速览做稳';

  @override
  String get enterpriseAdminSectionPermissionsTitle => '权限摘要';

  @override
  String get enterpriseAdminSectionPermissionsSubtitle => '快速确认当前账号此刻到底能管理什么';

  @override
  String get enterpriseAdminDataSourceLiveTitle => '企业管理数据已切到后端同步';

  @override
  String get enterpriseAdminDataSourceLiveSubtitle =>
      '员工、部门、岗位和账号摘要现在都来自后端总览接口，不再只依赖本地演示列表。';

  @override
  String get enterpriseAdminDataSourceLoadingTitle => '正在同步组织数据';

  @override
  String get enterpriseAdminDataSourceLoadingSubtitle =>
      '企业管理页正在从后端拉取最新的员工、部门、岗位和账号信息。';

  @override
  String get enterpriseAdminDataSourceFallbackTitle => '企业管理数据暂时仍在使用演示数据';

  @override
  String get enterpriseAdminDataSourceFallbackSubtitle =>
      '后端总览接口暂未成功返回，页面已自动回退到本地示例数据，方便你继续查看。';

  @override
  String get enterpriseAdminRetrySync => '重新同步';

  @override
  String get enterpriseAdminActionSyncNow => '立即同步';

  @override
  String get enterpriseAdminActionChangeCenter => '变更中心';

  @override
  String get enterpriseAdminActionExportEmployees => '导出员工';

  @override
  String get enterpriseAdminActionExportDepartments => '导出部门';

  @override
  String get enterpriseAdminActionExportPositions => '导出岗位';

  @override
  String get enterpriseAdminActionExportReady => '当前账号可执行导出，选择保存位置后会提示文件保存路径。';

  @override
  String get enterpriseAdminActionExportUnavailable =>
      '当前账号暂时没有导出权限，所以导出动作会保持禁用。';

  @override
  String get enterpriseAdminExportCancelled => '已取消导出。';

  @override
  String enterpriseAdminExportSuccess(String path) {
    return '导出完成：$path';
  }

  @override
  String get enterpriseAdminSyncCompleted => '组织数据已经完成同步。';

  @override
  String get enterpriseAdminPreviewEmployeesTitle => '员工速览';

  @override
  String get enterpriseAdminPreviewEmployeesSubtitle => '查看最新员工记录，并打开轻量只读明细';

  @override
  String get enterpriseAdminPreviewEmployeesEmpty => '当前还没有员工数据。';

  @override
  String get enterpriseAdminPreviewDepartmentsTitle => '部门速览';

  @override
  String get enterpriseAdminPreviewDepartmentsSubtitle => '查看负责人、成员数量和部门说明';

  @override
  String get enterpriseAdminPreviewDepartmentsEmpty => '当前还没有部门数据。';

  @override
  String get enterpriseAdminPreviewOpenAll => '查看全部';

  @override
  String get enterpriseAdminPreviewPositionsTitle => '岗位速览';

  @override
  String get enterpriseAdminPreviewPositionsSubtitle => '快速查看级别、编制人数和招聘缺口';

  @override
  String get enterpriseAdminPreviewPositionsEmpty => '当前还没有岗位数据。';

  @override
  String get enterpriseAdminPreviewAccountsTitle => '账号速览';

  @override
  String get enterpriseAdminPreviewAccountsSubtitle => '查看账号身份、映射角色和启停状态';

  @override
  String get enterpriseAdminPreviewAccountsEmpty => '当前还没有账号数据。';

  @override
  String get enterpriseAdminPreviewAccountEnabled => '启用';

  @override
  String get enterpriseAdminPreviewAccountDisabled => '停用';

  @override
  String get enterpriseAdminEmployeesPageTitle => '员工列表';

  @override
  String get enterpriseAdminEmployeesPageSubtitle =>
      '把当前角色可查看的员工档案放到独立只读页里，方便连续检索与浏览。';

  @override
  String get enterpriseAdminEmployeesSearchHint => '搜索姓名、工号、部门或岗位';

  @override
  String enterpriseAdminEmployeesPageSummary(Object count) {
    return '当前共 $count 名员工';
  }

  @override
  String get enterpriseAdminEmployeesEmpty => '当前筛选下没有员工记录。';

  @override
  String get enterpriseAdminEmployeesStatsDepartments => '覆盖部门';

  @override
  String get enterpriseAdminEmployeesStatsPositions => '覆盖岗位';

  @override
  String get enterpriseAdminDepartmentsPageTitle => '部门列表';

  @override
  String get enterpriseAdminDepartmentsPageSubtitle =>
      '把部门负责人、成员规模和说明单独展开，便于按组织维度连续查看。';

  @override
  String get enterpriseAdminDepartmentsSearchHint => '搜索部门名称或负责人';

  @override
  String enterpriseAdminDepartmentsPageSummary(Object count) {
    return '当前共 $count 个部门';
  }

  @override
  String get enterpriseAdminDepartmentsEmpty => '当前筛选下没有部门记录。';

  @override
  String enterpriseAdminDepartmentsMemberCount(Object count) {
    return '$count 人';
  }

  @override
  String get enterpriseAdminDepartmentsStatsMembers => '成员总数';

  @override
  String get enterpriseAdminDepartmentsStatsLargest => '最大团队';

  @override
  String get enterpriseAdminDepartmentsFilterLarge => '10 人以上';

  @override
  String get enterpriseAdminDepartmentsFilterMedium => '5-9 人';

  @override
  String get enterpriseAdminDepartmentsFilterCompact => '4 人以下';

  @override
  String get enterpriseAdminPositionsPageTitle => '岗位列表';

  @override
  String get enterpriseAdminPositionsPageSubtitle =>
      '把岗位级别、编制人数和招聘缺口单独展开，便于从编制视角连续查看。';

  @override
  String get enterpriseAdminPositionsSearchHint => '搜索岗位名称、所属部门或级别';

  @override
  String enterpriseAdminPositionsPageSummary(Object count) {
    return '当前共 $count 个岗位';
  }

  @override
  String get enterpriseAdminPositionsEmpty => '当前筛选下没有岗位记录。';

  @override
  String enterpriseAdminPositionsVacancy(Object count) {
    return '缺口 $count';
  }

  @override
  String get enterpriseAdminPositionsStatsHeadcount => '编制人数';

  @override
  String get enterpriseAdminPositionsStatsVacancy => '招聘缺口';

  @override
  String get enterpriseAdminAccountsPageTitle => '账号列表';

  @override
  String get enterpriseAdminAccountsPageSubtitle =>
      '把当前角色可见的系统账号集中成只读页，便于确认登录标识、角色和启停状态。';

  @override
  String get enterpriseAdminAccountsSearchHint => '搜索账号名称或登录账号';

  @override
  String enterpriseAdminAccountsPageSummary(Object count) {
    return '当前共 $count 个账号';
  }

  @override
  String get enterpriseAdminAccountsEmpty => '当前筛选下没有账号记录。';

  @override
  String get enterpriseAdminAccountsStatsEnabled => '启用中';

  @override
  String get enterpriseAdminAccountsStatsDisabled => '停用中';

  @override
  String get enterpriseAdminChangeRequestsPageTitle => '变更中心';

  @override
  String get enterpriseAdminChangeRequestsPageSubtitle =>
      '把直接编辑和变更申请集中到一页查看，方便连续追踪最近的后台改动。';

  @override
  String enterpriseAdminChangeRequestsPageSummary(Object count) {
    return '当前共 $count 条变更记录';
  }

  @override
  String get enterpriseAdminChangeRequestsMetricTotal => '总记录';

  @override
  String get enterpriseAdminChangeRequestsMetricApplied => '已应用';

  @override
  String get enterpriseAdminChangeRequestsMetricDrafted => '草稿中';

  @override
  String get enterpriseAdminChangeRequestsSearchHint => '搜索申请编号、对象名称、说明或提交人';

  @override
  String get enterpriseAdminChangeRequestsEmpty => '当前筛选下没有变更记录。';

  @override
  String get enterpriseAdminChangeRequestsStatusApplied => '已应用';

  @override
  String get enterpriseAdminChangeRequestsStatusDrafted => '草稿中';

  @override
  String get enterpriseAdminChangeRequestsStatusRejected => '已驳回';

  @override
  String get enterpriseAdminChangeRequestsEntityEmployee => '员工';

  @override
  String get enterpriseAdminChangeRequestsEntityDepartment => '部门';

  @override
  String get enterpriseAdminChangeRequestsEntityPosition => '岗位';

  @override
  String get enterpriseAdminChangeRequestsEntityAccount => '账号';

  @override
  String get enterpriseAdminChangeRequestsOpenRecord => '查看关联对象';

  @override
  String get enterpriseAdminChangeRequestsRequester => '提交人';

  @override
  String get enterpriseAdminChangeRequestsSubmittedAt => '提交时间';

  @override
  String get enterpriseAdminChangeRequestDetailTitle => '变更详情';

  @override
  String enterpriseAdminChangeRequestDetailSubtitle(Object entityType) {
    return '查看这条 $entityType 变更的保存快照和上下文信息。';
  }

  @override
  String get enterpriseAdminChangeRequestDetailLoadFailed => '这条变更详情加载失败。';

  @override
  String get enterpriseAdminChangeRequestDetailStatus => '状态';

  @override
  String get enterpriseAdminChangeRequestDetailNoteTitle => '变更说明';

  @override
  String get enterpriseAdminChangeRequestDetailObjectLabel => '目标对象';

  @override
  String get enterpriseAdminChangeRequestDetailSnapshotTitle => '保存快照';

  @override
  String get enterpriseAdminChangeRequestDetailSnapshotSubtitle =>
      '这里展示的是提交草稿或直接编辑时记录下来的字段快照。';

  @override
  String get enterpriseAdminChangeRequestDetailSnapshotEmpty =>
      '这条变更当前没有可展示的字段快照。';

  @override
  String get enterpriseAdminChangeRequestDetailCompareTitle => '字段对比';

  @override
  String get enterpriseAdminChangeRequestDetailCompareSubtitle =>
      '把提交时的快照和当前最新数据放在一起，方便快速看出是否已经发生偏移。';

  @override
  String get enterpriseAdminChangeRequestDetailCompareEmpty =>
      '这条变更当前没有可对比的字段。';

  @override
  String get enterpriseAdminChangeRequestDetailCompareSnapshot => '快照值';

  @override
  String get enterpriseAdminChangeRequestDetailCompareCurrent => '当前值';

  @override
  String get enterpriseAdminChangeRequestDetailCompareSame => '一致';

  @override
  String get enterpriseAdminChangeRequestDetailCompareDifferent => '已变化';

  @override
  String get enterpriseAdminChangeRequestDetailCompareUnavailable => '暂无数据';

  @override
  String get enterpriseAdminChangeRequestApprove => '批准变更';

  @override
  String get enterpriseAdminChangeRequestReject => '驳回变更';

  @override
  String get enterpriseAdminChangeRequestProcessing => '处理中...';

  @override
  String get enterpriseAdminChangeRequestApproveSuccess => '这条变更已批准。';

  @override
  String get enterpriseAdminChangeRequestRejectSuccess => '这条变更已驳回。';

  @override
  String get enterpriseAdminChangeRequestReviewUnavailable => '当前账号不能处理这条变更。';

  @override
  String get enterpriseAdminDetailPanelSubtitle => '当前展示的是只读详情，适合先快速核对资料与组织信息。';

  @override
  String get enterpriseAdminDetailPanelHint =>
      '编辑、审批流和变更留痕会在后续真实管理能力接入后放到这里；这一阶段先把详情浏览做稳。';

  @override
  String get enterpriseAdminDetailActionEdit => '编辑占位';

  @override
  String get enterpriseAdminDetailActionDirectEdit => '直接编辑';

  @override
  String get enterpriseAdminDetailActionRequestChange => '申请变更';

  @override
  String get enterpriseAdminDetailActionAudit => '变更记录';

  @override
  String get enterpriseAdminDetailActionClose => '关闭';

  @override
  String get enterpriseAdminEditActionCollapse => '收起编辑';

  @override
  String get enterpriseAdminEditPanelTitle => '直接编辑';

  @override
  String get enterpriseAdminEditPanelHint =>
      '在这里直接修改员工资料并保存到后端。保存成功后，列表和详情会立即同步。';

  @override
  String get enterpriseAdminEditEmployeeTitle => '编辑员工资料';

  @override
  String get enterpriseAdminEditEmployeeHint =>
      '这一步会直接写入后端员工资料，适合快速修正部门、岗位、邮箱和手机号。';

  @override
  String get enterpriseAdminEditDepartmentTitle => '编辑部门资料';

  @override
  String get enterpriseAdminEditDepartmentHint =>
      '这一步会直接更新部门资料视图。保存后，部门卡片、员工部门名称和岗位所属部门会一起同步。';

  @override
  String get enterpriseAdminEditPositionTitle => '编辑岗位资料';

  @override
  String get enterpriseAdminEditPositionHint =>
      '这一步会直接更新岗位名称、级别和招聘缺口。保存后，岗位概览和关联员工的岗位名称会一起同步。';

  @override
  String get enterpriseAdminEditAccountTitle => '编辑账号权限';

  @override
  String get enterpriseAdminEditAccountHint =>
      '这一步会直接更新账号角色和启停用状态。登录、会话恢复和后端权限校验都会使用这份最新结果。';

  @override
  String get enterpriseAdminEditSubmit => '保存更改';

  @override
  String get enterpriseAdminEditSaving => '保存中...';

  @override
  String get enterpriseAdminEditSaveSuccess => '更改已保存。';

  @override
  String get enterpriseAdminEditEmpty => '请先填写完整的可编辑字段。';

  @override
  String get enterpriseAdminDraftActionCollapse => '收起草稿';

  @override
  String get enterpriseAdminDraftPanelTitle => '申请变更';

  @override
  String get enterpriseAdminDraftPanelHint =>
      '这一步先生成本地变更草稿，方便你确认改动方向；后续接入真实写接口后会从这里提交审批或变更单。';

  @override
  String get enterpriseAdminDraftCurrentSnapshot => '当前字段快照';

  @override
  String get enterpriseAdminDraftInputHint => '描述你想调整的内容，例如：负责人改为王五，原因是组织轮岗。';

  @override
  String get enterpriseAdminDraftSubmit => '生成变更草稿';

  @override
  String get enterpriseAdminDraftSubmitting => '提交中...';

  @override
  String get enterpriseAdminDraftSubmitSuccess => '变更草稿已生成，并已写入本地时间线。';

  @override
  String enterpriseAdminDraftSubmitSuccessWithRequest(Object requestNo) {
    return '变更草稿已提交，申请编号：$requestNo';
  }

  @override
  String get enterpriseAdminDraftEmpty => '请先填写变更说明。';

  @override
  String get enterpriseAdminDraftTypeProfile => '资料修正';

  @override
  String get enterpriseAdminDraftTypeOrg => '组织调整';

  @override
  String get enterpriseAdminDraftTypeStatus => '状态变更';

  @override
  String enterpriseAdminDraftTimelineTitle(Object type) {
    return '已生成 $type 草稿';
  }

  @override
  String enterpriseAdminDraftTimelineDetail(Object note) {
    return '草稿说明：$note';
  }

  @override
  String enterpriseAdminDraftTimelineDetailWithRequest(
    Object note,
    Object requestNo,
  ) {
    return '草稿说明：$note，申请编号：$requestNo';
  }

  @override
  String get enterpriseAdminDetailActionCopy => '复制字段';

  @override
  String get enterpriseAdminDetailActionOpenRelated => '查看关联对象';

  @override
  String enterpriseAdminDetailCopySuccess(Object label) {
    return '已复制：$label';
  }

  @override
  String get enterpriseAdminTimelineTitle => '变更时间线';

  @override
  String get enterpriseAdminTimelineHint =>
      '当前展示的是只读变更轨迹，用来快速核对最近同步、状态变化和关键组织调整。';

  @override
  String get enterpriseAdminTimelineEmpty => '当前还没有可展示的变更记录。';

  @override
  String get enterpriseAdminTimelineRecent => '刚刚';

  @override
  String get enterpriseAdminTimelineToday => '今天';

  @override
  String get enterpriseAdminTimelineEarlier => '更早';

  @override
  String get enterpriseAdminTimelineEmployeeStatus => '员工状态更新';

  @override
  String enterpriseAdminTimelineEmployeeStatusDetail(Object status) {
    return '当前状态已同步为 $status。';
  }

  @override
  String get enterpriseAdminTimelineEmployeeSync => '组织信息已同步';

  @override
  String enterpriseAdminTimelineEmployeeSyncDetail(
    Object department,
    Object position,
  ) {
    return '员工当前归属 $department，岗位为 $position。';
  }

  @override
  String get enterpriseAdminTimelineEmployeeUpdated => '员工资料已更新';

  @override
  String enterpriseAdminTimelineEmployeeUpdatedDetail(
    Object department,
    Object position,
    Object phone,
    Object email,
  ) {
    return '已更新为 $department / $position，联系电话 $phone，邮箱 $email。';
  }

  @override
  String get enterpriseAdminTimelineEmployeeCreated => '员工档案创建';

  @override
  String enterpriseAdminTimelineEmployeeCreatedDetail(Object employeeNo) {
    return '系统已为工号 $employeeNo 建立基础档案。';
  }

  @override
  String get enterpriseAdminTimelineDepartmentLeader => '负责人已确认';

  @override
  String enterpriseAdminTimelineDepartmentLeaderDetail(Object leader) {
    return '当前负责人为 $leader。';
  }

  @override
  String get enterpriseAdminTimelineDepartmentSize => '成员规模刷新';

  @override
  String enterpriseAdminTimelineDepartmentSizeDetail(Object count) {
    return '当前部门成员数更新为 $count 人。';
  }

  @override
  String get enterpriseAdminTimelineDepartmentUpdated => '部门资料已更新';

  @override
  String enterpriseAdminTimelineDepartmentUpdatedDetail(
    Object name,
    Object leader,
  ) {
    return '已更新为 $name，负责人 $leader。';
  }

  @override
  String get enterpriseAdminTimelineDepartmentCreated => '部门资料创建';

  @override
  String enterpriseAdminTimelineDepartmentCreatedDetail(Object name) {
    return '$name 已建立基础组织资料。';
  }

  @override
  String get enterpriseAdminTimelinePositionVacancy => '招聘缺口同步';

  @override
  String enterpriseAdminTimelinePositionVacancyDetail(Object count) {
    return '当前招聘缺口为 $count 个。';
  }

  @override
  String get enterpriseAdminTimelinePositionHeadcount => '编制人数更新';

  @override
  String enterpriseAdminTimelinePositionHeadcountDetail(Object count) {
    return '当前编制人数为 $count 人。';
  }

  @override
  String get enterpriseAdminTimelinePositionCreated => '岗位规划建立';

  @override
  String enterpriseAdminTimelinePositionCreatedDetail(Object department) {
    return '岗位规划已挂到 $department 下。';
  }

  @override
  String get enterpriseAdminTimelinePositionUpdated => '岗位资料已更新';

  @override
  String enterpriseAdminTimelinePositionUpdatedDetail(
    Object title,
    Object level,
    Object openQuota,
  ) {
    return '已更新为 $title / $level，招聘缺口 $openQuota 个。';
  }

  @override
  String get enterpriseAdminTimelineAccountStatus => '账号状态更新';

  @override
  String enterpriseAdminTimelineAccountStatusDetail(Object status) {
    return '当前账号状态为 $status。';
  }

  @override
  String get enterpriseAdminTimelineAccountRole => '角色映射刷新';

  @override
  String enterpriseAdminTimelineAccountRoleDetail(Object role) {
    return '当前账号角色为 $role。';
  }

  @override
  String get enterpriseAdminTimelineAccountUpdated => '账号权限已更新';

  @override
  String enterpriseAdminTimelineAccountUpdatedDetail(
    Object role,
    Object status,
  ) {
    return '已更新为角色 $role，状态 $status。';
  }

  @override
  String get enterpriseAdminTimelineAccountCreated => '账号资料创建';

  @override
  String enterpriseAdminTimelineAccountCreatedDetail(Object loginId) {
    return '登录账号 $loginId 已写入系统目录。';
  }

  @override
  String get enterpriseAdminDetailEmployeeNo => '工号';

  @override
  String get enterpriseAdminDetailDepartment => '部门';

  @override
  String get enterpriseAdminDetailPosition => '岗位';

  @override
  String get enterpriseAdminDetailEmail => '邮箱';

  @override
  String get enterpriseAdminDetailPhone => '电话';

  @override
  String get enterpriseAdminDetailStatus => '状态';

  @override
  String get enterpriseAdminDetailLeader => '负责人';

  @override
  String get enterpriseAdminDetailMemberCount => '成员数';

  @override
  String get enterpriseAdminDetailDescription => '说明';

  @override
  String get enterpriseAdminDetailLevel => '级别';

  @override
  String get enterpriseAdminDetailHeadcount => '编制人数';

  @override
  String get enterpriseAdminDetailVacancy => '招聘缺口';

  @override
  String get enterpriseAdminDetailLoginId => '登录账号';

  @override
  String get enterpriseAdminDetailRole => '角色';

  @override
  String get enterpriseAdminMetricEmployees => '员工数';

  @override
  String get enterpriseAdminMetricDepartments => '部门数';

  @override
  String get enterpriseAdminMetricPositions => '岗位数';

  @override
  String get enterpriseAdminMetricAccounts => '启用账号';

  @override
  String get enterpriseAdminModuleEmployeesTitle => '员工资料';

  @override
  String get enterpriseAdminModuleEmployeesSubtitle => '查看员工档案、状态和组织归属';

  @override
  String get enterpriseAdminModuleDepartmentsTitle => '部门设置';

  @override
  String get enterpriseAdminModuleDepartmentsSubtitle => '维护组织结构、负责人和编制边界';

  @override
  String get enterpriseAdminModulePositionsTitle => '岗位规划';

  @override
  String get enterpriseAdminModulePositionsSubtitle => '跟踪级别、编制和招聘缺口';

  @override
  String get enterpriseAdminModuleAccountsTitle => '账号权限';

  @override
  String get enterpriseAdminModuleAccountsSubtitle => '配置管理角色和账号启停状态';

  @override
  String get enterpriseAdminModuleExportTitle => '导出中心';

  @override
  String get enterpriseAdminModuleExportSubtitle => '在权限允许时导出 Excel 快照';

  @override
  String get enterpriseAdminModuleAllowedHint => '当前角色可用';

  @override
  String get enterpriseAdminStatusAvailable => '可用';

  @override
  String get enterpriseAdminStatusLocked => '锁定';

  @override
  String get enterpriseAdminPermissionLineEmployees => '维护员工资料';

  @override
  String get enterpriseAdminPermissionLineDepartments => '维护部门设置';

  @override
  String get enterpriseAdminPermissionLinePositions => '维护岗位规划';

  @override
  String get enterpriseAdminPermissionLineAccounts => '配置账号权限';

  @override
  String get enterpriseAdminPermissionLineExport => '导出 Excel 快照';

  @override
  String get enterpriseAdminExportHeaderEmployeeNo => '工号';

  @override
  String get enterpriseAdminExportHeaderName => '姓名';

  @override
  String get enterpriseAdminExportHeaderDepartment => '部门';

  @override
  String get enterpriseAdminExportHeaderPosition => '岗位';

  @override
  String get enterpriseAdminExportHeaderPhone => '电话';

  @override
  String get enterpriseAdminExportHeaderEmail => '邮箱';

  @override
  String get enterpriseAdminExportHeaderStatus => '状态';

  @override
  String get enterpriseAdminExportHeaderLeader => '负责人';

  @override
  String get enterpriseAdminExportHeaderCount => '人数';

  @override
  String get enterpriseAdminExportHeaderDescription => '说明';

  @override
  String get enterpriseAdminExportHeaderLevel => '级别';

  @override
  String get enterpriseAdminExportHeaderDepartmentOwned => '所属部门';

  @override
  String get enterpriseAdminExportHeaderHeadcount => '编制人数';

  @override
  String get enterpriseAdminExportHeaderVacancy => '招聘缺口';

  @override
  String get enterpriseAdminMonthJan => '1月';

  @override
  String get enterpriseAdminMonthFeb => '2月';

  @override
  String get enterpriseAdminMonthMar => '3月';

  @override
  String get enterpriseAdminMonthApr => '4月';

  @override
  String get enterpriseAdminMonthMay => '5月';

  @override
  String get enterpriseAdminMonthJun => '6月';

  @override
  String get enterpriseAdminSessionUserFallback => '当前账号';

  @override
  String get enterpriseAdminRoleSuperAdmin => '超级管理员';

  @override
  String get enterpriseAdminRoleHrManager => 'HR 管理员';

  @override
  String get enterpriseAdminRoleDepartmentManager => '部门负责人';

  @override
  String get enterpriseAdminRoleViewer => '只读访客';

  @override
  String get themeToggleSwitchToDark => '切换到夜间模式';

  @override
  String get themeToggleSwitchToLight => '切换到白天模式';

  @override
  String get themeToggleLabelDark => '夜间';

  @override
  String get themeToggleLabelLight => '日间';
}
