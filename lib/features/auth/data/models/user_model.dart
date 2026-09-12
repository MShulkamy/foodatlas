import 'package:firebase_auth/firebase_auth.dart';

/// App-level user model, decoupled from [User] (Firebase) so the rest
/// of the app never depends directly on the Firebase SDK types.
class UserModel {
  const UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.photoUrl,
  });

  final String uid;
  final String email;
  final String name;
  final String? photoUrl;

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: (user.displayName == null || user.displayName!.isEmpty)
          ? (user.email?.split('@').first ?? 'مستخدم')
          : user.displayName!,
      photoUrl: user.photoURL,
    );
  }
}
