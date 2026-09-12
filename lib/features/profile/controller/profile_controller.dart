import 'package:flutter/material.dart';
import '../../auth/controller/auth_controller.dart';

/// Controller (MVC) for the Profile screen. Mostly delegates auth
/// actions while exposing user info convenience getters.
class ProfileController extends ChangeNotifier {
  ProfileController(this._authController);
  final AuthController _authController;

  String get name => _authController.currentUser?.name ?? 'مستخدم';
  String get email => _authController.currentUser?.email ?? '';
  String? get photoUrl => _authController.currentUser?.photoUrl;

  Future<void> logout() => _authController.logout();
}
