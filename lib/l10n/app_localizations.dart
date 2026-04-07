import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @loginPleaseEnterAccountAndPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter account and password'**
  String get loginPleaseEnterAccountAndPassword;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @loginDemoAccount.
  ///
  /// In en, this message translates to:
  /// **'Demo account: zhangsan / 123456'**
  String get loginDemoAccount;

  /// No description provided for @loginHeroBrand.
  ///
  /// In en, this message translates to:
  /// **'WORKLINK'**
  String get loginHeroBrand;

  /// No description provided for @loginHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Connected Team Workflow'**
  String get loginHeroTitle;

  /// No description provided for @loginHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync messages, approvals, attendance, contacts, and your workspace dashboard.'**
  String get loginHeroSubtitle;

  /// No description provided for @loginTitleWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginTitleWelcomeBack;

  /// No description provided for @loginSubtitleDemoAccount.
  ///
  /// In en, this message translates to:
  /// **'Use the backend demo account to enter the connected workspace.'**
  String get loginSubtitleDemoAccount;

  /// No description provided for @loginLabelAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get loginLabelAccount;

  /// No description provided for @loginLabelPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginLabelPassword;

  /// No description provided for @loginConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get loginConnecting;

  /// No description provided for @loginEnterWorkLink.
  ///
  /// In en, this message translates to:
  /// **'Enter WorkLink'**
  String get loginEnterWorkLink;

  /// No description provided for @contactsHeaderOnlineCount.
  ///
  /// In en, this message translates to:
  /// **'{count} online'**
  String contactsHeaderOnlineCount(int count);

  /// No description provided for @contactsTitle.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contactsTitle;

  /// No description provided for @contactsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Now powered by the backend directory service and kept in sync with online status.'**
  String get contactsSubtitle;

  /// No description provided for @contactsDirectoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Directory'**
  String get contactsDirectoryTitle;

  /// No description provided for @contactsDirectorySubtitleDefault.
  ///
  /// In en, this message translates to:
  /// **'Browse colleagues by department and online status'**
  String get contactsDirectorySubtitleDefault;

  /// No description provided for @contactsDirectorySubtitleFiltered.
  ///
  /// In en, this message translates to:
  /// **'Results are filtered by name and department'**
  String get contactsDirectorySubtitleFiltered;

  /// No description provided for @contactsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search people or departments'**
  String get contactsSearchHint;

  /// No description provided for @contactsOnlineNowTitle.
  ///
  /// In en, this message translates to:
  /// **'Online now'**
  String get contactsOnlineNowTitle;

  /// No description provided for @contactsOnlineNowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Good candidates for quick collaboration'**
  String get contactsOnlineNowSubtitle;

  /// No description provided for @contactsNoOnlineMatched.
  ///
  /// In en, this message translates to:
  /// **'No online contacts matched the current search'**
  String get contactsNoOnlineMatched;

  /// No description provided for @contactsPeopleCount.
  ///
  /// In en, this message translates to:
  /// **'{count} people'**
  String contactsPeopleCount(int count);

  /// No description provided for @contactsNoContactsMatched.
  ///
  /// In en, this message translates to:
  /// **'No contacts matched your search'**
  String get contactsNoContactsMatched;

  /// No description provided for @contactsTryAnotherKeyword.
  ///
  /// In en, this message translates to:
  /// **'Try another keyword or clear the filter'**
  String get contactsTryAnotherKeyword;

  /// No description provided for @contactsOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get contactsOnline;

  /// No description provided for @contactsOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get contactsOffline;

  /// No description provided for @routerRecoveryFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Page recovery failed'**
  String get routerRecoveryFailedTitle;

  /// No description provided for @routerReturnToApp.
  ///
  /// In en, this message translates to:
  /// **'Return to app'**
  String get routerReturnToApp;

  /// No description provided for @workplaceFallbackUserName.
  ///
  /// In en, this message translates to:
  /// **'Colleague'**
  String get workplaceFallbackUserName;

  /// No description provided for @workplaceDateFormat.
  ///
  /// In en, this message translates to:
  /// **'MMMd'**
  String get workplaceDateFormat;

  /// No description provided for @workplaceHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{dateLabel} · Move one more important task forward today'**
  String workplaceHeroSubtitle(String dateLabel);

  /// No description provided for @workplaceHeroStatCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked in'**
  String get workplaceHeroStatCheckedIn;

  /// No description provided for @workplaceHeroStatPendingCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get workplaceHeroStatPendingCheckIn;

  /// No description provided for @workplaceHeroStatLate.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get workplaceHeroStatLate;

  /// No description provided for @workplaceHeroStatMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get workplaceHeroStatMissing;

  /// No description provided for @workplaceSectionCommandTitle.
  ///
  /// In en, this message translates to:
  /// **'Command desk'**
  String get workplaceSectionCommandTitle;

  /// No description provided for @workplaceSectionCommandSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start with the move that reduces the most friction in today\'s work'**
  String get workplaceSectionCommandSubtitle;

  /// No description provided for @workplaceSectionOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s overview'**
  String get workplaceSectionOverviewTitle;

  /// No description provided for @workplaceSectionOverviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See the most important status in one place'**
  String get workplaceSectionOverviewSubtitle;

  /// No description provided for @workplaceSectionActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequent actions'**
  String get workplaceSectionActionsTitle;

  /// No description provided for @workplaceSectionActionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep the most common work actions close at hand'**
  String get workplaceSectionActionsSubtitle;

  /// No description provided for @workplaceSectionFocusTitle.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get workplaceSectionFocusTitle;

  /// No description provided for @workplaceSectionFocusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start with the items that most affect today’s momentum'**
  String get workplaceSectionFocusSubtitle;

  /// No description provided for @workplaceSectionPulseTitle.
  ///
  /// In en, this message translates to:
  /// **'System pulse'**
  String get workplaceSectionPulseTitle;

  /// No description provided for @workplaceSectionPulseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quickly verify whether the core modules are syncing normally'**
  String get workplaceSectionPulseSubtitle;

  /// No description provided for @workplaceSectionUpdatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Updates and rhythm'**
  String get workplaceSectionUpdatesTitle;

  /// No description provided for @workplaceSectionUpdatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use announcements and recent activity to regain context after opening the app'**
  String get workplaceSectionUpdatesSubtitle;

  /// No description provided for @workplaceSectionAnnouncementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get workplaceSectionAnnouncementsTitle;

  /// No description provided for @workplaceSectionAnnouncementsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A few operational updates worth checking before work gets busy'**
  String get workplaceSectionAnnouncementsSubtitle;

  /// No description provided for @workplaceSectionAnnouncementsTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get workplaceSectionAnnouncementsTimelineTitle;

  /// No description provided for @workplaceSectionAnnouncementsTimelineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s approvals, check-in, and conversations in one short timeline'**
  String get workplaceSectionAnnouncementsTimelineSubtitle;

  /// No description provided for @workplaceCommandRecommendedLabel.
  ///
  /// In en, this message translates to:
  /// **'Recommended next step'**
  String get workplaceCommandRecommendedLabel;

  /// No description provided for @workplaceCommandQueueLabel.
  ///
  /// In en, this message translates to:
  /// **'Current queue'**
  String get workplaceCommandQueueLabel;

  /// No description provided for @workplaceCommandQueueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A compact view of what still needs action across the three main work streams'**
  String get workplaceCommandQueueSubtitle;

  /// No description provided for @workplaceMetricStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Today\'s status'**
  String get workplaceMetricStatusLabel;

  /// No description provided for @workplaceMetricStatusHintCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Status synced'**
  String get workplaceMetricStatusHintCheckedIn;

  /// No description provided for @workplaceMetricStatusHintPending.
  ///
  /// In en, this message translates to:
  /// **'Check-in pending'**
  String get workplaceMetricStatusHintPending;

  /// No description provided for @workplaceMetricCheckInLabel.
  ///
  /// In en, this message translates to:
  /// **'Check-in time'**
  String get workplaceMetricCheckInLabel;

  /// No description provided for @workplaceMetricCheckInHintRecorded.
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get workplaceMetricCheckInHintRecorded;

  /// No description provided for @workplaceMetricCheckInHintNotYet.
  ///
  /// In en, this message translates to:
  /// **'Not checked in yet'**
  String get workplaceMetricCheckInHintNotYet;

  /// No description provided for @workplaceMetricPendingApprovalsLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending approvals'**
  String get workplaceMetricPendingApprovalsLabel;

  /// No description provided for @workplaceMetricPendingApprovalsHint.
  ///
  /// In en, this message translates to:
  /// **'Flows that need follow-up'**
  String get workplaceMetricPendingApprovalsHint;

  /// No description provided for @workplaceMetricUnreadMessagesLabel.
  ///
  /// In en, this message translates to:
  /// **'Unread messages'**
  String get workplaceMetricUnreadMessagesLabel;

  /// No description provided for @workplaceMetricUnreadMessagesHint.
  ///
  /// In en, this message translates to:
  /// **'{count} colleagues online · Prioritize unread items'**
  String workplaceMetricUnreadMessagesHint(int count);

  /// No description provided for @workplaceActionAttendanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get workplaceActionAttendanceTitle;

  /// No description provided for @workplaceActionAttendanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quickly record today\'s arrival status'**
  String get workplaceActionAttendanceSubtitle;

  /// No description provided for @workplaceActionApprovalTitle.
  ///
  /// In en, this message translates to:
  /// **'Approvals'**
  String get workplaceActionApprovalTitle;

  /// No description provided for @workplaceActionApprovalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review and handle pending requests'**
  String get workplaceActionApprovalSubtitle;

  /// No description provided for @workplaceActionLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Work log'**
  String get workplaceActionLogTitle;

  /// No description provided for @workplaceActionLogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Capture progress and keep the team aligned'**
  String get workplaceActionLogSubtitle;

  /// No description provided for @workplaceActionNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get workplaceActionNoticeTitle;

  /// No description provided for @workplaceActionNoticeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read team updates and policy changes'**
  String get workplaceActionNoticeSubtitle;

  /// No description provided for @workplaceGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get workplaceGreetingMorning;

  /// No description provided for @workplaceGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get workplaceGreetingAfternoon;

  /// No description provided for @workplaceGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get workplaceGreetingEvening;

  /// No description provided for @workplaceNotCheckedInValue.
  ///
  /// In en, this message translates to:
  /// **'Not checked in'**
  String get workplaceNotCheckedInValue;

  /// No description provided for @workplaceActionEnterNow.
  ///
  /// In en, this message translates to:
  /// **'Open now'**
  String get workplaceActionEnterNow;

  /// No description provided for @workplaceSnackBarAlreadyCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Today\'s check-in is already complete'**
  String get workplaceSnackBarAlreadyCheckedIn;

  /// No description provided for @workplaceSnackBarCheckInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Check-in succeeded and status was updated'**
  String get workplaceSnackBarCheckInSuccess;

  /// No description provided for @workplaceSnackBarLogReady.
  ///
  /// In en, this message translates to:
  /// **'Recent activity is already visible in the timeline below'**
  String get workplaceSnackBarLogReady;

  /// No description provided for @workplaceSnackBarNoticeReady.
  ///
  /// In en, this message translates to:
  /// **'Announcements are already available in the panel below'**
  String get workplaceSnackBarNoticeReady;

  /// No description provided for @workplacePriorityAttendanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s attendance'**
  String get workplacePriorityAttendanceTitle;

  /// No description provided for @workplacePriorityAttendancePendingSummary.
  ///
  /// In en, this message translates to:
  /// **'Today\'s check-in has not been completed yet'**
  String get workplacePriorityAttendancePendingSummary;

  /// No description provided for @workplacePriorityAttendancePendingDetail.
  ///
  /// In en, this message translates to:
  /// **'It is better to finish check-in before moving on to other work'**
  String get workplacePriorityAttendancePendingDetail;

  /// No description provided for @workplacePriorityAttendanceDoneSummary.
  ///
  /// In en, this message translates to:
  /// **'Attendance has been recorded for today'**
  String get workplacePriorityAttendanceDoneSummary;

  /// No description provided for @workplacePriorityAttendanceDoneDetail.
  ///
  /// In en, this message translates to:
  /// **'Checked in at {time}'**
  String workplacePriorityAttendanceDoneDetail(String time);

  /// No description provided for @workplacePriorityApprovalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Approval follow-up'**
  String get workplacePriorityApprovalsTitle;

  /// No description provided for @workplacePriorityApprovalsNoneSummary.
  ///
  /// In en, this message translates to:
  /// **'There are no approvals waiting right now'**
  String get workplacePriorityApprovalsNoneSummary;

  /// No description provided for @workplacePriorityApprovalsNoneDetail.
  ///
  /// In en, this message translates to:
  /// **'You can move on to other work while the approval queue stays clear'**
  String get workplacePriorityApprovalsNoneDetail;

  /// No description provided for @workplacePriorityApprovalsPendingSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} approvals still need your action'**
  String workplacePriorityApprovalsPendingSummary(int count);

  /// No description provided for @workplacePriorityApprovalsPendingDetail.
  ///
  /// In en, this message translates to:
  /// **'{approvedCount} approved · {rejectedCount} rejected'**
  String workplacePriorityApprovalsPendingDetail(
    int approvedCount,
    int rejectedCount,
  );

  /// No description provided for @workplacePriorityMessagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Message handling'**
  String get workplacePriorityMessagesTitle;

  /// No description provided for @workplacePriorityMessagesUnreadSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} conversations still have unread items'**
  String workplacePriorityMessagesUnreadSummary(int count);

  /// No description provided for @workplacePriorityMessagesUnreadDetail.
  ///
  /// In en, this message translates to:
  /// **'{onlineCount} colleagues are online and ready for quick collaboration'**
  String workplacePriorityMessagesUnreadDetail(int onlineCount);

  /// No description provided for @workplacePriorityMessagesClearSummary.
  ///
  /// In en, this message translates to:
  /// **'The message queue is under control'**
  String get workplacePriorityMessagesClearSummary;

  /// No description provided for @workplacePriorityMessagesClearDetail.
  ///
  /// In en, this message translates to:
  /// **'{onlineCount} colleagues are online and there is no unread pressure right now'**
  String workplacePriorityMessagesClearDetail(int onlineCount);

  /// No description provided for @workplacePriorityLevelCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get workplacePriorityLevelCritical;

  /// No description provided for @workplacePriorityLevelHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get workplacePriorityLevelHigh;

  /// No description provided for @workplacePriorityLevelSteady.
  ///
  /// In en, this message translates to:
  /// **'Steady'**
  String get workplacePriorityLevelSteady;

  /// No description provided for @workplacePulseAttendanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Attendance API'**
  String get workplacePulseAttendanceLabel;

  /// No description provided for @workplacePulseApprovalsLabel.
  ///
  /// In en, this message translates to:
  /// **'Approval API'**
  String get workplacePulseApprovalsLabel;

  /// No description provided for @workplacePulseMessagesLabel.
  ///
  /// In en, this message translates to:
  /// **'Message API'**
  String get workplacePulseMessagesLabel;

  /// No description provided for @workplacePulseStateLoading.
  ///
  /// In en, this message translates to:
  /// **'Syncing'**
  String get workplacePulseStateLoading;

  /// No description provided for @workplacePulseStateHealthy.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get workplacePulseStateHealthy;

  /// No description provided for @workplacePulseStateError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get workplacePulseStateError;

  /// No description provided for @workplacePulseDetailHealthy.
  ///
  /// In en, this message translates to:
  /// **'Data is ready'**
  String get workplacePulseDetailHealthy;

  /// No description provided for @workplacePulseDetailLoading.
  ///
  /// In en, this message translates to:
  /// **'Fetching the latest status'**
  String get workplacePulseDetailLoading;

  /// No description provided for @workplaceAnnouncementTagPolicy.
  ///
  /// In en, this message translates to:
  /// **'Policy'**
  String get workplaceAnnouncementTagPolicy;

  /// No description provided for @workplaceAnnouncementTagReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get workplaceAnnouncementTagReminder;

  /// No description provided for @workplaceAnnouncementTagCollaboration.
  ///
  /// In en, this message translates to:
  /// **'Collaboration'**
  String get workplaceAnnouncementTagCollaboration;

  /// No description provided for @workplaceAnnouncementApprovalPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Approval SLA reminder refreshed'**
  String get workplaceAnnouncementApprovalPolicyTitle;

  /// No description provided for @workplaceAnnouncementApprovalPolicyDetail.
  ///
  /// In en, this message translates to:
  /// **'Requests submitted before 18:00 should be reviewed on the same day whenever possible.'**
  String get workplaceAnnouncementApprovalPolicyDetail;

  /// No description provided for @workplaceAnnouncementAttendanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Attendance exceptions are now highlighted first'**
  String get workplaceAnnouncementAttendanceTitle;

  /// No description provided for @workplaceAnnouncementAttendanceDetail.
  ///
  /// In en, this message translates to:
  /// **'Late arrival and missing check-in states now stay visible on the workspace until handled.'**
  String get workplaceAnnouncementAttendanceDetail;

  /// No description provided for @workplaceAnnouncementCollaborationTitle.
  ///
  /// In en, this message translates to:
  /// **'Unread conversations are prioritized in collaboration'**
  String get workplaceAnnouncementCollaborationTitle;

  /// No description provided for @workplaceAnnouncementCollaborationDetail.
  ///
  /// In en, this message translates to:
  /// **'Keep urgent chats moving by reviewing unread threads before starting deep work.'**
  String get workplaceAnnouncementCollaborationDetail;

  /// No description provided for @workplaceAnnouncementAction.
  ///
  /// In en, this message translates to:
  /// **'View from workspace'**
  String get workplaceAnnouncementAction;

  /// No description provided for @workplaceTimelineAttendanceDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Attendance recorded'**
  String get workplaceTimelineAttendanceDoneTitle;

  /// No description provided for @workplaceTimelineAttendanceDoneDetail.
  ///
  /// In en, this message translates to:
  /// **'Checked in at {time}'**
  String workplaceTimelineAttendanceDoneDetail(String time);

  /// No description provided for @workplaceTimelineAttendancePendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Attendance still needs action'**
  String get workplaceTimelineAttendancePendingTitle;

  /// No description provided for @workplaceTimelineAttendancePendingDetail.
  ///
  /// In en, this message translates to:
  /// **'Today\'s check-in is still pending and should be completed first.'**
  String get workplaceTimelineAttendancePendingDetail;

  /// No description provided for @workplaceTimelineApprovalTitle.
  ///
  /// In en, this message translates to:
  /// **'{applicant} submitted an approval'**
  String workplaceTimelineApprovalTitle(String applicant);

  /// No description provided for @workplaceTimelineApprovalPendingDetail.
  ///
  /// In en, this message translates to:
  /// **'Waiting for follow-up: {title}'**
  String workplaceTimelineApprovalPendingDetail(String title);

  /// No description provided for @workplaceTimelineApprovalApprovedDetail.
  ///
  /// In en, this message translates to:
  /// **'Approved and archived: {title}'**
  String workplaceTimelineApprovalApprovedDetail(String title);

  /// No description provided for @workplaceTimelineApprovalRejectedDetail.
  ///
  /// In en, this message translates to:
  /// **'Sent back for revision: {title}'**
  String workplaceTimelineApprovalRejectedDetail(String title);

  /// No description provided for @workplaceTimelineMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'Conversation updated with {name}'**
  String workplaceTimelineMessageTitle(String name);

  /// No description provided for @workplaceTimelineMessageUnreadDetail.
  ///
  /// In en, this message translates to:
  /// **'{preview} - {count} unread'**
  String workplaceTimelineMessageUnreadDetail(String preview, int count);

  /// No description provided for @workplaceTimelineMessageReadDetail.
  ///
  /// In en, this message translates to:
  /// **'{preview}'**
  String workplaceTimelineMessageReadDetail(String preview);

  /// No description provided for @workplaceTimelineTagAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get workplaceTimelineTagAttendance;

  /// No description provided for @workplaceTimelineTagAttention.
  ///
  /// In en, this message translates to:
  /// **'Attention'**
  String get workplaceTimelineTagAttention;

  /// No description provided for @workplaceTimelineTagPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get workplaceTimelineTagPending;

  /// No description provided for @workplaceTimelineTagApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get workplaceTimelineTagApproved;

  /// No description provided for @workplaceTimelineTagRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get workplaceTimelineTagRejected;

  /// No description provided for @workplaceTimelineTagUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get workplaceTimelineTagUnread;

  /// No description provided for @workplaceTimelineTagUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get workplaceTimelineTagUpdated;

  /// No description provided for @workplaceTimelineEmptyState.
  ///
  /// In en, this message translates to:
  /// **'Recent approvals, check-ins, and messages will show up here once data syncs in.'**
  String get workplaceTimelineEmptyState;

  /// No description provided for @workplaceTimelineTimeToday.
  ///
  /// In en, this message translates to:
  /// **'Today {time}'**
  String workplaceTimelineTimeToday(String time);

  /// No description provided for @profilePleaseRelogin.
  ///
  /// In en, this message translates to:
  /// **'Please sign in again'**
  String get profilePleaseRelogin;

  /// No description provided for @profileOverviewLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile data'**
  String get profileOverviewLoadFailed;

  /// No description provided for @profileMetricAttendanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get profileMetricAttendanceLabel;

  /// No description provided for @profileMetricAttendanceCaptionNotCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Not checked in today'**
  String get profileMetricAttendanceCaptionNotCheckedIn;

  /// No description provided for @profileMetricPendingApprovalsLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending approvals'**
  String get profileMetricPendingApprovalsLabel;

  /// No description provided for @profileMetricPendingApprovalsCaption.
  ///
  /// In en, this message translates to:
  /// **'Items that still need your follow-up'**
  String get profileMetricPendingApprovalsCaption;

  /// No description provided for @profileMetricMessagesLabel.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get profileMetricMessagesLabel;

  /// No description provided for @profileMetricMessagesCaption.
  ///
  /// In en, this message translates to:
  /// **'{count} unread'**
  String profileMetricMessagesCaption(int count);

  /// No description provided for @profileSectionManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get profileSectionManagementTitle;

  /// No description provided for @profileSectionManagementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Expose admin tools only for roles that should actually see them'**
  String get profileSectionManagementSubtitle;

  /// No description provided for @profileSectionWorkspaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal workspace'**
  String get profileSectionWorkspaceTitle;

  /// No description provided for @profileSectionWorkspaceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Group common entries so they are easier to find'**
  String get profileSectionWorkspaceSubtitle;

  /// No description provided for @profileSectionPersonalTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal tasks'**
  String get profileSectionPersonalTitle;

  /// No description provided for @profileActionMyApprovalsTitle.
  ///
  /// In en, this message translates to:
  /// **'My approvals'**
  String get profileActionMyApprovalsTitle;

  /// No description provided for @profileActionMyApprovalsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review requests and approval progress'**
  String get profileActionMyApprovalsSubtitle;

  /// No description provided for @profileActionSalarySlipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Salary slips'**
  String get profileActionSalarySlipsTitle;

  /// No description provided for @profileActionSalarySlipsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Access payroll-related information'**
  String get profileActionSalarySlipsSubtitle;

  /// No description provided for @profileActionBadgesTitle.
  ///
  /// In en, this message translates to:
  /// **'My badges'**
  String get profileActionBadgesTitle;

  /// No description provided for @profileActionBadgesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track milestones and recognition'**
  String get profileActionBadgesSubtitle;

  /// No description provided for @profileActionEnterpriseAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'Enterprise admin'**
  String get profileActionEnterpriseAdminTitle;

  /// No description provided for @profileActionEnterpriseAdminSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Current role: {role}'**
  String profileActionEnterpriseAdminSubtitle(String role);

  /// No description provided for @profileSectionSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'System settings'**
  String get profileSectionSettingsTitle;

  /// No description provided for @profileActionAccountSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Account & security'**
  String get profileActionAccountSecurityTitle;

  /// No description provided for @profileActionAccountSecuritySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Devices, privacy, and security settings'**
  String get profileActionAccountSecuritySubtitle;

  /// No description provided for @profileActionGeneralSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'General settings'**
  String get profileActionGeneralSettingsTitle;

  /// No description provided for @profileActionGeneralSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications, display, and preferences'**
  String get profileActionGeneralSettingsSubtitle;

  /// No description provided for @profileActionHelpFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & feedback'**
  String get profileActionHelpFeedbackTitle;

  /// No description provided for @profileActionHelpFeedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Report issues or get help'**
  String get profileActionHelpFeedbackSubtitle;

  /// No description provided for @profileHeroOnline.
  ///
  /// In en, this message translates to:
  /// **'Working online'**
  String get profileHeroOnline;

  /// No description provided for @profileHeroVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified account'**
  String get profileHeroVerified;

  /// No description provided for @profileHeroUnreadMessagesLabel.
  ///
  /// In en, this message translates to:
  /// **'Unread messages'**
  String get profileHeroUnreadMessagesLabel;

  /// No description provided for @profileLogoutButton.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileLogoutButton;

  /// No description provided for @profileActionComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{title} is still being improved'**
  String profileActionComingSoon(String title);

  /// No description provided for @profileLogoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileLogoutDialogTitle;

  /// No description provided for @profileLogoutDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out of this account?'**
  String get profileLogoutDialogContent;

  /// No description provided for @profileDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileDialogCancel;

  /// No description provided for @profileDialogConfirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileDialogConfirmLogout;

  /// No description provided for @profileAttendanceCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked in'**
  String get profileAttendanceCheckedIn;

  /// No description provided for @profileAttendanceLate.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get profileAttendanceLate;

  /// No description provided for @profileAttendancePending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get profileAttendancePending;

  /// No description provided for @profileCheckInTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Check-in time {time}'**
  String profileCheckInTimeLabel(String time);

  /// No description provided for @profileReload.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get profileReload;

  /// No description provided for @salarySlipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Salary slips'**
  String get salarySlipsTitle;

  /// No description provided for @salarySlipsRecentTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent salary records'**
  String get salarySlipsRecentTitle;

  /// No description provided for @salarySlipsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No salary slips yet'**
  String get salarySlipsEmpty;

  /// No description provided for @salarySlipsSummaryWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the backend salary slip response'**
  String get salarySlipsSummaryWaiting;

  /// No description provided for @salarySlipsSummaryLatest.
  ///
  /// In en, this message translates to:
  /// **'The latest period is {month}, now synced from the backend salary API.'**
  String salarySlipsSummaryLatest(String month);

  /// No description provided for @salarySlipsSummaryCurrentNet.
  ///
  /// In en, this message translates to:
  /// **'Net pay this month'**
  String get salarySlipsSummaryCurrentNet;

  /// No description provided for @salarySlipsNetPayLabel.
  ///
  /// In en, this message translates to:
  /// **'Net pay'**
  String get salarySlipsNetPayLabel;

  /// No description provided for @salarySlipsGrossPayLabel.
  ///
  /// In en, this message translates to:
  /// **'Gross pay'**
  String get salarySlipsGrossPayLabel;

  /// No description provided for @salarySlipsIssuedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Issued at'**
  String get salarySlipsIssuedAtLabel;

  /// No description provided for @badgesTitle.
  ///
  /// In en, this message translates to:
  /// **'My badges'**
  String get badgesTitle;

  /// No description provided for @badgesIntroEmpty.
  ///
  /// In en, this message translates to:
  /// **'Badge data will be loaded from the backend profile API.'**
  String get badgesIntroEmpty;

  /// No description provided for @badgesIntroCount.
  ///
  /// In en, this message translates to:
  /// **'{count} badges are currently synced, capturing your collaboration milestones.'**
  String badgesIntroCount(int count);

  /// No description provided for @badgesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No badges yet'**
  String get badgesEmpty;

  /// No description provided for @accountSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Account & security'**
  String get accountSecurityTitle;

  /// No description provided for @accountSecurityIntroEmpty.
  ///
  /// In en, this message translates to:
  /// **'Account security information will be loaded from the backend security API.'**
  String get accountSecurityIntroEmpty;

  /// No description provided for @accountSecurityIntroLoaded.
  ///
  /// In en, this message translates to:
  /// **'Binding methods, device information, and security policies are synced for centralized sign-in safety.'**
  String get accountSecurityIntroLoaded;

  /// No description provided for @accountSecurityEmpty.
  ///
  /// In en, this message translates to:
  /// **'No account security data yet'**
  String get accountSecurityEmpty;

  /// No description provided for @accountSecuritySectionAccountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account information'**
  String get accountSecuritySectionAccountInfo;

  /// No description provided for @accountSecurityLabelMobile.
  ///
  /// In en, this message translates to:
  /// **'Bound mobile'**
  String get accountSecurityLabelMobile;

  /// No description provided for @accountSecurityLabelEmail.
  ///
  /// In en, this message translates to:
  /// **'Bound email'**
  String get accountSecurityLabelEmail;

  /// No description provided for @accountSecurityLabelPasswordUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get accountSecurityLabelPasswordUpdatedAt;

  /// No description provided for @accountSecurityLabelMfa.
  ///
  /// In en, this message translates to:
  /// **'Multi-factor authentication'**
  String get accountSecurityLabelMfa;

  /// No description provided for @accountSecurityMfaEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get accountSecurityMfaEnabled;

  /// No description provided for @accountSecurityMfaDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get accountSecurityMfaDisabled;

  /// No description provided for @accountSecuritySectionRecentDevices.
  ///
  /// In en, this message translates to:
  /// **'Recent sign-in devices'**
  String get accountSecuritySectionRecentDevices;

  /// No description provided for @accountSecurityCurrentDevice.
  ///
  /// In en, this message translates to:
  /// **'Current device'**
  String get accountSecurityCurrentDevice;

  /// No description provided for @generalSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'General settings'**
  String get generalSettingsTitle;

  /// No description provided for @generalSettingsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No settings data yet'**
  String get generalSettingsEmpty;

  /// No description provided for @generalSettingsSectionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences'**
  String get generalSettingsSectionNotifications;

  /// No description provided for @generalSettingsPushTitle.
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get generalSettingsPushTitle;

  /// No description provided for @generalSettingsPushSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get alerts for chats and approvals'**
  String get generalSettingsPushSubtitle;

  /// No description provided for @generalSettingsSoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Sound alerts'**
  String get generalSettingsSoundTitle;

  /// No description provided for @generalSettingsSoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow audio feedback and system prompts'**
  String get generalSettingsSoundSubtitle;

  /// No description provided for @generalSettingsSectionDisplay.
  ///
  /// In en, this message translates to:
  /// **'Display & preferences'**
  String get generalSettingsSectionDisplay;

  /// No description provided for @generalSettingsLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get generalSettingsLanguageTitle;

  /// No description provided for @generalSettingsLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the interface language'**
  String get generalSettingsLanguageSubtitle;

  /// No description provided for @generalSettingsLanguageZhHans.
  ///
  /// In en, this message translates to:
  /// **'Simplified Chinese'**
  String get generalSettingsLanguageZhHans;

  /// No description provided for @generalSettingsThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get generalSettingsThemeTitle;

  /// No description provided for @generalSettingsThemeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The backend has saved the current theme mode'**
  String get generalSettingsThemeSubtitle;

  /// No description provided for @generalSettingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get generalSettingsThemeLight;

  /// No description provided for @generalSettingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get generalSettingsThemeDark;

  /// No description provided for @generalSettingsSectionOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get generalSettingsSectionOther;

  /// No description provided for @generalSettingsCacheSizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Cache size'**
  String get generalSettingsCacheSizeTitle;

  /// No description provided for @generalSettingsVersionTitle.
  ///
  /// In en, this message translates to:
  /// **'Current version'**
  String get generalSettingsVersionTitle;

  /// No description provided for @generalSettingsVersionValue.
  ///
  /// In en, this message translates to:
  /// **'WorkLink 1.0.0'**
  String get generalSettingsVersionValue;

  /// No description provided for @helpFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & feedback'**
  String get helpFeedbackTitle;

  /// No description provided for @helpFeedbackIntro.
  ///
  /// In en, this message translates to:
  /// **'This page can now submit feedback to the backend for future ticketing, email routing, or admin workflows.'**
  String get helpFeedbackIntro;

  /// No description provided for @helpFeedbackFaqMessagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Why aren\'t messages refreshing?'**
  String get helpFeedbackFaqMessagesTitle;

  /// No description provided for @helpFeedbackFaqMessagesAnswer.
  ///
  /// In en, this message translates to:
  /// **'First confirm the local backend is running. Messages and profile data already rely on real APIs.'**
  String get helpFeedbackFaqMessagesAnswer;

  /// No description provided for @helpFeedbackFaqApprovalTitle.
  ///
  /// In en, this message translates to:
  /// **'Where can I find submitted approvals?'**
  String get helpFeedbackFaqApprovalTitle;

  /// No description provided for @helpFeedbackFaqApprovalAnswer.
  ///
  /// In en, this message translates to:
  /// **'Open the approval center from My Approvals or the workplace entry to see the latest records.'**
  String get helpFeedbackFaqApprovalAnswer;

  /// No description provided for @helpFeedbackFaqLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'What should I do if sign-in fails?'**
  String get helpFeedbackFaqLoginTitle;

  /// No description provided for @helpFeedbackFaqLoginAnswer.
  ///
  /// In en, this message translates to:
  /// **'Confirm the backend service is healthy, then verify the demo account zhangsan / 123456 is still available.'**
  String get helpFeedbackFaqLoginAnswer;

  /// No description provided for @helpFeedbackSubmitSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Submit feedback'**
  String get helpFeedbackSubmitSectionTitle;

  /// No description provided for @helpFeedbackCategoryFeature.
  ///
  /// In en, this message translates to:
  /// **'Feature idea'**
  String get helpFeedbackCategoryFeature;

  /// No description provided for @helpFeedbackCategoryUi.
  ///
  /// In en, this message translates to:
  /// **'UI experience'**
  String get helpFeedbackCategoryUi;

  /// No description provided for @helpFeedbackCategoryBug.
  ///
  /// In en, this message translates to:
  /// **'Bug report'**
  String get helpFeedbackCategoryBug;

  /// No description provided for @helpFeedbackInputHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your issue or suggestion. It will be saved through the backend feedback API after submission.'**
  String get helpFeedbackInputHint;

  /// No description provided for @helpFeedbackSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get helpFeedbackSubmitting;

  /// No description provided for @helpFeedbackSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit feedback'**
  String get helpFeedbackSubmitButton;

  /// No description provided for @helpFeedbackEmptyContent.
  ///
  /// In en, this message translates to:
  /// **'Please enter your feedback first'**
  String get helpFeedbackEmptyContent;

  /// No description provided for @helpFeedbackSubmitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Feedback was submitted to the backend'**
  String get helpFeedbackSubmitSuccess;

  /// No description provided for @approvalTitle.
  ///
  /// In en, this message translates to:
  /// **'My approvals'**
  String get approvalTitle;

  /// No description provided for @approvalEmpty.
  ///
  /// In en, this message translates to:
  /// **'No requests yet'**
  String get approvalEmpty;

  /// No description provided for @approvalReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason: {reason}'**
  String approvalReasonLabel(String reason);

  /// No description provided for @approvalSubmittedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Submitted at: {time}'**
  String approvalSubmittedAtLabel(String time);

  /// No description provided for @approvalStatusPending.
  ///
  /// In en, this message translates to:
  /// **'In review'**
  String get approvalStatusPending;

  /// No description provided for @approvalStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approvalStatusApproved;

  /// No description provided for @approvalStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get approvalStatusRejected;

  /// No description provided for @approvalDecisionTitle.
  ///
  /// In en, this message translates to:
  /// **'Approval decision'**
  String get approvalDecisionTitle;

  /// No description provided for @approvalApproveAction.
  ///
  /// In en, this message translates to:
  /// **'Approve request'**
  String get approvalApproveAction;

  /// No description provided for @approvalRejectAction.
  ///
  /// In en, this message translates to:
  /// **'Reject request'**
  String get approvalRejectAction;

  /// No description provided for @approvalSubmitDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Start request'**
  String get approvalSubmitDialogTitle;

  /// No description provided for @approvalSubmitDialogHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the request reason (for example: sick leave)'**
  String get approvalSubmitDialogHint;

  /// No description provided for @approvalDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get approvalDialogCancel;

  /// No description provided for @approvalDialogSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get approvalDialogSubmit;

  /// No description provided for @enterpriseAdminPermissionEmployees.
  ///
  /// In en, this message translates to:
  /// **'The current account cannot manage employee records'**
  String get enterpriseAdminPermissionEmployees;

  /// No description provided for @enterpriseAdminPermissionDepartments.
  ///
  /// In en, this message translates to:
  /// **'The current account cannot manage departments'**
  String get enterpriseAdminPermissionDepartments;

  /// No description provided for @enterpriseAdminPermissionPositions.
  ///
  /// In en, this message translates to:
  /// **'The current account cannot manage positions'**
  String get enterpriseAdminPermissionPositions;

  /// No description provided for @enterpriseAdminPermissionAccounts.
  ///
  /// In en, this message translates to:
  /// **'The current account cannot configure account permissions'**
  String get enterpriseAdminPermissionAccounts;

  /// No description provided for @enterpriseAdminPermissionExport.
  ///
  /// In en, this message translates to:
  /// **'The current account cannot export Excel files'**
  String get enterpriseAdminPermissionExport;

  /// No description provided for @enterpriseAdminPermissionDashboard.
  ///
  /// In en, this message translates to:
  /// **'The current account cannot view the dashboard'**
  String get enterpriseAdminPermissionDashboard;

  /// No description provided for @enterpriseAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'Enterprise admin'**
  String get enterpriseAdminTitle;

  /// No description provided for @enterpriseAdminSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use role-aware access to review organization data, headcount, and management capabilities.'**
  String get enterpriseAdminSubtitle;

  /// No description provided for @enterpriseAdminRoleChip.
  ///
  /// In en, this message translates to:
  /// **'Role: {role}'**
  String enterpriseAdminRoleChip(String role);

  /// No description provided for @enterpriseAdminSessionChip.
  ///
  /// In en, this message translates to:
  /// **'Session: {name}'**
  String enterpriseAdminSessionChip(String name);

  /// No description provided for @enterpriseAdminFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get enterpriseAdminFilterAll;

  /// No description provided for @enterpriseAdminDataSourceChipLive.
  ///
  /// In en, this message translates to:
  /// **'Directory: live backend'**
  String get enterpriseAdminDataSourceChipLive;

  /// No description provided for @enterpriseAdminDataSourceChipFallback.
  ///
  /// In en, this message translates to:
  /// **'Directory: demo fallback'**
  String get enterpriseAdminDataSourceChipFallback;

  /// No description provided for @enterpriseAdminDataSourceChipLoading.
  ///
  /// In en, this message translates to:
  /// **'Directory: syncing'**
  String get enterpriseAdminDataSourceChipLoading;

  /// No description provided for @enterpriseAdminSectionOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get enterpriseAdminSectionOverviewTitle;

  /// No description provided for @enterpriseAdminSectionOverviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A lightweight management snapshot to make the current scope visible'**
  String get enterpriseAdminSectionOverviewSubtitle;

  /// No description provided for @enterpriseAdminSectionModulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get enterpriseAdminSectionModulesTitle;

  /// No description provided for @enterpriseAdminSectionModulesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Each management domain now reflects the current role\'s reachable capability'**
  String get enterpriseAdminSectionModulesSubtitle;

  /// No description provided for @enterpriseAdminSectionActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Action center'**
  String get enterpriseAdminSectionActionsTitle;

  /// No description provided for @enterpriseAdminSectionActionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use the current permission set to sync data or export management snapshots'**
  String get enterpriseAdminSectionActionsSubtitle;

  /// No description provided for @enterpriseAdminSectionPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Data preview'**
  String get enterpriseAdminSectionPreviewTitle;

  /// No description provided for @enterpriseAdminSectionPreviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open lightweight read-only details for the management domains your current role can actually inspect'**
  String get enterpriseAdminSectionPreviewSubtitle;

  /// No description provided for @enterpriseAdminSectionPermissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission summary'**
  String get enterpriseAdminSectionPermissionsTitle;

  /// No description provided for @enterpriseAdminSectionPermissionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A quick list of what this account can and cannot manage right now'**
  String get enterpriseAdminSectionPermissionsSubtitle;

  /// No description provided for @enterpriseAdminDataSourceLiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Enterprise admin data is synced from the backend'**
  String get enterpriseAdminDataSourceLiveTitle;

  /// No description provided for @enterpriseAdminDataSourceLiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Employees, departments, positions, and account summaries now come from the backend overview API.'**
  String get enterpriseAdminDataSourceLiveSubtitle;

  /// No description provided for @enterpriseAdminDataSourceLoadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Syncing organization data'**
  String get enterpriseAdminDataSourceLoadingTitle;

  /// No description provided for @enterpriseAdminDataSourceLoadingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The enterprise admin page is fetching the latest employees, departments, positions, and accounts from the backend.'**
  String get enterpriseAdminDataSourceLoadingSubtitle;

  /// No description provided for @enterpriseAdminDataSourceFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Enterprise admin data is temporarily using demo data'**
  String get enterpriseAdminDataSourceFallbackTitle;

  /// No description provided for @enterpriseAdminDataSourceFallbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The backend overview API did not return successfully, so the page fell back to local sample data for now.'**
  String get enterpriseAdminDataSourceFallbackSubtitle;

  /// No description provided for @enterpriseAdminRetrySync.
  ///
  /// In en, this message translates to:
  /// **'Retry sync'**
  String get enterpriseAdminRetrySync;

  /// No description provided for @enterpriseAdminActionSyncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get enterpriseAdminActionSyncNow;

  /// No description provided for @enterpriseAdminActionChangeCenter.
  ///
  /// In en, this message translates to:
  /// **'Change center'**
  String get enterpriseAdminActionChangeCenter;

  /// No description provided for @enterpriseAdminActionExportEmployees.
  ///
  /// In en, this message translates to:
  /// **'Export employees'**
  String get enterpriseAdminActionExportEmployees;

  /// No description provided for @enterpriseAdminActionExportDepartments.
  ///
  /// In en, this message translates to:
  /// **'Export departments'**
  String get enterpriseAdminActionExportDepartments;

  /// No description provided for @enterpriseAdminActionExportPositions.
  ///
  /// In en, this message translates to:
  /// **'Export positions'**
  String get enterpriseAdminActionExportPositions;

  /// No description provided for @enterpriseAdminActionExportReady.
  ///
  /// In en, this message translates to:
  /// **'Export is available for this account. The saved file path will be shown after you pick a location.'**
  String get enterpriseAdminActionExportReady;

  /// No description provided for @enterpriseAdminActionExportUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This account does not have export permission yet, so export actions stay disabled.'**
  String get enterpriseAdminActionExportUnavailable;

  /// No description provided for @enterpriseAdminExportCancelled.
  ///
  /// In en, this message translates to:
  /// **'Export was cancelled.'**
  String get enterpriseAdminExportCancelled;

  /// No description provided for @enterpriseAdminExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export completed: {path}'**
  String enterpriseAdminExportSuccess(String path);

  /// No description provided for @enterpriseAdminSyncCompleted.
  ///
  /// In en, this message translates to:
  /// **'Organization data has been synced successfully.'**
  String get enterpriseAdminSyncCompleted;

  /// No description provided for @enterpriseAdminPreviewEmployeesTitle.
  ///
  /// In en, this message translates to:
  /// **'Employee snapshot'**
  String get enterpriseAdminPreviewEmployeesTitle;

  /// No description provided for @enterpriseAdminPreviewEmployeesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read the latest employee records and open a lightweight detail sheet'**
  String get enterpriseAdminPreviewEmployeesSubtitle;

  /// No description provided for @enterpriseAdminPreviewEmployeesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No employee data is available yet.'**
  String get enterpriseAdminPreviewEmployeesEmpty;

  /// No description provided for @enterpriseAdminPreviewDepartmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Department snapshot'**
  String get enterpriseAdminPreviewDepartmentsTitle;

  /// No description provided for @enterpriseAdminPreviewDepartmentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review leaders, member counts, and department notes'**
  String get enterpriseAdminPreviewDepartmentsSubtitle;

  /// No description provided for @enterpriseAdminPreviewDepartmentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No department data is available yet.'**
  String get enterpriseAdminPreviewDepartmentsEmpty;

  /// No description provided for @enterpriseAdminPreviewOpenAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get enterpriseAdminPreviewOpenAll;

  /// No description provided for @enterpriseAdminPreviewPositionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Position snapshot'**
  String get enterpriseAdminPreviewPositionsTitle;

  /// No description provided for @enterpriseAdminPreviewPositionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review levels, headcount, and open quota at a glance'**
  String get enterpriseAdminPreviewPositionsSubtitle;

  /// No description provided for @enterpriseAdminPreviewPositionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No position data is available yet.'**
  String get enterpriseAdminPreviewPositionsEmpty;

  /// No description provided for @enterpriseAdminPreviewAccountsTitle.
  ///
  /// In en, this message translates to:
  /// **'Account snapshot'**
  String get enterpriseAdminPreviewAccountsTitle;

  /// No description provided for @enterpriseAdminPreviewAccountsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review account identity, mapped role, and enablement status'**
  String get enterpriseAdminPreviewAccountsSubtitle;

  /// No description provided for @enterpriseAdminPreviewAccountsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No account data is available yet.'**
  String get enterpriseAdminPreviewAccountsEmpty;

  /// No description provided for @enterpriseAdminPreviewAccountEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enterpriseAdminPreviewAccountEnabled;

  /// No description provided for @enterpriseAdminPreviewAccountDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get enterpriseAdminPreviewAccountDisabled;

  /// No description provided for @enterpriseAdminEmployeesPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Employee list'**
  String get enterpriseAdminEmployeesPageTitle;

  /// No description provided for @enterpriseAdminEmployeesPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Move employee records into a dedicated read-only page so they are easier to scan and search continuously.'**
  String get enterpriseAdminEmployeesPageSubtitle;

  /// No description provided for @enterpriseAdminEmployeesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, employee number, department, or position'**
  String get enterpriseAdminEmployeesSearchHint;

  /// No description provided for @enterpriseAdminEmployeesPageSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} employees currently in scope'**
  String enterpriseAdminEmployeesPageSummary(Object count);

  /// No description provided for @enterpriseAdminEmployeesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No employee records match the current filter.'**
  String get enterpriseAdminEmployeesEmpty;

  /// No description provided for @enterpriseAdminEmployeesStatsDepartments.
  ///
  /// In en, this message translates to:
  /// **'Departments covered'**
  String get enterpriseAdminEmployeesStatsDepartments;

  /// No description provided for @enterpriseAdminEmployeesStatsPositions.
  ///
  /// In en, this message translates to:
  /// **'Positions covered'**
  String get enterpriseAdminEmployeesStatsPositions;

  /// No description provided for @enterpriseAdminDepartmentsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Department list'**
  String get enterpriseAdminDepartmentsPageTitle;

  /// No description provided for @enterpriseAdminDepartmentsPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Break out leaders, member size, and notes into a dedicated view for organization-level browsing.'**
  String get enterpriseAdminDepartmentsPageSubtitle;

  /// No description provided for @enterpriseAdminDepartmentsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by department name or leader'**
  String get enterpriseAdminDepartmentsSearchHint;

  /// No description provided for @enterpriseAdminDepartmentsPageSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} departments currently in scope'**
  String enterpriseAdminDepartmentsPageSummary(Object count);

  /// No description provided for @enterpriseAdminDepartmentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No department records match the current filter.'**
  String get enterpriseAdminDepartmentsEmpty;

  /// No description provided for @enterpriseAdminDepartmentsMemberCount.
  ///
  /// In en, this message translates to:
  /// **'{count} members'**
  String enterpriseAdminDepartmentsMemberCount(Object count);

  /// No description provided for @enterpriseAdminDepartmentsStatsMembers.
  ///
  /// In en, this message translates to:
  /// **'Total members'**
  String get enterpriseAdminDepartmentsStatsMembers;

  /// No description provided for @enterpriseAdminDepartmentsStatsLargest.
  ///
  /// In en, this message translates to:
  /// **'Largest team'**
  String get enterpriseAdminDepartmentsStatsLargest;

  /// No description provided for @enterpriseAdminDepartmentsFilterLarge.
  ///
  /// In en, this message translates to:
  /// **'10+ members'**
  String get enterpriseAdminDepartmentsFilterLarge;

  /// No description provided for @enterpriseAdminDepartmentsFilterMedium.
  ///
  /// In en, this message translates to:
  /// **'5-9 members'**
  String get enterpriseAdminDepartmentsFilterMedium;

  /// No description provided for @enterpriseAdminDepartmentsFilterCompact.
  ///
  /// In en, this message translates to:
  /// **'Under 5'**
  String get enterpriseAdminDepartmentsFilterCompact;

  /// No description provided for @enterpriseAdminPositionsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Position list'**
  String get enterpriseAdminPositionsPageTitle;

  /// No description provided for @enterpriseAdminPositionsPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Break out position level, headcount, and hiring gap into a dedicated read-only view for staffing reviews.'**
  String get enterpriseAdminPositionsPageSubtitle;

  /// No description provided for @enterpriseAdminPositionsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by position title, department, or level'**
  String get enterpriseAdminPositionsSearchHint;

  /// No description provided for @enterpriseAdminPositionsPageSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} positions currently in scope'**
  String enterpriseAdminPositionsPageSummary(Object count);

  /// No description provided for @enterpriseAdminPositionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No position records match the current filter.'**
  String get enterpriseAdminPositionsEmpty;

  /// No description provided for @enterpriseAdminPositionsVacancy.
  ///
  /// In en, this message translates to:
  /// **'{count} open'**
  String enterpriseAdminPositionsVacancy(Object count);

  /// No description provided for @enterpriseAdminPositionsStatsHeadcount.
  ///
  /// In en, this message translates to:
  /// **'Headcount'**
  String get enterpriseAdminPositionsStatsHeadcount;

  /// No description provided for @enterpriseAdminPositionsStatsVacancy.
  ///
  /// In en, this message translates to:
  /// **'Hiring gap'**
  String get enterpriseAdminPositionsStatsVacancy;

  /// No description provided for @enterpriseAdminAccountsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Account list'**
  String get enterpriseAdminAccountsPageTitle;

  /// No description provided for @enterpriseAdminAccountsPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Collect visible system accounts into a dedicated read-only page so login ID, role, and enablement are easier to verify.'**
  String get enterpriseAdminAccountsPageSubtitle;

  /// No description provided for @enterpriseAdminAccountsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by account name or login ID'**
  String get enterpriseAdminAccountsSearchHint;

  /// No description provided for @enterpriseAdminAccountsPageSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} accounts currently in scope'**
  String enterpriseAdminAccountsPageSummary(Object count);

  /// No description provided for @enterpriseAdminAccountsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No account records match the current filter.'**
  String get enterpriseAdminAccountsEmpty;

  /// No description provided for @enterpriseAdminAccountsStatsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enterpriseAdminAccountsStatsEnabled;

  /// No description provided for @enterpriseAdminAccountsStatsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get enterpriseAdminAccountsStatsDisabled;

  /// No description provided for @enterpriseAdminChangeRequestsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Change center'**
  String get enterpriseAdminChangeRequestsPageTitle;

  /// No description provided for @enterpriseAdminChangeRequestsPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review direct edits and submitted drafts in one place so recent management changes are easier to follow.'**
  String get enterpriseAdminChangeRequestsPageSubtitle;

  /// No description provided for @enterpriseAdminChangeRequestsPageSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} change requests currently in scope'**
  String enterpriseAdminChangeRequestsPageSummary(Object count);

  /// No description provided for @enterpriseAdminChangeRequestsMetricTotal.
  ///
  /// In en, this message translates to:
  /// **'Total requests'**
  String get enterpriseAdminChangeRequestsMetricTotal;

  /// No description provided for @enterpriseAdminChangeRequestsMetricApplied.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get enterpriseAdminChangeRequestsMetricApplied;

  /// No description provided for @enterpriseAdminChangeRequestsMetricDrafted.
  ///
  /// In en, this message translates to:
  /// **'Drafted'**
  String get enterpriseAdminChangeRequestsMetricDrafted;

  /// No description provided for @enterpriseAdminChangeRequestsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by request number, object, note, or requester'**
  String get enterpriseAdminChangeRequestsSearchHint;

  /// No description provided for @enterpriseAdminChangeRequestsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No change requests match the current filter.'**
  String get enterpriseAdminChangeRequestsEmpty;

  /// No description provided for @enterpriseAdminChangeRequestsStatusApplied.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get enterpriseAdminChangeRequestsStatusApplied;

  /// No description provided for @enterpriseAdminChangeRequestsStatusDrafted.
  ///
  /// In en, this message translates to:
  /// **'Drafted'**
  String get enterpriseAdminChangeRequestsStatusDrafted;

  /// No description provided for @enterpriseAdminChangeRequestsStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get enterpriseAdminChangeRequestsStatusRejected;

  /// No description provided for @enterpriseAdminChangeRequestsEntityEmployee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get enterpriseAdminChangeRequestsEntityEmployee;

  /// No description provided for @enterpriseAdminChangeRequestsEntityDepartment.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get enterpriseAdminChangeRequestsEntityDepartment;

  /// No description provided for @enterpriseAdminChangeRequestsEntityPosition.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get enterpriseAdminChangeRequestsEntityPosition;

  /// No description provided for @enterpriseAdminChangeRequestsEntityAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get enterpriseAdminChangeRequestsEntityAccount;

  /// No description provided for @enterpriseAdminChangeRequestsOpenRecord.
  ///
  /// In en, this message translates to:
  /// **'Open related record'**
  String get enterpriseAdminChangeRequestsOpenRecord;

  /// No description provided for @enterpriseAdminChangeRequestsRequester.
  ///
  /// In en, this message translates to:
  /// **'Requester'**
  String get enterpriseAdminChangeRequestsRequester;

  /// No description provided for @enterpriseAdminChangeRequestsSubmittedAt.
  ///
  /// In en, this message translates to:
  /// **'Submitted at'**
  String get enterpriseAdminChangeRequestsSubmittedAt;

  /// No description provided for @enterpriseAdminChangeRequestDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Change request detail'**
  String get enterpriseAdminChangeRequestDetailTitle;

  /// No description provided for @enterpriseAdminChangeRequestDetailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review the saved snapshot and context for this {entityType} change.'**
  String enterpriseAdminChangeRequestDetailSubtitle(Object entityType);

  /// No description provided for @enterpriseAdminChangeRequestDetailLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load this change request detail.'**
  String get enterpriseAdminChangeRequestDetailLoadFailed;

  /// No description provided for @enterpriseAdminChangeRequestDetailStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get enterpriseAdminChangeRequestDetailStatus;

  /// No description provided for @enterpriseAdminChangeRequestDetailNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Change note'**
  String get enterpriseAdminChangeRequestDetailNoteTitle;

  /// No description provided for @enterpriseAdminChangeRequestDetailObjectLabel.
  ///
  /// In en, this message translates to:
  /// **'Target object'**
  String get enterpriseAdminChangeRequestDetailObjectLabel;

  /// No description provided for @enterpriseAdminChangeRequestDetailSnapshotTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved snapshot'**
  String get enterpriseAdminChangeRequestDetailSnapshotTitle;

  /// No description provided for @enterpriseAdminChangeRequestDetailSnapshotSubtitle.
  ///
  /// In en, this message translates to:
  /// **'These are the fields captured when the draft or direct edit was submitted.'**
  String get enterpriseAdminChangeRequestDetailSnapshotSubtitle;

  /// No description provided for @enterpriseAdminChangeRequestDetailSnapshotEmpty.
  ///
  /// In en, this message translates to:
  /// **'No field snapshot is available for this request.'**
  String get enterpriseAdminChangeRequestDetailSnapshotEmpty;

  /// No description provided for @enterpriseAdminChangeRequestDetailCompareTitle.
  ///
  /// In en, this message translates to:
  /// **'Field comparison'**
  String get enterpriseAdminChangeRequestDetailCompareTitle;

  /// No description provided for @enterpriseAdminChangeRequestDetailCompareSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Compare the submitted snapshot with the current live record to spot drift quickly.'**
  String get enterpriseAdminChangeRequestDetailCompareSubtitle;

  /// No description provided for @enterpriseAdminChangeRequestDetailCompareEmpty.
  ///
  /// In en, this message translates to:
  /// **'No comparable fields are available for this request.'**
  String get enterpriseAdminChangeRequestDetailCompareEmpty;

  /// No description provided for @enterpriseAdminChangeRequestDetailCompareSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Snapshot value'**
  String get enterpriseAdminChangeRequestDetailCompareSnapshot;

  /// No description provided for @enterpriseAdminChangeRequestDetailCompareCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current value'**
  String get enterpriseAdminChangeRequestDetailCompareCurrent;

  /// No description provided for @enterpriseAdminChangeRequestDetailCompareSame.
  ///
  /// In en, this message translates to:
  /// **'Same'**
  String get enterpriseAdminChangeRequestDetailCompareSame;

  /// No description provided for @enterpriseAdminChangeRequestDetailCompareDifferent.
  ///
  /// In en, this message translates to:
  /// **'Different'**
  String get enterpriseAdminChangeRequestDetailCompareDifferent;

  /// No description provided for @enterpriseAdminChangeRequestDetailCompareUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get enterpriseAdminChangeRequestDetailCompareUnavailable;

  /// No description provided for @enterpriseAdminChangeRequestApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve change'**
  String get enterpriseAdminChangeRequestApprove;

  /// No description provided for @enterpriseAdminChangeRequestReject.
  ///
  /// In en, this message translates to:
  /// **'Reject change'**
  String get enterpriseAdminChangeRequestReject;

  /// No description provided for @enterpriseAdminChangeRequestProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get enterpriseAdminChangeRequestProcessing;

  /// No description provided for @enterpriseAdminChangeRequestApproveSuccess.
  ///
  /// In en, this message translates to:
  /// **'The change request was approved.'**
  String get enterpriseAdminChangeRequestApproveSuccess;

  /// No description provided for @enterpriseAdminChangeRequestRejectSuccess.
  ///
  /// In en, this message translates to:
  /// **'The change request was rejected.'**
  String get enterpriseAdminChangeRequestRejectSuccess;

  /// No description provided for @enterpriseAdminChangeRequestReviewUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The current account cannot review this change request.'**
  String get enterpriseAdminChangeRequestReviewUnavailable;

  /// No description provided for @enterpriseAdminDetailPanelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This is a read-only detail view for quickly verifying records and organization context.'**
  String get enterpriseAdminDetailPanelSubtitle;

  /// No description provided for @enterpriseAdminDetailPanelHint.
  ///
  /// In en, this message translates to:
  /// **'Edit flows, approval hooks, and audit trails can land here later once the real management actions are wired in.'**
  String get enterpriseAdminDetailPanelHint;

  /// No description provided for @enterpriseAdminDetailActionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit placeholder'**
  String get enterpriseAdminDetailActionEdit;

  /// No description provided for @enterpriseAdminDetailActionDirectEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit employee'**
  String get enterpriseAdminDetailActionDirectEdit;

  /// No description provided for @enterpriseAdminDetailActionRequestChange.
  ///
  /// In en, this message translates to:
  /// **'Request change'**
  String get enterpriseAdminDetailActionRequestChange;

  /// No description provided for @enterpriseAdminDetailActionAudit.
  ///
  /// In en, this message translates to:
  /// **'Change log'**
  String get enterpriseAdminDetailActionAudit;

  /// No description provided for @enterpriseAdminDetailActionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get enterpriseAdminDetailActionClose;

  /// No description provided for @enterpriseAdminEditActionCollapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse edit'**
  String get enterpriseAdminEditActionCollapse;

  /// No description provided for @enterpriseAdminEditPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'Direct edit'**
  String get enterpriseAdminEditPanelTitle;

  /// No description provided for @enterpriseAdminEditPanelHint.
  ///
  /// In en, this message translates to:
  /// **'Update the employee record here and save it directly to the backend. The list and detail view will refresh immediately after the request succeeds.'**
  String get enterpriseAdminEditPanelHint;

  /// No description provided for @enterpriseAdminEditEmployeeTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit employee profile'**
  String get enterpriseAdminEditEmployeeTitle;

  /// No description provided for @enterpriseAdminEditEmployeeHint.
  ///
  /// In en, this message translates to:
  /// **'This panel writes employee profile fields directly to the backend. Use it for fast corrections to department, position, email, and phone.'**
  String get enterpriseAdminEditEmployeeHint;

  /// No description provided for @enterpriseAdminEditDepartmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit department profile'**
  String get enterpriseAdminEditDepartmentTitle;

  /// No description provided for @enterpriseAdminEditDepartmentHint.
  ///
  /// In en, this message translates to:
  /// **'This panel writes department profile fields directly to the backend view. The department card, employee labels, and position ownership will refresh after save.'**
  String get enterpriseAdminEditDepartmentHint;

  /// No description provided for @enterpriseAdminEditPositionTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit position profile'**
  String get enterpriseAdminEditPositionTitle;

  /// No description provided for @enterpriseAdminEditPositionHint.
  ///
  /// In en, this message translates to:
  /// **'This panel writes position title, level, and hiring gap directly to the backend staffing view. Employee labels and position summaries will refresh after save.'**
  String get enterpriseAdminEditPositionHint;

  /// No description provided for @enterpriseAdminEditAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit account access'**
  String get enterpriseAdminEditAccountTitle;

  /// No description provided for @enterpriseAdminEditAccountHint.
  ///
  /// In en, this message translates to:
  /// **'This panel writes account role and enabled state to the backend access layer. Login, session restore, and permission checks will use the updated values.'**
  String get enterpriseAdminEditAccountHint;

  /// No description provided for @enterpriseAdminEditSubmit.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get enterpriseAdminEditSubmit;

  /// No description provided for @enterpriseAdminEditSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get enterpriseAdminEditSaving;

  /// No description provided for @enterpriseAdminEditSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Changes were saved.'**
  String get enterpriseAdminEditSaveSuccess;

  /// No description provided for @enterpriseAdminEditEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please complete all editable fields first.'**
  String get enterpriseAdminEditEmpty;

  /// No description provided for @enterpriseAdminDraftActionCollapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse draft'**
  String get enterpriseAdminDraftActionCollapse;

  /// No description provided for @enterpriseAdminDraftPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'Request change'**
  String get enterpriseAdminDraftPanelTitle;

  /// No description provided for @enterpriseAdminDraftPanelHint.
  ///
  /// In en, this message translates to:
  /// **'This step generates a local change draft first so the intended update is easy to review; later it can submit to real write APIs or approval flows.'**
  String get enterpriseAdminDraftPanelHint;

  /// No description provided for @enterpriseAdminDraftCurrentSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Current field snapshot'**
  String get enterpriseAdminDraftCurrentSnapshot;

  /// No description provided for @enterpriseAdminDraftInputHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the requested change, for example: change the department owner to Wang Wu because of a rotation.'**
  String get enterpriseAdminDraftInputHint;

  /// No description provided for @enterpriseAdminDraftSubmit.
  ///
  /// In en, this message translates to:
  /// **'Create change draft'**
  String get enterpriseAdminDraftSubmit;

  /// No description provided for @enterpriseAdminDraftSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get enterpriseAdminDraftSubmitting;

  /// No description provided for @enterpriseAdminDraftSubmitSuccess.
  ///
  /// In en, this message translates to:
  /// **'The change draft was created and added to the local timeline.'**
  String get enterpriseAdminDraftSubmitSuccess;

  /// No description provided for @enterpriseAdminDraftSubmitSuccessWithRequest.
  ///
  /// In en, this message translates to:
  /// **'The change draft was submitted. Request No.: {requestNo}'**
  String enterpriseAdminDraftSubmitSuccessWithRequest(Object requestNo);

  /// No description provided for @enterpriseAdminDraftEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter change notes first.'**
  String get enterpriseAdminDraftEmpty;

  /// No description provided for @enterpriseAdminDraftTypeProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile fix'**
  String get enterpriseAdminDraftTypeProfile;

  /// No description provided for @enterpriseAdminDraftTypeOrg.
  ///
  /// In en, this message translates to:
  /// **'Org adjustment'**
  String get enterpriseAdminDraftTypeOrg;

  /// No description provided for @enterpriseAdminDraftTypeStatus.
  ///
  /// In en, this message translates to:
  /// **'Status change'**
  String get enterpriseAdminDraftTypeStatus;

  /// No description provided for @enterpriseAdminDraftTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'{type} draft created'**
  String enterpriseAdminDraftTimelineTitle(Object type);

  /// No description provided for @enterpriseAdminDraftTimelineDetail.
  ///
  /// In en, this message translates to:
  /// **'Draft notes: {note}'**
  String enterpriseAdminDraftTimelineDetail(Object note);

  /// No description provided for @enterpriseAdminDraftTimelineDetailWithRequest.
  ///
  /// In en, this message translates to:
  /// **'Draft notes: {note}. Request No.: {requestNo}'**
  String enterpriseAdminDraftTimelineDetailWithRequest(
    Object note,
    Object requestNo,
  );

  /// No description provided for @enterpriseAdminDetailActionCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy field'**
  String get enterpriseAdminDetailActionCopy;

  /// No description provided for @enterpriseAdminDetailActionOpenRelated.
  ///
  /// In en, this message translates to:
  /// **'Open related record'**
  String get enterpriseAdminDetailActionOpenRelated;

  /// No description provided for @enterpriseAdminDetailCopySuccess.
  ///
  /// In en, this message translates to:
  /// **'Copied: {label}'**
  String enterpriseAdminDetailCopySuccess(Object label);

  /// No description provided for @enterpriseAdminTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Change timeline'**
  String get enterpriseAdminTimelineTitle;

  /// No description provided for @enterpriseAdminTimelineHint.
  ///
  /// In en, this message translates to:
  /// **'This is a read-only audit trail for quickly checking recent syncs, status changes, and important organization updates.'**
  String get enterpriseAdminTimelineHint;

  /// No description provided for @enterpriseAdminTimelineEmpty.
  ///
  /// In en, this message translates to:
  /// **'No change history is available yet.'**
  String get enterpriseAdminTimelineEmpty;

  /// No description provided for @enterpriseAdminTimelineRecent.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get enterpriseAdminTimelineRecent;

  /// No description provided for @enterpriseAdminTimelineToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get enterpriseAdminTimelineToday;

  /// No description provided for @enterpriseAdminTimelineEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get enterpriseAdminTimelineEarlier;

  /// No description provided for @enterpriseAdminTimelineEmployeeStatus.
  ///
  /// In en, this message translates to:
  /// **'Employee status updated'**
  String get enterpriseAdminTimelineEmployeeStatus;

  /// No description provided for @enterpriseAdminTimelineEmployeeStatusDetail.
  ///
  /// In en, this message translates to:
  /// **'The current employee status has been synced as {status}.'**
  String enterpriseAdminTimelineEmployeeStatusDetail(Object status);

  /// No description provided for @enterpriseAdminTimelineEmployeeSync.
  ///
  /// In en, this message translates to:
  /// **'Organization info synced'**
  String get enterpriseAdminTimelineEmployeeSync;

  /// No description provided for @enterpriseAdminTimelineEmployeeSyncDetail.
  ///
  /// In en, this message translates to:
  /// **'The employee is currently in {department} as {position}.'**
  String enterpriseAdminTimelineEmployeeSyncDetail(
    Object department,
    Object position,
  );

  /// No description provided for @enterpriseAdminTimelineEmployeeUpdated.
  ///
  /// In en, this message translates to:
  /// **'Employee profile updated'**
  String get enterpriseAdminTimelineEmployeeUpdated;

  /// No description provided for @enterpriseAdminTimelineEmployeeUpdatedDetail.
  ///
  /// In en, this message translates to:
  /// **'Updated to {department} / {position}, phone {phone}, email {email}.'**
  String enterpriseAdminTimelineEmployeeUpdatedDetail(
    Object department,
    Object position,
    Object phone,
    Object email,
  );

  /// No description provided for @enterpriseAdminTimelineEmployeeCreated.
  ///
  /// In en, this message translates to:
  /// **'Employee record created'**
  String get enterpriseAdminTimelineEmployeeCreated;

  /// No description provided for @enterpriseAdminTimelineEmployeeCreatedDetail.
  ///
  /// In en, this message translates to:
  /// **'A base record has been created for employee number {employeeNo}.'**
  String enterpriseAdminTimelineEmployeeCreatedDetail(Object employeeNo);

  /// No description provided for @enterpriseAdminTimelineDepartmentLeader.
  ///
  /// In en, this message translates to:
  /// **'Leader confirmed'**
  String get enterpriseAdminTimelineDepartmentLeader;

  /// No description provided for @enterpriseAdminTimelineDepartmentLeaderDetail.
  ///
  /// In en, this message translates to:
  /// **'The current department leader is {leader}.'**
  String enterpriseAdminTimelineDepartmentLeaderDetail(Object leader);

  /// No description provided for @enterpriseAdminTimelineDepartmentSize.
  ///
  /// In en, this message translates to:
  /// **'Team size refreshed'**
  String get enterpriseAdminTimelineDepartmentSize;

  /// No description provided for @enterpriseAdminTimelineDepartmentSizeDetail.
  ///
  /// In en, this message translates to:
  /// **'The department member count is now {count}.'**
  String enterpriseAdminTimelineDepartmentSizeDetail(Object count);

  /// No description provided for @enterpriseAdminTimelineDepartmentUpdated.
  ///
  /// In en, this message translates to:
  /// **'Department profile updated'**
  String get enterpriseAdminTimelineDepartmentUpdated;

  /// No description provided for @enterpriseAdminTimelineDepartmentUpdatedDetail.
  ///
  /// In en, this message translates to:
  /// **'Updated {name}, leader {leader}.'**
  String enterpriseAdminTimelineDepartmentUpdatedDetail(
    Object name,
    Object leader,
  );

  /// No description provided for @enterpriseAdminTimelineDepartmentCreated.
  ///
  /// In en, this message translates to:
  /// **'Department profile created'**
  String get enterpriseAdminTimelineDepartmentCreated;

  /// No description provided for @enterpriseAdminTimelineDepartmentCreatedDetail.
  ///
  /// In en, this message translates to:
  /// **'Base organization data has been created for {name}.'**
  String enterpriseAdminTimelineDepartmentCreatedDetail(Object name);

  /// No description provided for @enterpriseAdminTimelinePositionVacancy.
  ///
  /// In en, this message translates to:
  /// **'Hiring gap synced'**
  String get enterpriseAdminTimelinePositionVacancy;

  /// No description provided for @enterpriseAdminTimelinePositionVacancyDetail.
  ///
  /// In en, this message translates to:
  /// **'The current hiring gap is {count} positions.'**
  String enterpriseAdminTimelinePositionVacancyDetail(Object count);

  /// No description provided for @enterpriseAdminTimelinePositionHeadcount.
  ///
  /// In en, this message translates to:
  /// **'Headcount updated'**
  String get enterpriseAdminTimelinePositionHeadcount;

  /// No description provided for @enterpriseAdminTimelinePositionHeadcountDetail.
  ///
  /// In en, this message translates to:
  /// **'The approved headcount is now {count}.'**
  String enterpriseAdminTimelinePositionHeadcountDetail(Object count);

  /// No description provided for @enterpriseAdminTimelinePositionCreated.
  ///
  /// In en, this message translates to:
  /// **'Position plan created'**
  String get enterpriseAdminTimelinePositionCreated;

  /// No description provided for @enterpriseAdminTimelinePositionCreatedDetail.
  ///
  /// In en, this message translates to:
  /// **'This position plan has been attached to {department}.'**
  String enterpriseAdminTimelinePositionCreatedDetail(Object department);

  /// No description provided for @enterpriseAdminTimelinePositionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Position profile updated'**
  String get enterpriseAdminTimelinePositionUpdated;

  /// No description provided for @enterpriseAdminTimelinePositionUpdatedDetail.
  ///
  /// In en, this message translates to:
  /// **'Updated to {title} / {level} with {openQuota} open roles.'**
  String enterpriseAdminTimelinePositionUpdatedDetail(
    Object title,
    Object level,
    Object openQuota,
  );

  /// No description provided for @enterpriseAdminTimelineAccountStatus.
  ///
  /// In en, this message translates to:
  /// **'Account status updated'**
  String get enterpriseAdminTimelineAccountStatus;

  /// No description provided for @enterpriseAdminTimelineAccountStatusDetail.
  ///
  /// In en, this message translates to:
  /// **'The current account status is {status}.'**
  String enterpriseAdminTimelineAccountStatusDetail(Object status);

  /// No description provided for @enterpriseAdminTimelineAccountRole.
  ///
  /// In en, this message translates to:
  /// **'Role mapping refreshed'**
  String get enterpriseAdminTimelineAccountRole;

  /// No description provided for @enterpriseAdminTimelineAccountRoleDetail.
  ///
  /// In en, this message translates to:
  /// **'The current account role is {role}.'**
  String enterpriseAdminTimelineAccountRoleDetail(Object role);

  /// No description provided for @enterpriseAdminTimelineAccountUpdated.
  ///
  /// In en, this message translates to:
  /// **'Account access updated'**
  String get enterpriseAdminTimelineAccountUpdated;

  /// No description provided for @enterpriseAdminTimelineAccountUpdatedDetail.
  ///
  /// In en, this message translates to:
  /// **'Updated to role {role} with status {status}.'**
  String enterpriseAdminTimelineAccountUpdatedDetail(
    Object role,
    Object status,
  );

  /// No description provided for @enterpriseAdminTimelineAccountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account record created'**
  String get enterpriseAdminTimelineAccountCreated;

  /// No description provided for @enterpriseAdminTimelineAccountCreatedDetail.
  ///
  /// In en, this message translates to:
  /// **'The login ID {loginId} has been added to the directory.'**
  String enterpriseAdminTimelineAccountCreatedDetail(Object loginId);

  /// No description provided for @enterpriseAdminDetailEmployeeNo.
  ///
  /// In en, this message translates to:
  /// **'Employee No.'**
  String get enterpriseAdminDetailEmployeeNo;

  /// No description provided for @enterpriseAdminDetailDepartment.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get enterpriseAdminDetailDepartment;

  /// No description provided for @enterpriseAdminDetailPosition.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get enterpriseAdminDetailPosition;

  /// No description provided for @enterpriseAdminDetailEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get enterpriseAdminDetailEmail;

  /// No description provided for @enterpriseAdminDetailPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get enterpriseAdminDetailPhone;

  /// No description provided for @enterpriseAdminDetailStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get enterpriseAdminDetailStatus;

  /// No description provided for @enterpriseAdminDetailLeader.
  ///
  /// In en, this message translates to:
  /// **'Leader'**
  String get enterpriseAdminDetailLeader;

  /// No description provided for @enterpriseAdminDetailMemberCount.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get enterpriseAdminDetailMemberCount;

  /// No description provided for @enterpriseAdminDetailDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get enterpriseAdminDetailDescription;

  /// No description provided for @enterpriseAdminDetailLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get enterpriseAdminDetailLevel;

  /// No description provided for @enterpriseAdminDetailHeadcount.
  ///
  /// In en, this message translates to:
  /// **'Headcount'**
  String get enterpriseAdminDetailHeadcount;

  /// No description provided for @enterpriseAdminDetailVacancy.
  ///
  /// In en, this message translates to:
  /// **'Vacancy'**
  String get enterpriseAdminDetailVacancy;

  /// No description provided for @enterpriseAdminDetailLoginId.
  ///
  /// In en, this message translates to:
  /// **'Login ID'**
  String get enterpriseAdminDetailLoginId;

  /// No description provided for @enterpriseAdminDetailRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get enterpriseAdminDetailRole;

  /// No description provided for @enterpriseAdminMetricEmployees.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get enterpriseAdminMetricEmployees;

  /// No description provided for @enterpriseAdminMetricDepartments.
  ///
  /// In en, this message translates to:
  /// **'Departments'**
  String get enterpriseAdminMetricDepartments;

  /// No description provided for @enterpriseAdminMetricPositions.
  ///
  /// In en, this message translates to:
  /// **'Positions'**
  String get enterpriseAdminMetricPositions;

  /// No description provided for @enterpriseAdminMetricAccounts.
  ///
  /// In en, this message translates to:
  /// **'Enabled accounts'**
  String get enterpriseAdminMetricAccounts;

  /// No description provided for @enterpriseAdminModuleEmployeesTitle.
  ///
  /// In en, this message translates to:
  /// **'Employee records'**
  String get enterpriseAdminModuleEmployeesTitle;

  /// No description provided for @enterpriseAdminModuleEmployeesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review employee profiles, statuses, and organizational placement'**
  String get enterpriseAdminModuleEmployeesSubtitle;

  /// No description provided for @enterpriseAdminModuleDepartmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Department setup'**
  String get enterpriseAdminModuleDepartmentsTitle;

  /// No description provided for @enterpriseAdminModuleDepartmentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Maintain structure, owners, and staffing boundaries'**
  String get enterpriseAdminModuleDepartmentsSubtitle;

  /// No description provided for @enterpriseAdminModulePositionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Position planning'**
  String get enterpriseAdminModulePositionsTitle;

  /// No description provided for @enterpriseAdminModulePositionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track levels, quotas, and open headcount'**
  String get enterpriseAdminModulePositionsSubtitle;

  /// No description provided for @enterpriseAdminModuleAccountsTitle.
  ///
  /// In en, this message translates to:
  /// **'Account control'**
  String get enterpriseAdminModuleAccountsTitle;

  /// No description provided for @enterpriseAdminModuleAccountsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure admin roles and account enablement'**
  String get enterpriseAdminModuleAccountsSubtitle;

  /// No description provided for @enterpriseAdminModuleExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export center'**
  String get enterpriseAdminModuleExportTitle;

  /// No description provided for @enterpriseAdminModuleExportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Download Excel snapshots when the role allows it'**
  String get enterpriseAdminModuleExportSubtitle;

  /// No description provided for @enterpriseAdminModuleAllowedHint.
  ///
  /// In en, this message translates to:
  /// **'Available for the current role'**
  String get enterpriseAdminModuleAllowedHint;

  /// No description provided for @enterpriseAdminStatusAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get enterpriseAdminStatusAvailable;

  /// No description provided for @enterpriseAdminStatusLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get enterpriseAdminStatusLocked;

  /// No description provided for @enterpriseAdminPermissionLineEmployees.
  ///
  /// In en, this message translates to:
  /// **'Maintain employee records'**
  String get enterpriseAdminPermissionLineEmployees;

  /// No description provided for @enterpriseAdminPermissionLineDepartments.
  ///
  /// In en, this message translates to:
  /// **'Maintain departments'**
  String get enterpriseAdminPermissionLineDepartments;

  /// No description provided for @enterpriseAdminPermissionLinePositions.
  ///
  /// In en, this message translates to:
  /// **'Maintain positions'**
  String get enterpriseAdminPermissionLinePositions;

  /// No description provided for @enterpriseAdminPermissionLineAccounts.
  ///
  /// In en, this message translates to:
  /// **'Configure account permissions'**
  String get enterpriseAdminPermissionLineAccounts;

  /// No description provided for @enterpriseAdminPermissionLineExport.
  ///
  /// In en, this message translates to:
  /// **'Export Excel snapshots'**
  String get enterpriseAdminPermissionLineExport;

  /// No description provided for @enterpriseAdminExportHeaderEmployeeNo.
  ///
  /// In en, this message translates to:
  /// **'Employee No.'**
  String get enterpriseAdminExportHeaderEmployeeNo;

  /// No description provided for @enterpriseAdminExportHeaderName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get enterpriseAdminExportHeaderName;

  /// No description provided for @enterpriseAdminExportHeaderDepartment.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get enterpriseAdminExportHeaderDepartment;

  /// No description provided for @enterpriseAdminExportHeaderPosition.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get enterpriseAdminExportHeaderPosition;

  /// No description provided for @enterpriseAdminExportHeaderPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get enterpriseAdminExportHeaderPhone;

  /// No description provided for @enterpriseAdminExportHeaderEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get enterpriseAdminExportHeaderEmail;

  /// No description provided for @enterpriseAdminExportHeaderStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get enterpriseAdminExportHeaderStatus;

  /// No description provided for @enterpriseAdminExportHeaderLeader.
  ///
  /// In en, this message translates to:
  /// **'Leader'**
  String get enterpriseAdminExportHeaderLeader;

  /// No description provided for @enterpriseAdminExportHeaderCount.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get enterpriseAdminExportHeaderCount;

  /// No description provided for @enterpriseAdminExportHeaderDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get enterpriseAdminExportHeaderDescription;

  /// No description provided for @enterpriseAdminExportHeaderLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get enterpriseAdminExportHeaderLevel;

  /// No description provided for @enterpriseAdminExportHeaderDepartmentOwned.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get enterpriseAdminExportHeaderDepartmentOwned;

  /// No description provided for @enterpriseAdminExportHeaderHeadcount.
  ///
  /// In en, this message translates to:
  /// **'Headcount'**
  String get enterpriseAdminExportHeaderHeadcount;

  /// No description provided for @enterpriseAdminExportHeaderVacancy.
  ///
  /// In en, this message translates to:
  /// **'Vacancy'**
  String get enterpriseAdminExportHeaderVacancy;

  /// No description provided for @enterpriseAdminMonthJan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get enterpriseAdminMonthJan;

  /// No description provided for @enterpriseAdminMonthFeb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get enterpriseAdminMonthFeb;

  /// No description provided for @enterpriseAdminMonthMar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get enterpriseAdminMonthMar;

  /// No description provided for @enterpriseAdminMonthApr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get enterpriseAdminMonthApr;

  /// No description provided for @enterpriseAdminMonthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get enterpriseAdminMonthMay;

  /// No description provided for @enterpriseAdminMonthJun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get enterpriseAdminMonthJun;

  /// No description provided for @enterpriseAdminSessionUserFallback.
  ///
  /// In en, this message translates to:
  /// **'Current account'**
  String get enterpriseAdminSessionUserFallback;

  /// No description provided for @enterpriseAdminRoleSuperAdmin.
  ///
  /// In en, this message translates to:
  /// **'Super admin'**
  String get enterpriseAdminRoleSuperAdmin;

  /// No description provided for @enterpriseAdminRoleHrManager.
  ///
  /// In en, this message translates to:
  /// **'HR admin'**
  String get enterpriseAdminRoleHrManager;

  /// No description provided for @enterpriseAdminRoleDepartmentManager.
  ///
  /// In en, this message translates to:
  /// **'Department manager'**
  String get enterpriseAdminRoleDepartmentManager;

  /// No description provided for @enterpriseAdminRoleViewer.
  ///
  /// In en, this message translates to:
  /// **'Read-only viewer'**
  String get enterpriseAdminRoleViewer;

  /// No description provided for @themeToggleSwitchToDark.
  ///
  /// In en, this message translates to:
  /// **'Switch to dark mode'**
  String get themeToggleSwitchToDark;

  /// No description provided for @themeToggleSwitchToLight.
  ///
  /// In en, this message translates to:
  /// **'Switch to light mode'**
  String get themeToggleSwitchToLight;

  /// No description provided for @themeToggleLabelDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeToggleLabelDark;

  /// No description provided for @themeToggleLabelLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeToggleLabelLight;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
