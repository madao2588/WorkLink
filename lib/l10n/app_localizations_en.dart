// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginPleaseEnterAccountAndPassword =>
      'Please enter account and password';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get loginDemoAccount => 'Demo account: zhangsan / 123456';

  @override
  String get loginHeroBrand => 'WORKLINK';

  @override
  String get loginHeroTitle => 'Connected Team Workflow';

  @override
  String get loginHeroSubtitle =>
      'Sign in to sync messages, approvals, attendance, contacts, and your workspace dashboard.';

  @override
  String get loginTitleWelcomeBack => 'Welcome back';

  @override
  String get loginSubtitleDemoAccount =>
      'Use the backend demo account to enter the connected workspace.';

  @override
  String get loginLabelAccount => 'Account';

  @override
  String get loginLabelPassword => 'Password';

  @override
  String get loginConnecting => 'Connecting...';

  @override
  String get loginEnterWorkLink => 'Enter WorkLink';

  @override
  String contactsHeaderOnlineCount(int count) {
    return '$count online';
  }

  @override
  String get contactsTitle => 'Contacts';

  @override
  String get contactsSubtitle =>
      'Now powered by the backend directory service and kept in sync with online status.';

  @override
  String get contactsDirectoryTitle => 'Directory';

  @override
  String get contactsDirectorySubtitleDefault =>
      'Browse colleagues by department and online status';

  @override
  String get contactsDirectorySubtitleFiltered =>
      'Results are filtered by name and department';

  @override
  String get contactsSearchHint => 'Search people or departments';

  @override
  String get contactsOnlineNowTitle => 'Online now';

  @override
  String get contactsOnlineNowSubtitle =>
      'Good candidates for quick collaboration';

  @override
  String get contactsNoOnlineMatched =>
      'No online contacts matched the current search';

  @override
  String contactsPeopleCount(int count) {
    return '$count people';
  }

  @override
  String get contactsNoContactsMatched => 'No contacts matched your search';

  @override
  String get contactsTryAnotherKeyword =>
      'Try another keyword or clear the filter';

  @override
  String get contactsOnline => 'Online';

  @override
  String get contactsOffline => 'Offline';

  @override
  String get routerRecoveryFailedTitle => 'Page recovery failed';

  @override
  String get routerReturnToApp => 'Return to app';

  @override
  String get workplaceFallbackUserName => 'Colleague';

  @override
  String get workplaceDateFormat => 'MMMd';

  @override
  String workplaceHeroSubtitle(String dateLabel) {
    return '$dateLabel · Move one more important task forward today';
  }

  @override
  String get workplaceHeroStatCheckedIn => 'Checked in';

  @override
  String get workplaceHeroStatPendingCheckIn => 'Pending';

  @override
  String get workplaceHeroStatLate => 'Late';

  @override
  String get workplaceHeroStatMissing => 'Missing';

  @override
  String get workplaceSectionCommandTitle => 'Command desk';

  @override
  String get workplaceSectionCommandSubtitle =>
      'Start with the move that reduces the most friction in today\'s work';

  @override
  String get workplaceSectionOverviewTitle => 'Today\'s overview';

  @override
  String get workplaceSectionOverviewSubtitle =>
      'See the most important status in one place';

  @override
  String get workplaceSectionActionsTitle => 'Frequent actions';

  @override
  String get workplaceSectionActionsSubtitle =>
      'Keep the most common work actions close at hand';

  @override
  String get workplaceSectionFocusTitle => 'Needs attention';

  @override
  String get workplaceSectionFocusSubtitle =>
      'Start with the items that most affect today’s momentum';

  @override
  String get workplaceSectionPulseTitle => 'System pulse';

  @override
  String get workplaceSectionPulseSubtitle =>
      'Quickly verify whether the core modules are syncing normally';

  @override
  String get workplaceSectionUpdatesTitle => 'Updates and rhythm';

  @override
  String get workplaceSectionUpdatesSubtitle =>
      'Use announcements and recent activity to regain context after opening the app';

  @override
  String get workplaceSectionAnnouncementsTitle => 'Announcements';

  @override
  String get workplaceSectionAnnouncementsSubtitle =>
      'A few operational updates worth checking before work gets busy';

  @override
  String get workplaceSectionAnnouncementsTimelineTitle => 'Recent activity';

  @override
  String get workplaceSectionAnnouncementsTimelineSubtitle =>
      'Today\'s approvals, check-in, and conversations in one short timeline';

  @override
  String get workplaceCommandRecommendedLabel => 'Recommended next step';

  @override
  String get workplaceCommandQueueLabel => 'Current queue';

  @override
  String get workplaceCommandQueueSubtitle =>
      'A compact view of what still needs action across the three main work streams';

  @override
  String get workplaceMetricStatusLabel => 'Today\'s status';

  @override
  String get workplaceMetricStatusHintCheckedIn => 'Status synced';

  @override
  String get workplaceMetricStatusHintPending => 'Check-in pending';

  @override
  String get workplaceMetricCheckInLabel => 'Check-in time';

  @override
  String get workplaceMetricCheckInHintRecorded => 'Recorded';

  @override
  String get workplaceMetricCheckInHintNotYet => 'Not checked in yet';

  @override
  String get workplaceMetricPendingApprovalsLabel => 'Pending approvals';

  @override
  String get workplaceMetricPendingApprovalsHint => 'Flows that need follow-up';

  @override
  String get workplaceMetricUnreadMessagesLabel => 'Unread messages';

  @override
  String workplaceMetricUnreadMessagesHint(int count) {
    return '$count colleagues online · Prioritize unread items';
  }

  @override
  String get workplaceActionAttendanceTitle => 'Attendance';

  @override
  String get workplaceActionAttendanceSubtitle =>
      'Quickly record today\'s arrival status';

  @override
  String get workplaceActionApprovalTitle => 'Approvals';

  @override
  String get workplaceActionApprovalSubtitle =>
      'Review and handle pending requests';

  @override
  String get workplaceActionLogTitle => 'Work log';

  @override
  String get workplaceActionLogSubtitle =>
      'Capture progress and keep the team aligned';

  @override
  String get workplaceActionNoticeTitle => 'Announcements';

  @override
  String get workplaceActionNoticeSubtitle =>
      'Read team updates and policy changes';

  @override
  String get workplaceGreetingMorning => 'Good morning';

  @override
  String get workplaceGreetingAfternoon => 'Good afternoon';

  @override
  String get workplaceGreetingEvening => 'Good evening';

  @override
  String get workplaceNotCheckedInValue => 'Not checked in';

  @override
  String get workplaceActionEnterNow => 'Open now';

  @override
  String get workplaceSnackBarAlreadyCheckedIn =>
      'Today\'s check-in is already complete';

  @override
  String get workplaceSnackBarCheckInSuccess =>
      'Check-in succeeded and status was updated';

  @override
  String get workplaceSnackBarLogReady =>
      'Recent activity is already visible in the timeline below';

  @override
  String get workplaceSnackBarNoticeReady =>
      'Announcements are already available in the panel below';

  @override
  String get workplacePriorityAttendanceTitle => 'Today\'s attendance';

  @override
  String get workplacePriorityAttendancePendingSummary =>
      'Today\'s check-in has not been completed yet';

  @override
  String get workplacePriorityAttendancePendingDetail =>
      'It is better to finish check-in before moving on to other work';

  @override
  String get workplacePriorityAttendanceDoneSummary =>
      'Attendance has been recorded for today';

  @override
  String workplacePriorityAttendanceDoneDetail(String time) {
    return 'Checked in at $time';
  }

  @override
  String get workplacePriorityApprovalsTitle => 'Approval follow-up';

  @override
  String get workplacePriorityApprovalsNoneSummary =>
      'There are no approvals waiting right now';

  @override
  String get workplacePriorityApprovalsNoneDetail =>
      'You can move on to other work while the approval queue stays clear';

  @override
  String workplacePriorityApprovalsPendingSummary(int count) {
    return '$count approvals still need your action';
  }

  @override
  String workplacePriorityApprovalsPendingDetail(
    int approvedCount,
    int rejectedCount,
  ) {
    return '$approvedCount approved · $rejectedCount rejected';
  }

  @override
  String get workplacePriorityMessagesTitle => 'Message handling';

  @override
  String workplacePriorityMessagesUnreadSummary(int count) {
    return '$count conversations still have unread items';
  }

  @override
  String workplacePriorityMessagesUnreadDetail(int onlineCount) {
    return '$onlineCount colleagues are online and ready for quick collaboration';
  }

  @override
  String get workplacePriorityMessagesClearSummary =>
      'The message queue is under control';

  @override
  String workplacePriorityMessagesClearDetail(int onlineCount) {
    return '$onlineCount colleagues are online and there is no unread pressure right now';
  }

  @override
  String get workplacePriorityLevelCritical => 'Critical';

  @override
  String get workplacePriorityLevelHigh => 'High';

  @override
  String get workplacePriorityLevelSteady => 'Steady';

  @override
  String get workplacePulseAttendanceLabel => 'Attendance API';

  @override
  String get workplacePulseApprovalsLabel => 'Approval API';

  @override
  String get workplacePulseMessagesLabel => 'Message API';

  @override
  String get workplacePulseStateLoading => 'Syncing';

  @override
  String get workplacePulseStateHealthy => 'Ready';

  @override
  String get workplacePulseStateError => 'Error';

  @override
  String get workplacePulseDetailHealthy => 'Data is ready';

  @override
  String get workplacePulseDetailLoading => 'Fetching the latest status';

  @override
  String get workplaceAnnouncementTagPolicy => 'Policy';

  @override
  String get workplaceAnnouncementTagReminder => 'Reminder';

  @override
  String get workplaceAnnouncementTagCollaboration => 'Collaboration';

  @override
  String get workplaceAnnouncementApprovalPolicyTitle =>
      'Approval SLA reminder refreshed';

  @override
  String get workplaceAnnouncementApprovalPolicyDetail =>
      'Requests submitted before 18:00 should be reviewed on the same day whenever possible.';

  @override
  String get workplaceAnnouncementAttendanceTitle =>
      'Attendance exceptions are now highlighted first';

  @override
  String get workplaceAnnouncementAttendanceDetail =>
      'Late arrival and missing check-in states now stay visible on the workspace until handled.';

  @override
  String get workplaceAnnouncementCollaborationTitle =>
      'Unread conversations are prioritized in collaboration';

  @override
  String get workplaceAnnouncementCollaborationDetail =>
      'Keep urgent chats moving by reviewing unread threads before starting deep work.';

  @override
  String get workplaceAnnouncementAction => 'View from workspace';

  @override
  String get workplaceTimelineAttendanceDoneTitle => 'Attendance recorded';

  @override
  String workplaceTimelineAttendanceDoneDetail(String time) {
    return 'Checked in at $time';
  }

  @override
  String get workplaceTimelineAttendancePendingTitle =>
      'Attendance still needs action';

  @override
  String get workplaceTimelineAttendancePendingDetail =>
      'Today\'s check-in is still pending and should be completed first.';

  @override
  String workplaceTimelineApprovalTitle(String applicant) {
    return '$applicant submitted an approval';
  }

  @override
  String workplaceTimelineApprovalPendingDetail(String title) {
    return 'Waiting for follow-up: $title';
  }

  @override
  String workplaceTimelineApprovalApprovedDetail(String title) {
    return 'Approved and archived: $title';
  }

  @override
  String workplaceTimelineApprovalRejectedDetail(String title) {
    return 'Sent back for revision: $title';
  }

  @override
  String workplaceTimelineMessageTitle(String name) {
    return 'Conversation updated with $name';
  }

  @override
  String workplaceTimelineMessageUnreadDetail(String preview, int count) {
    return '$preview - $count unread';
  }

  @override
  String workplaceTimelineMessageReadDetail(String preview) {
    return '$preview';
  }

  @override
  String get workplaceTimelineTagAttendance => 'Attendance';

  @override
  String get workplaceTimelineTagAttention => 'Attention';

  @override
  String get workplaceTimelineTagPending => 'Pending';

  @override
  String get workplaceTimelineTagApproved => 'Approved';

  @override
  String get workplaceTimelineTagRejected => 'Rejected';

  @override
  String get workplaceTimelineTagUnread => 'Unread';

  @override
  String get workplaceTimelineTagUpdated => 'Updated';

  @override
  String get workplaceTimelineEmptyState =>
      'Recent approvals, check-ins, and messages will show up here once data syncs in.';

  @override
  String workplaceTimelineTimeToday(String time) {
    return 'Today $time';
  }

  @override
  String get profilePleaseRelogin => 'Please sign in again';

  @override
  String get profileOverviewLoadFailed => 'Failed to load profile data';

  @override
  String get profileMetricAttendanceLabel => 'Attendance';

  @override
  String get profileMetricAttendanceCaptionNotCheckedIn =>
      'Not checked in today';

  @override
  String get profileMetricPendingApprovalsLabel => 'Pending approvals';

  @override
  String get profileMetricPendingApprovalsCaption =>
      'Items that still need your follow-up';

  @override
  String get profileMetricMessagesLabel => 'Messages';

  @override
  String profileMetricMessagesCaption(int count) {
    return '$count unread';
  }

  @override
  String get profileSectionManagementTitle => 'Management';

  @override
  String get profileSectionManagementSubtitle =>
      'Expose admin tools only for roles that should actually see them';

  @override
  String get profileSectionWorkspaceTitle => 'Personal workspace';

  @override
  String get profileSectionWorkspaceSubtitle =>
      'Group common entries so they are easier to find';

  @override
  String get profileSectionPersonalTitle => 'Personal tasks';

  @override
  String get profileActionMyApprovalsTitle => 'My approvals';

  @override
  String get profileActionMyApprovalsSubtitle =>
      'Review requests and approval progress';

  @override
  String get profileActionSalarySlipsTitle => 'Salary slips';

  @override
  String get profileActionSalarySlipsSubtitle =>
      'Access payroll-related information';

  @override
  String get profileActionBadgesTitle => 'My badges';

  @override
  String get profileActionBadgesSubtitle => 'Track milestones and recognition';

  @override
  String get profileActionEnterpriseAdminTitle => 'Enterprise admin';

  @override
  String profileActionEnterpriseAdminSubtitle(String role) {
    return 'Current role: $role';
  }

  @override
  String get profileSectionSettingsTitle => 'System settings';

  @override
  String get profileActionAccountSecurityTitle => 'Account & security';

  @override
  String get profileActionAccountSecuritySubtitle =>
      'Devices, privacy, and security settings';

  @override
  String get profileActionGeneralSettingsTitle => 'General settings';

  @override
  String get profileActionGeneralSettingsSubtitle =>
      'Notifications, display, and preferences';

  @override
  String get profileActionHelpFeedbackTitle => 'Help & feedback';

  @override
  String get profileActionHelpFeedbackSubtitle => 'Report issues or get help';

  @override
  String get profileHeroOnline => 'Working online';

  @override
  String get profileHeroVerified => 'Verified account';

  @override
  String get profileHeroUnreadMessagesLabel => 'Unread messages';

  @override
  String get profileLogoutButton => 'Sign out';

  @override
  String profileActionComingSoon(String title) {
    return '$title is still being improved';
  }

  @override
  String get profileLogoutDialogTitle => 'Sign out';

  @override
  String get profileLogoutDialogContent =>
      'Are you sure you want to sign out of this account?';

  @override
  String get profileDialogCancel => 'Cancel';

  @override
  String get profileDialogConfirmLogout => 'Sign out';

  @override
  String get profileAttendanceCheckedIn => 'Checked in';

  @override
  String get profileAttendanceLate => 'Late';

  @override
  String get profileAttendancePending => 'Pending';

  @override
  String profileCheckInTimeLabel(String time) {
    return 'Check-in time $time';
  }

  @override
  String get profileReload => 'Reload';

  @override
  String get salarySlipsTitle => 'Salary slips';

  @override
  String get salarySlipsRecentTitle => 'Recent salary records';

  @override
  String get salarySlipsEmpty => 'No salary slips yet';

  @override
  String get salarySlipsSummaryWaiting =>
      'Waiting for the backend salary slip response';

  @override
  String salarySlipsSummaryLatest(String month) {
    return 'The latest period is $month, now synced from the backend salary API.';
  }

  @override
  String get salarySlipsSummaryCurrentNet => 'Net pay this month';

  @override
  String get salarySlipsNetPayLabel => 'Net pay';

  @override
  String get salarySlipsGrossPayLabel => 'Gross pay';

  @override
  String get salarySlipsIssuedAtLabel => 'Issued at';

  @override
  String get badgesTitle => 'My badges';

  @override
  String get badgesIntroEmpty =>
      'Badge data will be loaded from the backend profile API.';

  @override
  String badgesIntroCount(int count) {
    return '$count badges are currently synced, capturing your collaboration milestones.';
  }

  @override
  String get badgesEmpty => 'No badges yet';

  @override
  String get accountSecurityTitle => 'Account & security';

  @override
  String get accountSecurityIntroEmpty =>
      'Account security information will be loaded from the backend security API.';

  @override
  String get accountSecurityIntroLoaded =>
      'Binding methods, device information, and security policies are synced for centralized sign-in safety.';

  @override
  String get accountSecurityEmpty => 'No account security data yet';

  @override
  String get accountSecuritySectionAccountInfo => 'Account information';

  @override
  String get accountSecurityLabelMobile => 'Bound mobile';

  @override
  String get accountSecurityLabelEmail => 'Bound email';

  @override
  String get accountSecurityLabelPasswordUpdatedAt => 'Password updated';

  @override
  String get accountSecurityLabelMfa => 'Multi-factor authentication';

  @override
  String get accountSecurityMfaEnabled => 'Enabled';

  @override
  String get accountSecurityMfaDisabled => 'Disabled';

  @override
  String get accountSecuritySectionRecentDevices => 'Recent sign-in devices';

  @override
  String get accountSecurityCurrentDevice => 'Current device';

  @override
  String get generalSettingsTitle => 'General settings';

  @override
  String get generalSettingsEmpty => 'No settings data yet';

  @override
  String get generalSettingsSectionNotifications => 'Notification preferences';

  @override
  String get generalSettingsPushTitle => 'Push notifications';

  @override
  String get generalSettingsPushSubtitle =>
      'Get alerts for chats and approvals';

  @override
  String get generalSettingsSoundTitle => 'Sound alerts';

  @override
  String get generalSettingsSoundSubtitle =>
      'Allow audio feedback and system prompts';

  @override
  String get generalSettingsSectionDisplay => 'Display & preferences';

  @override
  String get generalSettingsLanguageTitle => 'Language';

  @override
  String get generalSettingsLanguageSubtitle => 'Choose the interface language';

  @override
  String get generalSettingsLanguageZhHans => 'Simplified Chinese';

  @override
  String get generalSettingsThemeTitle => 'Theme';

  @override
  String get generalSettingsThemeSubtitle =>
      'The backend has saved the current theme mode';

  @override
  String get generalSettingsThemeLight => 'Light';

  @override
  String get generalSettingsThemeDark => 'Dark';

  @override
  String get generalSettingsSectionOther => 'Other';

  @override
  String get generalSettingsCacheSizeTitle => 'Cache size';

  @override
  String get generalSettingsVersionTitle => 'Current version';

  @override
  String get generalSettingsVersionValue => 'WorkLink 1.0.0';

  @override
  String get helpFeedbackTitle => 'Help & feedback';

  @override
  String get helpFeedbackIntro =>
      'This page can now submit feedback to the backend for future ticketing, email routing, or admin workflows.';

  @override
  String get helpFeedbackFaqMessagesTitle => 'Why aren\'t messages refreshing?';

  @override
  String get helpFeedbackFaqMessagesAnswer =>
      'First confirm the local backend is running. Messages and profile data already rely on real APIs.';

  @override
  String get helpFeedbackFaqApprovalTitle =>
      'Where can I find submitted approvals?';

  @override
  String get helpFeedbackFaqApprovalAnswer =>
      'Open the approval center from My Approvals or the workplace entry to see the latest records.';

  @override
  String get helpFeedbackFaqLoginTitle => 'What should I do if sign-in fails?';

  @override
  String get helpFeedbackFaqLoginAnswer =>
      'Confirm the backend service is healthy, then verify the demo account zhangsan / 123456 is still available.';

  @override
  String get helpFeedbackSubmitSectionTitle => 'Submit feedback';

  @override
  String get helpFeedbackCategoryFeature => 'Feature idea';

  @override
  String get helpFeedbackCategoryUi => 'UI experience';

  @override
  String get helpFeedbackCategoryBug => 'Bug report';

  @override
  String get helpFeedbackInputHint =>
      'Describe your issue or suggestion. It will be saved through the backend feedback API after submission.';

  @override
  String get helpFeedbackSubmitting => 'Submitting...';

  @override
  String get helpFeedbackSubmitButton => 'Submit feedback';

  @override
  String get helpFeedbackEmptyContent => 'Please enter your feedback first';

  @override
  String get helpFeedbackSubmitSuccess =>
      'Feedback was submitted to the backend';

  @override
  String get approvalTitle => 'My approvals';

  @override
  String get approvalEmpty => 'No requests yet';

  @override
  String approvalReasonLabel(String reason) {
    return 'Reason: $reason';
  }

  @override
  String approvalSubmittedAtLabel(String time) {
    return 'Submitted at: $time';
  }

  @override
  String get approvalStatusPending => 'In review';

  @override
  String get approvalStatusApproved => 'Approved';

  @override
  String get approvalStatusRejected => 'Rejected';

  @override
  String get approvalDecisionTitle => 'Approval decision';

  @override
  String get approvalApproveAction => 'Approve request';

  @override
  String get approvalRejectAction => 'Reject request';

  @override
  String get approvalSubmitDialogTitle => 'Start request';

  @override
  String get approvalSubmitDialogHint =>
      'Enter the request reason (for example: sick leave)';

  @override
  String get approvalDialogCancel => 'Cancel';

  @override
  String get approvalDialogSubmit => 'Submit';

  @override
  String get enterpriseAdminPermissionEmployees =>
      'The current account cannot manage employee records';

  @override
  String get enterpriseAdminPermissionDepartments =>
      'The current account cannot manage departments';

  @override
  String get enterpriseAdminPermissionPositions =>
      'The current account cannot manage positions';

  @override
  String get enterpriseAdminPermissionAccounts =>
      'The current account cannot configure account permissions';

  @override
  String get enterpriseAdminPermissionExport =>
      'The current account cannot export Excel files';

  @override
  String get enterpriseAdminPermissionDashboard =>
      'The current account cannot view the dashboard';

  @override
  String get enterpriseAdminTitle => 'Enterprise admin';

  @override
  String get enterpriseAdminSubtitle =>
      'Use role-aware access to review organization data, headcount, and management capabilities.';

  @override
  String enterpriseAdminRoleChip(String role) {
    return 'Role: $role';
  }

  @override
  String enterpriseAdminSessionChip(String name) {
    return 'Session: $name';
  }

  @override
  String get enterpriseAdminFilterAll => 'All';

  @override
  String get enterpriseAdminDataSourceChipLive => 'Directory: live backend';

  @override
  String get enterpriseAdminDataSourceChipFallback =>
      'Directory: demo fallback';

  @override
  String get enterpriseAdminDataSourceChipLoading => 'Directory: syncing';

  @override
  String get enterpriseAdminSectionOverviewTitle => 'Overview';

  @override
  String get enterpriseAdminSectionOverviewSubtitle =>
      'A lightweight management snapshot to make the current scope visible';

  @override
  String get enterpriseAdminSectionModulesTitle => 'Modules';

  @override
  String get enterpriseAdminSectionModulesSubtitle =>
      'Each management domain now reflects the current role\'s reachable capability';

  @override
  String get enterpriseAdminSectionActionsTitle => 'Action center';

  @override
  String get enterpriseAdminSectionActionsSubtitle =>
      'Use the current permission set to sync data or export management snapshots';

  @override
  String get enterpriseAdminSectionPreviewTitle => 'Data preview';

  @override
  String get enterpriseAdminSectionPreviewSubtitle =>
      'Open lightweight read-only details for the management domains your current role can actually inspect';

  @override
  String get enterpriseAdminSectionPermissionsTitle => 'Permission summary';

  @override
  String get enterpriseAdminSectionPermissionsSubtitle =>
      'A quick list of what this account can and cannot manage right now';

  @override
  String get enterpriseAdminDataSourceLiveTitle =>
      'Enterprise admin data is synced from the backend';

  @override
  String get enterpriseAdminDataSourceLiveSubtitle =>
      'Employees, departments, positions, and account summaries now come from the backend overview API.';

  @override
  String get enterpriseAdminDataSourceLoadingTitle =>
      'Syncing organization data';

  @override
  String get enterpriseAdminDataSourceLoadingSubtitle =>
      'The enterprise admin page is fetching the latest employees, departments, positions, and accounts from the backend.';

  @override
  String get enterpriseAdminDataSourceFallbackTitle =>
      'Enterprise admin data is temporarily using demo data';

  @override
  String get enterpriseAdminDataSourceFallbackSubtitle =>
      'The backend overview API did not return successfully, so the page fell back to local sample data for now.';

  @override
  String get enterpriseAdminRetrySync => 'Retry sync';

  @override
  String get enterpriseAdminActionSyncNow => 'Sync now';

  @override
  String get enterpriseAdminActionChangeCenter => 'Change center';

  @override
  String get enterpriseAdminActionExportEmployees => 'Export employees';

  @override
  String get enterpriseAdminActionExportDepartments => 'Export departments';

  @override
  String get enterpriseAdminActionExportPositions => 'Export positions';

  @override
  String get enterpriseAdminActionExportReady =>
      'Export is available for this account. The saved file path will be shown after you pick a location.';

  @override
  String get enterpriseAdminActionExportUnavailable =>
      'This account does not have export permission yet, so export actions stay disabled.';

  @override
  String get enterpriseAdminExportCancelled => 'Export was cancelled.';

  @override
  String enterpriseAdminExportSuccess(String path) {
    return 'Export completed: $path';
  }

  @override
  String get enterpriseAdminSyncCompleted =>
      'Organization data has been synced successfully.';

  @override
  String get enterpriseAdminPreviewEmployeesTitle => 'Employee snapshot';

  @override
  String get enterpriseAdminPreviewEmployeesSubtitle =>
      'Read the latest employee records and open a lightweight detail sheet';

  @override
  String get enterpriseAdminPreviewEmployeesEmpty =>
      'No employee data is available yet.';

  @override
  String get enterpriseAdminPreviewDepartmentsTitle => 'Department snapshot';

  @override
  String get enterpriseAdminPreviewDepartmentsSubtitle =>
      'Review leaders, member counts, and department notes';

  @override
  String get enterpriseAdminPreviewDepartmentsEmpty =>
      'No department data is available yet.';

  @override
  String get enterpriseAdminPreviewOpenAll => 'View all';

  @override
  String get enterpriseAdminPreviewPositionsTitle => 'Position snapshot';

  @override
  String get enterpriseAdminPreviewPositionsSubtitle =>
      'Review levels, headcount, and open quota at a glance';

  @override
  String get enterpriseAdminPreviewPositionsEmpty =>
      'No position data is available yet.';

  @override
  String get enterpriseAdminPreviewAccountsTitle => 'Account snapshot';

  @override
  String get enterpriseAdminPreviewAccountsSubtitle =>
      'Review account identity, mapped role, and enablement status';

  @override
  String get enterpriseAdminPreviewAccountsEmpty =>
      'No account data is available yet.';

  @override
  String get enterpriseAdminPreviewAccountEnabled => 'Enabled';

  @override
  String get enterpriseAdminPreviewAccountDisabled => 'Disabled';

  @override
  String get enterpriseAdminEmployeesPageTitle => 'Employee list';

  @override
  String get enterpriseAdminEmployeesPageSubtitle =>
      'Move employee records into a dedicated read-only page so they are easier to scan and search continuously.';

  @override
  String get enterpriseAdminEmployeesSearchHint =>
      'Search by name, employee number, department, or position';

  @override
  String enterpriseAdminEmployeesPageSummary(Object count) {
    return '$count employees currently in scope';
  }

  @override
  String get enterpriseAdminEmployeesEmpty =>
      'No employee records match the current filter.';

  @override
  String get enterpriseAdminEmployeesStatsDepartments => 'Departments covered';

  @override
  String get enterpriseAdminEmployeesStatsPositions => 'Positions covered';

  @override
  String get enterpriseAdminDepartmentsPageTitle => 'Department list';

  @override
  String get enterpriseAdminDepartmentsPageSubtitle =>
      'Break out leaders, member size, and notes into a dedicated view for organization-level browsing.';

  @override
  String get enterpriseAdminDepartmentsSearchHint =>
      'Search by department name or leader';

  @override
  String enterpriseAdminDepartmentsPageSummary(Object count) {
    return '$count departments currently in scope';
  }

  @override
  String get enterpriseAdminDepartmentsEmpty =>
      'No department records match the current filter.';

  @override
  String enterpriseAdminDepartmentsMemberCount(Object count) {
    return '$count members';
  }

  @override
  String get enterpriseAdminDepartmentsStatsMembers => 'Total members';

  @override
  String get enterpriseAdminDepartmentsStatsLargest => 'Largest team';

  @override
  String get enterpriseAdminDepartmentsFilterLarge => '10+ members';

  @override
  String get enterpriseAdminDepartmentsFilterMedium => '5-9 members';

  @override
  String get enterpriseAdminDepartmentsFilterCompact => 'Under 5';

  @override
  String get enterpriseAdminPositionsPageTitle => 'Position list';

  @override
  String get enterpriseAdminPositionsPageSubtitle =>
      'Break out position level, headcount, and hiring gap into a dedicated read-only view for staffing reviews.';

  @override
  String get enterpriseAdminPositionsSearchHint =>
      'Search by position title, department, or level';

  @override
  String enterpriseAdminPositionsPageSummary(Object count) {
    return '$count positions currently in scope';
  }

  @override
  String get enterpriseAdminPositionsEmpty =>
      'No position records match the current filter.';

  @override
  String enterpriseAdminPositionsVacancy(Object count) {
    return '$count open';
  }

  @override
  String get enterpriseAdminPositionsStatsHeadcount => 'Headcount';

  @override
  String get enterpriseAdminPositionsStatsVacancy => 'Hiring gap';

  @override
  String get enterpriseAdminAccountsPageTitle => 'Account list';

  @override
  String get enterpriseAdminAccountsPageSubtitle =>
      'Collect visible system accounts into a dedicated read-only page so login ID, role, and enablement are easier to verify.';

  @override
  String get enterpriseAdminAccountsSearchHint =>
      'Search by account name or login ID';

  @override
  String enterpriseAdminAccountsPageSummary(Object count) {
    return '$count accounts currently in scope';
  }

  @override
  String get enterpriseAdminAccountsEmpty =>
      'No account records match the current filter.';

  @override
  String get enterpriseAdminAccountsStatsEnabled => 'Enabled';

  @override
  String get enterpriseAdminAccountsStatsDisabled => 'Disabled';

  @override
  String get enterpriseAdminChangeRequestsPageTitle => 'Change center';

  @override
  String get enterpriseAdminChangeRequestsPageSubtitle =>
      'Review direct edits and submitted drafts in one place so recent management changes are easier to follow.';

  @override
  String enterpriseAdminChangeRequestsPageSummary(Object count) {
    return '$count change requests currently in scope';
  }

  @override
  String get enterpriseAdminChangeRequestsMetricTotal => 'Total requests';

  @override
  String get enterpriseAdminChangeRequestsMetricApplied => 'Applied';

  @override
  String get enterpriseAdminChangeRequestsMetricDrafted => 'Drafted';

  @override
  String get enterpriseAdminChangeRequestsSearchHint =>
      'Search by request number, object, note, or requester';

  @override
  String get enterpriseAdminChangeRequestsEmpty =>
      'No change requests match the current filter.';

  @override
  String get enterpriseAdminChangeRequestsStatusApplied => 'Applied';

  @override
  String get enterpriseAdminChangeRequestsStatusDrafted => 'Drafted';

  @override
  String get enterpriseAdminChangeRequestsStatusRejected => 'Rejected';

  @override
  String get enterpriseAdminChangeRequestsEntityEmployee => 'Employee';

  @override
  String get enterpriseAdminChangeRequestsEntityDepartment => 'Department';

  @override
  String get enterpriseAdminChangeRequestsEntityPosition => 'Position';

  @override
  String get enterpriseAdminChangeRequestsEntityAccount => 'Account';

  @override
  String get enterpriseAdminChangeRequestsOpenRecord => 'Open related record';

  @override
  String get enterpriseAdminChangeRequestsRequester => 'Requester';

  @override
  String get enterpriseAdminChangeRequestsSubmittedAt => 'Submitted at';

  @override
  String get enterpriseAdminChangeRequestDetailTitle => 'Change request detail';

  @override
  String enterpriseAdminChangeRequestDetailSubtitle(Object entityType) {
    return 'Review the saved snapshot and context for this $entityType change.';
  }

  @override
  String get enterpriseAdminChangeRequestDetailLoadFailed =>
      'Failed to load this change request detail.';

  @override
  String get enterpriseAdminChangeRequestDetailStatus => 'Status';

  @override
  String get enterpriseAdminChangeRequestDetailNoteTitle => 'Change note';

  @override
  String get enterpriseAdminChangeRequestDetailObjectLabel => 'Target object';

  @override
  String get enterpriseAdminChangeRequestDetailSnapshotTitle =>
      'Saved snapshot';

  @override
  String get enterpriseAdminChangeRequestDetailSnapshotSubtitle =>
      'These are the fields captured when the draft or direct edit was submitted.';

  @override
  String get enterpriseAdminChangeRequestDetailSnapshotEmpty =>
      'No field snapshot is available for this request.';

  @override
  String get enterpriseAdminChangeRequestDetailCompareTitle =>
      'Field comparison';

  @override
  String get enterpriseAdminChangeRequestDetailCompareSubtitle =>
      'Compare the submitted snapshot with the current live record to spot drift quickly.';

  @override
  String get enterpriseAdminChangeRequestDetailCompareEmpty =>
      'No comparable fields are available for this request.';

  @override
  String get enterpriseAdminChangeRequestDetailCompareSnapshot =>
      'Snapshot value';

  @override
  String get enterpriseAdminChangeRequestDetailCompareCurrent =>
      'Current value';

  @override
  String get enterpriseAdminChangeRequestDetailCompareSame => 'Same';

  @override
  String get enterpriseAdminChangeRequestDetailCompareDifferent => 'Different';

  @override
  String get enterpriseAdminChangeRequestDetailCompareUnavailable =>
      'Unavailable';

  @override
  String get enterpriseAdminChangeRequestApprove => 'Approve change';

  @override
  String get enterpriseAdminChangeRequestReject => 'Reject change';

  @override
  String get enterpriseAdminChangeRequestProcessing => 'Processing...';

  @override
  String get enterpriseAdminChangeRequestApproveSuccess =>
      'The change request was approved.';

  @override
  String get enterpriseAdminChangeRequestRejectSuccess =>
      'The change request was rejected.';

  @override
  String get enterpriseAdminChangeRequestReviewUnavailable =>
      'The current account cannot review this change request.';

  @override
  String get enterpriseAdminDetailPanelSubtitle =>
      'This is a read-only detail view for quickly verifying records and organization context.';

  @override
  String get enterpriseAdminDetailPanelHint =>
      'Edit flows, approval hooks, and audit trails can land here later once the real management actions are wired in.';

  @override
  String get enterpriseAdminDetailActionEdit => 'Edit placeholder';

  @override
  String get enterpriseAdminDetailActionDirectEdit => 'Edit employee';

  @override
  String get enterpriseAdminDetailActionRequestChange => 'Request change';

  @override
  String get enterpriseAdminDetailActionAudit => 'Change log';

  @override
  String get enterpriseAdminDetailActionClose => 'Close';

  @override
  String get enterpriseAdminEditActionCollapse => 'Collapse edit';

  @override
  String get enterpriseAdminEditPanelTitle => 'Direct edit';

  @override
  String get enterpriseAdminEditPanelHint =>
      'Update the employee record here and save it directly to the backend. The list and detail view will refresh immediately after the request succeeds.';

  @override
  String get enterpriseAdminEditEmployeeTitle => 'Edit employee profile';

  @override
  String get enterpriseAdminEditEmployeeHint =>
      'This panel writes employee profile fields directly to the backend. Use it for fast corrections to department, position, email, and phone.';

  @override
  String get enterpriseAdminEditDepartmentTitle => 'Edit department profile';

  @override
  String get enterpriseAdminEditDepartmentHint =>
      'This panel writes department profile fields directly to the backend view. The department card, employee labels, and position ownership will refresh after save.';

  @override
  String get enterpriseAdminEditPositionTitle => 'Edit position profile';

  @override
  String get enterpriseAdminEditPositionHint =>
      'This panel writes position title, level, and hiring gap directly to the backend staffing view. Employee labels and position summaries will refresh after save.';

  @override
  String get enterpriseAdminEditAccountTitle => 'Edit account access';

  @override
  String get enterpriseAdminEditAccountHint =>
      'This panel writes account role and enabled state to the backend access layer. Login, session restore, and permission checks will use the updated values.';

  @override
  String get enterpriseAdminEditSubmit => 'Save changes';

  @override
  String get enterpriseAdminEditSaving => 'Saving...';

  @override
  String get enterpriseAdminEditSaveSuccess => 'Changes were saved.';

  @override
  String get enterpriseAdminEditEmpty =>
      'Please complete all editable fields first.';

  @override
  String get enterpriseAdminDraftActionCollapse => 'Collapse draft';

  @override
  String get enterpriseAdminDraftPanelTitle => 'Request change';

  @override
  String get enterpriseAdminDraftPanelHint =>
      'This step generates a local change draft first so the intended update is easy to review; later it can submit to real write APIs or approval flows.';

  @override
  String get enterpriseAdminDraftCurrentSnapshot => 'Current field snapshot';

  @override
  String get enterpriseAdminDraftInputHint =>
      'Describe the requested change, for example: change the department owner to Wang Wu because of a rotation.';

  @override
  String get enterpriseAdminDraftSubmit => 'Create change draft';

  @override
  String get enterpriseAdminDraftSubmitting => 'Submitting...';

  @override
  String get enterpriseAdminDraftSubmitSuccess =>
      'The change draft was created and added to the local timeline.';

  @override
  String enterpriseAdminDraftSubmitSuccessWithRequest(Object requestNo) {
    return 'The change draft was submitted. Request No.: $requestNo';
  }

  @override
  String get enterpriseAdminDraftEmpty => 'Please enter change notes first.';

  @override
  String get enterpriseAdminDraftTypeProfile => 'Profile fix';

  @override
  String get enterpriseAdminDraftTypeOrg => 'Org adjustment';

  @override
  String get enterpriseAdminDraftTypeStatus => 'Status change';

  @override
  String enterpriseAdminDraftTimelineTitle(Object type) {
    return '$type draft created';
  }

  @override
  String enterpriseAdminDraftTimelineDetail(Object note) {
    return 'Draft notes: $note';
  }

  @override
  String enterpriseAdminDraftTimelineDetailWithRequest(
    Object note,
    Object requestNo,
  ) {
    return 'Draft notes: $note. Request No.: $requestNo';
  }

  @override
  String get enterpriseAdminDetailActionCopy => 'Copy field';

  @override
  String get enterpriseAdminDetailActionOpenRelated => 'Open related record';

  @override
  String enterpriseAdminDetailCopySuccess(Object label) {
    return 'Copied: $label';
  }

  @override
  String get enterpriseAdminTimelineTitle => 'Change timeline';

  @override
  String get enterpriseAdminTimelineHint =>
      'This is a read-only audit trail for quickly checking recent syncs, status changes, and important organization updates.';

  @override
  String get enterpriseAdminTimelineEmpty =>
      'No change history is available yet.';

  @override
  String get enterpriseAdminTimelineRecent => 'Just now';

  @override
  String get enterpriseAdminTimelineToday => 'Today';

  @override
  String get enterpriseAdminTimelineEarlier => 'Earlier';

  @override
  String get enterpriseAdminTimelineEmployeeStatus => 'Employee status updated';

  @override
  String enterpriseAdminTimelineEmployeeStatusDetail(Object status) {
    return 'The current employee status has been synced as $status.';
  }

  @override
  String get enterpriseAdminTimelineEmployeeSync => 'Organization info synced';

  @override
  String enterpriseAdminTimelineEmployeeSyncDetail(
    Object department,
    Object position,
  ) {
    return 'The employee is currently in $department as $position.';
  }

  @override
  String get enterpriseAdminTimelineEmployeeUpdated =>
      'Employee profile updated';

  @override
  String enterpriseAdminTimelineEmployeeUpdatedDetail(
    Object department,
    Object position,
    Object phone,
    Object email,
  ) {
    return 'Updated to $department / $position, phone $phone, email $email.';
  }

  @override
  String get enterpriseAdminTimelineEmployeeCreated =>
      'Employee record created';

  @override
  String enterpriseAdminTimelineEmployeeCreatedDetail(Object employeeNo) {
    return 'A base record has been created for employee number $employeeNo.';
  }

  @override
  String get enterpriseAdminTimelineDepartmentLeader => 'Leader confirmed';

  @override
  String enterpriseAdminTimelineDepartmentLeaderDetail(Object leader) {
    return 'The current department leader is $leader.';
  }

  @override
  String get enterpriseAdminTimelineDepartmentSize => 'Team size refreshed';

  @override
  String enterpriseAdminTimelineDepartmentSizeDetail(Object count) {
    return 'The department member count is now $count.';
  }

  @override
  String get enterpriseAdminTimelineDepartmentUpdated =>
      'Department profile updated';

  @override
  String enterpriseAdminTimelineDepartmentUpdatedDetail(
    Object name,
    Object leader,
  ) {
    return 'Updated $name, leader $leader.';
  }

  @override
  String get enterpriseAdminTimelineDepartmentCreated =>
      'Department profile created';

  @override
  String enterpriseAdminTimelineDepartmentCreatedDetail(Object name) {
    return 'Base organization data has been created for $name.';
  }

  @override
  String get enterpriseAdminTimelinePositionVacancy => 'Hiring gap synced';

  @override
  String enterpriseAdminTimelinePositionVacancyDetail(Object count) {
    return 'The current hiring gap is $count positions.';
  }

  @override
  String get enterpriseAdminTimelinePositionHeadcount => 'Headcount updated';

  @override
  String enterpriseAdminTimelinePositionHeadcountDetail(Object count) {
    return 'The approved headcount is now $count.';
  }

  @override
  String get enterpriseAdminTimelinePositionCreated => 'Position plan created';

  @override
  String enterpriseAdminTimelinePositionCreatedDetail(Object department) {
    return 'This position plan has been attached to $department.';
  }

  @override
  String get enterpriseAdminTimelinePositionUpdated =>
      'Position profile updated';

  @override
  String enterpriseAdminTimelinePositionUpdatedDetail(
    Object title,
    Object level,
    Object openQuota,
  ) {
    return 'Updated to $title / $level with $openQuota open roles.';
  }

  @override
  String get enterpriseAdminTimelineAccountStatus => 'Account status updated';

  @override
  String enterpriseAdminTimelineAccountStatusDetail(Object status) {
    return 'The current account status is $status.';
  }

  @override
  String get enterpriseAdminTimelineAccountRole => 'Role mapping refreshed';

  @override
  String enterpriseAdminTimelineAccountRoleDetail(Object role) {
    return 'The current account role is $role.';
  }

  @override
  String get enterpriseAdminTimelineAccountUpdated => 'Account access updated';

  @override
  String enterpriseAdminTimelineAccountUpdatedDetail(
    Object role,
    Object status,
  ) {
    return 'Updated to role $role with status $status.';
  }

  @override
  String get enterpriseAdminTimelineAccountCreated => 'Account record created';

  @override
  String enterpriseAdminTimelineAccountCreatedDetail(Object loginId) {
    return 'The login ID $loginId has been added to the directory.';
  }

  @override
  String get enterpriseAdminDetailEmployeeNo => 'Employee No.';

  @override
  String get enterpriseAdminDetailDepartment => 'Department';

  @override
  String get enterpriseAdminDetailPosition => 'Position';

  @override
  String get enterpriseAdminDetailEmail => 'Email';

  @override
  String get enterpriseAdminDetailPhone => 'Phone';

  @override
  String get enterpriseAdminDetailStatus => 'Status';

  @override
  String get enterpriseAdminDetailLeader => 'Leader';

  @override
  String get enterpriseAdminDetailMemberCount => 'Members';

  @override
  String get enterpriseAdminDetailDescription => 'Description';

  @override
  String get enterpriseAdminDetailLevel => 'Level';

  @override
  String get enterpriseAdminDetailHeadcount => 'Headcount';

  @override
  String get enterpriseAdminDetailVacancy => 'Vacancy';

  @override
  String get enterpriseAdminDetailLoginId => 'Login ID';

  @override
  String get enterpriseAdminDetailRole => 'Role';

  @override
  String get enterpriseAdminMetricEmployees => 'Employees';

  @override
  String get enterpriseAdminMetricDepartments => 'Departments';

  @override
  String get enterpriseAdminMetricPositions => 'Positions';

  @override
  String get enterpriseAdminMetricAccounts => 'Enabled accounts';

  @override
  String get enterpriseAdminModuleEmployeesTitle => 'Employee records';

  @override
  String get enterpriseAdminModuleEmployeesSubtitle =>
      'Review employee profiles, statuses, and organizational placement';

  @override
  String get enterpriseAdminModuleDepartmentsTitle => 'Department setup';

  @override
  String get enterpriseAdminModuleDepartmentsSubtitle =>
      'Maintain structure, owners, and staffing boundaries';

  @override
  String get enterpriseAdminModulePositionsTitle => 'Position planning';

  @override
  String get enterpriseAdminModulePositionsSubtitle =>
      'Track levels, quotas, and open headcount';

  @override
  String get enterpriseAdminModuleAccountsTitle => 'Account control';

  @override
  String get enterpriseAdminModuleAccountsSubtitle =>
      'Configure admin roles and account enablement';

  @override
  String get enterpriseAdminModuleExportTitle => 'Export center';

  @override
  String get enterpriseAdminModuleExportSubtitle =>
      'Download Excel snapshots when the role allows it';

  @override
  String get enterpriseAdminModuleAllowedHint =>
      'Available for the current role';

  @override
  String get enterpriseAdminStatusAvailable => 'Available';

  @override
  String get enterpriseAdminStatusLocked => 'Locked';

  @override
  String get enterpriseAdminPermissionLineEmployees =>
      'Maintain employee records';

  @override
  String get enterpriseAdminPermissionLineDepartments => 'Maintain departments';

  @override
  String get enterpriseAdminPermissionLinePositions => 'Maintain positions';

  @override
  String get enterpriseAdminPermissionLineAccounts =>
      'Configure account permissions';

  @override
  String get enterpriseAdminPermissionLineExport => 'Export Excel snapshots';

  @override
  String get enterpriseAdminExportHeaderEmployeeNo => 'Employee No.';

  @override
  String get enterpriseAdminExportHeaderName => 'Name';

  @override
  String get enterpriseAdminExportHeaderDepartment => 'Department';

  @override
  String get enterpriseAdminExportHeaderPosition => 'Position';

  @override
  String get enterpriseAdminExportHeaderPhone => 'Phone';

  @override
  String get enterpriseAdminExportHeaderEmail => 'Email';

  @override
  String get enterpriseAdminExportHeaderStatus => 'Status';

  @override
  String get enterpriseAdminExportHeaderLeader => 'Leader';

  @override
  String get enterpriseAdminExportHeaderCount => 'Count';

  @override
  String get enterpriseAdminExportHeaderDescription => 'Description';

  @override
  String get enterpriseAdminExportHeaderLevel => 'Level';

  @override
  String get enterpriseAdminExportHeaderDepartmentOwned => 'Department';

  @override
  String get enterpriseAdminExportHeaderHeadcount => 'Headcount';

  @override
  String get enterpriseAdminExportHeaderVacancy => 'Vacancy';

  @override
  String get enterpriseAdminMonthJan => 'Jan';

  @override
  String get enterpriseAdminMonthFeb => 'Feb';

  @override
  String get enterpriseAdminMonthMar => 'Mar';

  @override
  String get enterpriseAdminMonthApr => 'Apr';

  @override
  String get enterpriseAdminMonthMay => 'May';

  @override
  String get enterpriseAdminMonthJun => 'Jun';

  @override
  String get enterpriseAdminSessionUserFallback => 'Current account';

  @override
  String get enterpriseAdminRoleSuperAdmin => 'Super admin';

  @override
  String get enterpriseAdminRoleHrManager => 'HR admin';

  @override
  String get enterpriseAdminRoleDepartmentManager => 'Department manager';

  @override
  String get enterpriseAdminRoleViewer => 'Read-only viewer';

  @override
  String get themeToggleSwitchToDark => 'Switch to dark mode';

  @override
  String get themeToggleSwitchToLight => 'Switch to light mode';

  @override
  String get themeToggleLabelDark => 'Dark';

  @override
  String get themeToggleLabelLight => 'Light';
}
