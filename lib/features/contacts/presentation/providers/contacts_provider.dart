import 'dart:async';

import 'package:flutter/material.dart';

import 'package:my_first_app/app/shared/models/user_model.dart';
import 'package:my_first_app/app/shared/network/api_client.dart';

class ContactsProvider with ChangeNotifier {
  ContactsProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;
  List<UserModel> _contacts = <UserModel>[];
  bool _isLoading = false;
  String? _errorMessage;

  List<UserModel> get contacts => List<UserModel>.unmodifiable(_contacts);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void handleSessionChanged(bool authenticated) {
    if (authenticated) {
      unawaited(loadContacts());
      return;
    }
    _contacts = <UserModel>[];
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> loadContacts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final dynamic data = await _apiClient.get('/org/contacts');
      final List<dynamic> items = (data['items'] as List<dynamic>? ?? <dynamic>[]);
      _contacts = items.map((dynamic item) {
        final Map<String, dynamic> json = item as Map<String, dynamic>;
        return UserModel(
          id: json['id'] as String,
          name: json['name'] as String,
          avatar: json['avatar'] as String,
          department: json['department'] as String,
          isOnline: json['isOnline'] as bool? ?? false,
        );
      }).toList();
    } on ApiException catch (error) {
      _errorMessage = error.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
