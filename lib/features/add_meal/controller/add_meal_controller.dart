import 'package:flutter/material.dart';

import '../../auth/controller/auth_controller.dart';
import '../data/services/meal_firestore_service.dart';

class AddMealController extends ChangeNotifier {
  AddMealController({
    required MealFirestoreService mealService,
    required AuthController authController,
  })  : _mealService = mealService,
        _authController = authController;

  final MealFirestoreService _mealService;
  final AuthController _authController;

  bool isLoading = false;
  String? errorMessage;

  Future<bool> addMeal({
    required String name,
    required String description,
    required String category,
    required String ingredients,
    required String instructions,
    required int minutes,
    required int calories,
    required int servings,
    required String difficulty,
  }) async {
    final user = _authController.currentUser;
    if (user == null) {
      errorMessage = 'يجب تسجيل الدخول أولا لإضافة أكلة';
      notifyListeners();
      return false;
    }

    _setLoading(true);
    try {
      await _mealService.addMeal(
        name: name,
        description: description,
        category: category,
        ingredients: ingredients,
        instructions: instructions,
        minutes: minutes,
        calories: calories,
        servings: servings,
        difficulty: difficulty,
        userId: user.uid,
        userEmail: user.email,
      );
      errorMessage = null;
      return true;
    } catch (e) {
      errorMessage = _mealService.mapError(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
