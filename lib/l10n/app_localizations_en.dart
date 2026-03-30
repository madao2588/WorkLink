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
}
