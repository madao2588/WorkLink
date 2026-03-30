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
}
