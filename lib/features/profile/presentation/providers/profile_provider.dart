import 'dart:async';

import 'package:flutter/material.dart';

import 'package:my_first_app/app/shared/network/api_client.dart';
import 'package:my_first_app/features/profile/data/profile_repository.dart';
import 'package:my_first_app/features/profile/domain/models/account_security_data.dart';
import 'package:my_first_app/features/profile/domain/models/badge_item.dart';
import 'package:my_first_app/features/profile/domain/models/general_settings_data.dart';
import 'package:my_first_app/features/profile/domain/models/profile_overview.dart';
import 'package:my_first_app/features/profile/domain/models/salary_slip_item.dart';

class ProfileProvider with ChangeNotifier {
  ProfileProvider({required ProfileRepository repository})
    : _repository = repository;

  final ProfileRepository _repository;

  ProfileOverview? _overview;
  List<SalarySlipItem> _salarySlips = <SalarySlipItem>[];
  List<BadgeItem> _badges = <BadgeItem>[];
  AccountSecurityData? _accountSecurity;
  GeneralSettingsData? _settings;
  bool _overviewLoading = false;
  bool _salarySlipsLoading = false;
  bool _badgesLoading = false;
  bool _accountSecurityLoading = false;
  bool _settingsLoading = false;
  bool _feedbackSubmitting = false;
  String? _overviewError;
  String? _salarySlipsError;
  String? _badgesError;
  String? _accountSecurityError;
  String? _settingsError;
  String? _feedbackError;

  ProfileOverview? get overview => _overview;
  List<SalarySlipItem> get salarySlips =>
      List<SalarySlipItem>.unmodifiable(_salarySlips);
  List<BadgeItem> get badges => List<BadgeItem>.unmodifiable(_badges);
  AccountSecurityData? get accountSecurity => _accountSecurity;
  GeneralSettingsData? get settings => _settings;
  bool get overviewLoading => _overviewLoading;
  bool get salarySlipsLoading => _salarySlipsLoading;
  bool get badgesLoading => _badgesLoading;
  bool get accountSecurityLoading => _accountSecurityLoading;
  bool get settingsLoading => _settingsLoading;
  bool get feedbackSubmitting => _feedbackSubmitting;
  String? get overviewError => _overviewError;
  String? get salarySlipsError => _salarySlipsError;
  String? get badgesError => _badgesError;
  String? get accountSecurityError => _accountSecurityError;
  String? get settingsError => _settingsError;
  String? get feedbackError => _feedbackError;

  void handleSessionChanged(bool authenticated) {
    if (authenticated) {
      return;
    }
    _overview = null;
    _salarySlips = <SalarySlipItem>[];
    _badges = <BadgeItem>[];
    _accountSecurity = null;
    _settings = null;
    _overviewError = null;
    _salarySlipsError = null;
    _badgesError = null;
    _accountSecurityError = null;
    _settingsError = null;
    _feedbackError = null;
    notifyListeners();
  }

  Future<void> loadOverview() async {
    _overviewLoading = true;
    _overviewError = null;
    notifyListeners();
    try {
      _overview = await _repository.fetchOverview();
    } on ApiException catch (error) {
      _overviewError = error.message;
    } finally {
      _overviewLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSalarySlips() async {
    _salarySlipsLoading = true;
    _salarySlipsError = null;
    notifyListeners();
    try {
      _salarySlips = await _repository.fetchSalarySlips();
    } on ApiException catch (error) {
      _salarySlipsError = error.message;
    } finally {
      _salarySlipsLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadBadges() async {
    _badgesLoading = true;
    _badgesError = null;
    notifyListeners();
    try {
      _badges = await _repository.fetchBadges();
    } on ApiException catch (error) {
      _badgesError = error.message;
    } finally {
      _badgesLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAccountSecurity() async {
    _accountSecurityLoading = true;
    _accountSecurityError = null;
    notifyListeners();
    try {
      _accountSecurity = await _repository.fetchAccountSecurity();
    } on ApiException catch (error) {
      _accountSecurityError = error.message;
    } finally {
      _accountSecurityLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSettings() async {
    _settingsLoading = true;
    _settingsError = null;
    notifyListeners();
    try {
      _settings = await _repository.fetchSettings();
    } on ApiException catch (error) {
      _settingsError = error.message;
    } finally {
      _settingsLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSettings(GeneralSettingsData nextSettings) async {
    _settingsLoading = true;
    _settingsError = null;
    notifyListeners();
    try {
      _settings = await _repository.updateSettings(nextSettings);
    } on ApiException catch (error) {
      _settingsError = error.message;
    } finally {
      _settingsLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitFeedback({
    required String category,
    required String content,
  }) async {
    _feedbackSubmitting = true;
    _feedbackError = null;
    notifyListeners();
    try {
      await _repository.submitFeedback(category: category, content: content);
      return true;
    } on ApiException catch (error) {
      _feedbackError = error.message;
      return false;
    } finally {
      _feedbackSubmitting = false;
      notifyListeners();
    }
  }
}
