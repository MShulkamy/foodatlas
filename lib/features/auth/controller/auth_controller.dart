import 'package:flutter/material.dart';
import '../data/models/user_model.dart';
import '../domain/repositories/auth_repository.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

/// Controller (MVC) for the Auth feature: Login, Sign Up, logout,
/// and exposing the current auth state to the rest of the app.
class AuthController extends ChangeNotifier {
  AuthController(this._repository) {
    final user = _repository.currentUser;
    _currentUser = user;
    status =
        user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;

    _repository.authStateChanges.listen((user) {
      _currentUser = user;
      status =
          user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
      notifyListeners();
    }, onError: (_) {
      _currentUser = null;
      status = AuthStatus.unauthenticated;
      notifyListeners();
    });
  }

  final AuthRepository _repository;

  AuthStatus status = AuthStatus.unknown;
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool isLoading = false;
  String? errorMessage;

  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    try {
      _currentUser = await _repository.login(email: email, password: password);
      errorMessage = null;
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      _currentUser = await _repository.signUp(
          fullName: fullName, email: email, password: password);
      errorMessage = null;
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    try {
      await _repository.resetPassword(email);
      errorMessage = null;
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    _currentUser = null;
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
