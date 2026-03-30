import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:my_first_app/app/shared/network/api_client.dart';

class AttendanceProvider with ChangeNotifier {
  AttendanceProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  String _checkInTime = 'Not checked in';
  String _statusCode = 'NOT_CHECKED_IN';
  bool _hasCheckedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get hasCheckedIn => _hasCheckedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get status {
    switch (_statusCode) {
      case 'CHECKED_IN':
        return '已打卡';
      case 'LATE':
        return '迟到';
      case 'ABSENT':
        return '缺卡';
      default:
        return '未打卡';
    }
  }

  String get time => _checkInTime;

  void handleSessionChanged(bool authenticated) {
    if (authenticated) {
      unawaited(loadToday());
      return;
    }
    _checkInTime = 'Not checked in';
    _statusCode = 'NOT_CHECKED_IN';
    _hasCheckedIn = false;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> loadToday() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final dynamic data = await _apiClient.get('/attendance/today');
      _statusCode = data['status'] as String? ?? 'NOT_CHECKED_IN';
      final String? checkInTime = data['checkInTime'] as String?;
      _hasCheckedIn = data['hasCheckedIn'] as bool? ?? false;
      _checkInTime = checkInTime == null
          ? 'Not checked in'
          : DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(checkInTime).toLocal());
    } on ApiException catch (error) {
      _errorMessage = error.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkIn() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final dynamic data = await _apiClient.post(
        '/attendance/check-in',
        body: <String, dynamic>{'deviceId': 'flutter-desktop'},
      );
      _statusCode = data['status'] as String? ?? 'CHECKED_IN';
      final String? checkInTime = data['checkInTime'] as String?;
      _hasCheckedIn = data['hasCheckedIn'] as bool? ?? true;
      _checkInTime = checkInTime == null
          ? DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())
          : DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(checkInTime).toLocal());
    } on ApiException catch (error) {
      _errorMessage = error.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
