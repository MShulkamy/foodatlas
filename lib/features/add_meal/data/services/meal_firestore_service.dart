import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class MealFirestoreService {
  MealFirestoreService({FirebaseFirestore? firestore, bool isAvailable = true})
      : _firestore = firestore ??
            (Firebase.apps.isEmpty ? null : FirebaseFirestore.instance),
        _isAvailable =
            isAvailable && (firestore != null || Firebase.apps.isNotEmpty);

  final FirebaseFirestore? _firestore;
  final bool _isAvailable;

  FirebaseFirestore get _db {
    final firestore = _firestore;
    if (!_isAvailable || firestore == null) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'firebase-not-configured',
        message: 'Firebase is not configured for this app.',
      );
    }
    return firestore;
  }

  Future<void> addMeal({
    required String name,
    required String description,
    required String category,
    required String ingredients,
    required String instructions,
    required int minutes,
    required int calories,
    required int servings,
    required String difficulty,
    required String userId,
    required String userEmail,
  }) {
    return _db.collection('meals').add({
      'name': name.trim(),
      'description': description.trim(),
      'category': category.trim(),
      'ingredients': ingredients
          .split('\n')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList(),
      'instructions': instructions.trim(),
      'minutes': minutes,
      'calories': calories,
      'servings': servings,
      'difficulty': difficulty,
      'createdBy': userId,
      'createdByEmail': userEmail,
      'createdAt': FieldValue.serverTimestamp(),
    }).timeout(const Duration(seconds: 20));
  }

  String mapError(Object error) {
    if (error is TimeoutException) {
      return 'الاتصال استغرق وقتا طويلا. تحقق من الإنترنت وحاول مرة أخرى';
    }
    if (error is FirebaseException) {
      if (error.code == 'firebase-not-configured' ||
          error.code == 'unavailable') {
        return 'Firebase غير متصل بالتطبيق أو الخدمة غير متاحة حاليا';
      }
      if (error.code == 'permission-denied') {
        return 'لا توجد صلاحية لإضافة الأكلة. راجع Firestore Rules';
      }
      return error.message ?? 'حدث خطأ أثناء حفظ الأكلة';
    }
    return 'حدث خطأ أثناء حفظ الأكلة';
  }
}
