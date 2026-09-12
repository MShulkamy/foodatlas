import 'dart:async';

import '../../../../core/services/firebase_auth_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required FirebaseAuthService authService,
    required LocalStorageService localStorage,
  })  : _authService = authService,
        _localStorage = localStorage;

  final FirebaseAuthService _authService;
  final LocalStorageService _localStorage;
  static const _authTimeout = Duration(seconds: 20);

  @override
  Stream<UserModel?> get authStateChanges => _authService.authStateChanges.map(
        (user) => user == null ? null : UserModel.fromFirebaseUser(user),
      );

  @override
  UserModel? get currentUser {
    final user = _authService.currentUser;
    return user == null ? null : UserModel.fromFirebaseUser(user);
  }

  @override
  Future<UserModel> login(
      {required String email, required String password}) async {
    try {
      final credential = await _authService
          .signInWithEmail(email: email, password: password)
          .timeout(_authTimeout);
      final user = credential.user;
      if (user == null) {
        throw Exception('لم يتم العثور على بيانات المستخدم');
      }
      final model = UserModel.fromFirebaseUser(user);
      await _cacheSession(model);
      return model;
    } catch (e) {
      throw Exception(_authService.mapErrorCode(e));
    }
  }

  @override
  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _authService
          .signUpWithEmail(
            email: email,
            password: password,
            fullName: fullName,
          )
          .timeout(_authTimeout);
      final user = credential.user;
      if (user == null) {
        throw Exception('لم يتم العثور على بيانات المستخدم');
      }
      final model = UserModel.fromFirebaseUser(user);
      await _cacheSession(model);
      return model;
    } catch (e) {
      throw Exception(_authService.mapErrorCode(e));
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email).timeout(_authTimeout);
    } catch (e) {
      throw Exception(_authService.mapErrorCode(e));
    }
  }

  @override
  Future<void> logout() async {
    await _authService.signOut();
    await _localStorage.clearSessionCache();
  }

  Future<void> _cacheSession(UserModel model) async {
    await _localStorage.setCachedUserName(model.name);
    await _localStorage.setCachedUserEmail(model.email);
  }
}
