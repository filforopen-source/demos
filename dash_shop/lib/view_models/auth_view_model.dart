import 'package:flutter/material.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  bool _isLoading = false;
  String? _error;

  AuthViewModel(this._authRepository) {
    _init();
  }

  User? get user => _authRepository.currentUser;
  bool get isAuthenticated => _authRepository.isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> _init() async {
    _setLoading(true);
    await _authRepository.checkAuthStatus();
    _setLoading(false);
  }

  Future<void> signIn(String name, String email) async {
    _setLoading(true);
    try {
      await _authRepository.signIn(name, email);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void signOut() {
    _authRepository.signOut();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
