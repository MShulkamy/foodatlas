import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

/// Thin wrapper around [FirebaseAuth]. Kept separate from the
/// [AuthRepository] so the data layer stays swappable/testable.
class FirebaseAuthService {
  FirebaseAuthService({FirebaseAuth? firebaseAuth, bool isAvailable = true})
      : _firebaseAuth = firebaseAuth ??
            (Firebase.apps.isEmpty ? null : FirebaseAuth.instance),
        _isAvailable =
            isAvailable && (firebaseAuth != null || Firebase.apps.isNotEmpty);

  final FirebaseAuth? _firebaseAuth;
  final bool _isAvailable;

  FirebaseAuth get _auth {
    final auth = _firebaseAuth;
    if (!_isAvailable || auth == null) {
      throw FirebaseAuthException(
        code: 'firebase-not-configured',
        message: 'Firebase is not configured for this app.',
      );
    }
    return auth;
  }

  Stream<User?> get authStateChanges =>
      _firebaseAuth?.authStateChanges() ?? Stream<User?>.value(null);

  User? get currentUser => _firebaseAuth?.currentUser;

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await credential.user?.updateDisplayName(fullName);
    await credential.user?.reload();
    return credential;
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() => _auth.signOut();

  /// Maps Firebase error codes to friendly Arabic messages.
  String mapErrorCode(Object error) {
    if (error is TimeoutException) {
      return 'الاتصال استغرق وقتا طويلا. تحقق من الإنترنت وحاول مرة أخرى';
    }
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'firebase-not-configured':
        case 'no-app':
          return 'Firebase غير متصل بالتطبيق. تأكد من إعداد google-services.json وتفعيل Email/Password من Firebase Console';
        case 'invalid-email':
          return 'البريد الإلكتروني غير صالح';
        case 'user-disabled':
          return 'تم تعطيل هذا الحساب';
        case 'user-not-found':
          return 'لا يوجد حساب بهذا البريد الإلكتروني';
        case 'wrong-password':
        case 'invalid-credential':
          return 'كلمة المرور غير صحيحة';
        case 'email-already-in-use':
          return 'هذا البريد الإلكتروني مستخدم بالفعل';
        case 'weak-password':
          return 'كلمة المرور ضعيفة جدًا';
        case 'network-request-failed':
          return 'تحقق من اتصالك بالإنترنت';
        case 'too-many-requests':
          return 'محاولات كثيرة، حاول لاحقًا';
        default:
          return error.message ?? 'حدث خطأ غير متوقع';
      }
    }
    return error.toString();
  }
}
