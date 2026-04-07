import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:my_first_app/app/shared/models/user_model.dart';
import 'package:my_first_app/app/shared/widgets/app_dashboard_hero.dart';
import 'package:my_first_app/app/theme/app_theme.dart';
import 'package:my_first_app/l10n/app_localizations.dart';
import 'package:my_first_app/features/contacts/presentation/providers/contacts_provider.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _keyword = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final ContactsProvider contactsProvider = context
          .read<ContactsProvider>();
      // 登录/会话恢复时已由 provider 侧触发首刷；此处只在为空时兜底刷新。
      if (contactsProvider.contacts.isEmpty && !contactsProvider.isLoading) {
        unawaited(contactsProvider.loadContacts());
      }
    });
    _searchController.addListener(() {
      setState(() {
        _keyword = _searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ContactsProvider contactsProvider = context.watch<ContactsProvider>();
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final List<UserModel> allUsers = contactsProvider.contacts;
    final List<UserModel> filteredUsers = _filterUsers(allUsers);
    final List<UserModel> onlineUsers = filteredUsers
        .where((UserModel user) => user.isOnline)
        .toList();
    final Map<String, List<UserModel>> groupedUsers = _groupUsersByDepartment(
      filteredUsers,
    );

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              sliver: SliverList.list(
                children: <Widget>[
                  _buildHeader(
                    onlineUsers.length,
                    filteredUsers.length,
                    groupedUsers.length,
                  ),
                  const SizedBox(height: 20),
                  _buildSearchBox(),
                  const SizedBox(height: 20),
                  if (contactsProvider.isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (contactsProvider.errorMessage != null)
                    _buildMessageCard(contactsProvider.errorMessage!)
                  else ...<Widget>[
                    _buildOnlineSection(onlineUsers),
                    const SizedBox(height: 24),
                    _buildSectionTitle(
                      title: l10n.contactsDirectoryTitle,
                      subtitle: _keyword.isEmpty
                          ? l10n.contactsDirectorySubtitleDefault
                          : l10n.contactsDirectorySubtitleFiltered,
                    ),
                    const SizedBox(height: 14),
                    if (groupedUsers.isEmpty)
                      _buildEmptyState()
                    else
                      ...groupedUsers.entries.map(_buildDepartmentSection),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<UserModel> _filterUsers(List<UserModel> users) {
    if (_keyword.isEmpty) {
      return users;
    }
    final String query = _keyword.toLowerCase();
    return users.where((UserModel user) {
      return user.name.toLowerCase().contains(query) ||
          user.department.toLowerCase().contains(query);
    }).toList();
  }

  Map<String, List<UserModel>> _groupUsersByDepartment(List<UserModel> users) {
    final Map<String, List<UserModel>> grouped = <String, List<UserModel>>{};
    for (final UserModel user in users) {
      grouped.putIfAbsent(user.department, () => <UserModel>[]).add(user);
    }
    return grouped;
  }

  Widget _buildHeader(int onlineCount, int contactCount, int departmentCount) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return AppDashboardHero(
      title: l10n.contactsTitle,
      subtitle: l10n.contactsSubtitle,
      badgeText: l10n.contactsHeaderOnlineCount(onlineCount),
      icon: Icons.groups_rounded,
      stats: <AppDashboardHeroStat>[
        AppDashboardHeroStat(label: l10n.contactsOnline, value: '$onlineCount'),
        AppDashboardHeroStat(label: '联系人', value: '$contactCount'),
        AppDashboardHeroStat(label: '部门数', value: '$departmentCount'),
      ],
    );
  }

  Widget _buildSearchBox() {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: AppThemePalette.surface(context),
        borderRadius: BorderRadius.circular(24),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppThemePalette.shadow(context),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: l10n.contactsSearchHint,
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _keyword.isEmpty
              ? null
              : IconButton(
                  onPressed: _searchController.clear,
                  icon: const Icon(Icons.close_rounded),
                ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(
              color: AppColors.brandBlue,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineSection(List<UserModel> onlineUsers) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionTitle(
          title: l10n.contactsOnlineNowTitle,
          subtitle: l10n.contactsOnlineNowSubtitle,
        ),
        const SizedBox(height: 14),
        if (onlineUsers.isEmpty)
          _buildMessageCard(l10n.contactsNoOnlineMatched)
        else
          SizedBox(
            height: 92,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: onlineUsers.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (BuildContext context, int index) {
                return _OnlineUserCard(user: onlineUsers[index]);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildSectionTitle({required String title, required String subtitle}) {
    final Color titleColor = AppThemePalette.textPrimary(context);
    final Color subtitleColor = AppThemePalette.textSecondary(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: subtitleColor),
        ),
      ],
    );
  }

  Widget _buildDepartmentSection(MapEntry<String, List<UserModel>> entry) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 12),
            child: Row(
              children: <Widget>[
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.brandBlue,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.contactsPeopleCount(entry.value.length),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ...entry.value.map(
            (UserModel user) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ContactCard(user: user),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(String message) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppThemePalette.surface(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppThemePalette.border(context)),
      ),
      child: Text(
        message,
        style: TextStyle(color: AppThemePalette.textSecondary(context)),
      ),
    );
  }

  Widget _buildEmptyState() {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: AppThemePalette.surface(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppThemePalette.border(context)),
      ),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.manage_search_rounded,
            size: 40,
            color: AppThemePalette.textHint(context),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.contactsNoContactsMatched,
            style: TextStyle(
              color: AppThemePalette.textPrimary(context),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.contactsTryAnotherKeyword,
            style: TextStyle(color: AppThemePalette.textSecondary(context)),
          ),
        ],
      ),
    );
  }
}

class _OnlineUserCard extends StatelessWidget {
  const _OnlineUserCard({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 172,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppThemePalette.surface(context),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppThemePalette.border(context)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppThemePalette.shadow(context),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFEAF1FF),
                child: Text(
                  user.avatar,
                  style: const TextStyle(
                    color: AppColors.brandBlue,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Positioned(
                right: 1,
                bottom: 1,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppThemePalette.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.department,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppThemePalette.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppThemePalette.surface(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppThemePalette.border(context)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppThemePalette.shadow(context),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFEAF1FF),
            child: Text(
              user.avatar,
              style: const TextStyle(
                color: AppColors.brandBlue,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        user.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppThemePalette.textPrimary(context),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: user.isOnline
                            ? AppColors.success.withAlpha(18)
                            : AppColors.textHint.withAlpha(14),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        user.isOnline
                            ? l10n.contactsOnline
                            : l10n.contactsOffline,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: user.isOnline
                              ? AppColors.success
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  user.department,
                  style: TextStyle(
                    color: AppThemePalette.textSecondary(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
