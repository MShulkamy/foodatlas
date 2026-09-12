import '../../data/models/user_model.dart';

/// Domain-level contract. The presentation layer (controllers) only
/// depends on this abstraction, never on Firebase directly.
abstract class AuthRepository {
  Stream<UserModel?> get authStateChanges;

  UserModel? get currentUser;

  Future<UserModel> login({required String email, required String password});

  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String password,
  });

  Future<void> resetPassword(String email);

  Future<void> logout();
}
