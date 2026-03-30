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
