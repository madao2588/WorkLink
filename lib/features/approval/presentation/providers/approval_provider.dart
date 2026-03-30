import 'dart:async';

import 'package:flutter/material.dart';

import 'package:my_first_app/app/shared/network/api_client.dart';
import 'package:my_first_app/features/approval/domain/models/approval_model.dart';
import 'package:my_first_app/features/approval/domain/repositories/approval_repository.dart';

class ApprovalProvider with ChangeNotifier {
  ApprovalProvider({required ApprovalRepository repository})
      : _repository = repository;

  final ApprovalRepository _repository;
  bool _isLoading = false;
  String? _errorMessage;

  List<ApprovalModel> get approvals => _repository.getApprovals();
  int get pendingCount => _repository.pendingCount;
  int get approvedCount => _repository.approvedCount;
  int get rejectedCount => _repository.rejectedCount;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void handleSessionChanged(bool authenticated) {
    if (authenticated) {
      unawaited(loadApprovals());
      return;
    }
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> loadApprovals() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.loadApprovals();
    } on ApiException catch (error) {
      _errorMessage = error.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitLeave(String reason) async {
    await _repository.submitLeave(reason);
    notifyListeners();
  }

  Future<void> approve(String id) async {
    await _repository.approve(id);
    notifyListeners();
  }

  Future<void> reject(String id) async {
    await _repository.reject(id);
    notifyListeners();
  }
}
