import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'firebase_options.dart';

import 'core/network/api_client.dart';
import 'core/services/firebase_auth_service.dart';
import 'core/services/local_storage_service.dart';
import 'core/theme/theme_controller.dart';

import 'features/auth/controller/auth_controller.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';

import 'features/add_meal/controller/add_meal_controller.dart';
import 'features/add_meal/data/services/meal_firestore_service.dart';
import 'features/home/controller/home_controller.dart';
import 'features/home/data/datasources/recipe_remote_datasource.dart';
import 'features/home/data/repositories/recipe_repository_impl.dart';
import 'features/home/domain/repositories/recipe_repository.dart';

import 'features/favorites/controller/favorites_controller.dart';
import 'features/cart/controller/cart_controller.dart';
import 'features/profile/controller/profile_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var firebaseReady = false;
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    firebaseReady = true;
  } catch (e) {
    debugPrint('Firebase is not configured yet: $e');
  }

  final localStorage = await LocalStorageService.init();
  final apiClient = ApiClient();

  final firebaseAuthService = FirebaseAuthService(isAvailable: firebaseReady);
  final mealFirestoreService = MealFirestoreService(isAvailable: firebaseReady);
  final AuthRepository authRepository = AuthRepositoryImpl(
    authService: firebaseAuthService,
    localStorage: localStorage,
  );

  final recipeRemoteDataSource = RecipeRemoteDataSource(apiClient);
  final RecipeRepository recipeRepository =
      RecipeRepositoryImpl(recipeRemoteDataSource);

  runApp(
    MultiProvider(
      providers: [
        Provider<LocalStorageService>.value(value: localStorage),
        ChangeNotifierProvider(create: (_) => ThemeController(localStorage)),
        ChangeNotifierProvider(create: (_) => AuthController(authRepository)),
        ChangeNotifierProvider(create: (_) => HomeController(recipeRepository)),
        ChangeNotifierProxyProvider<AuthController, AddMealController>(
          create: (context) => AddMealController(
            mealService: mealFirestoreService,
            authController: context.read<AuthController>(),
          ),
          update: (context, auth, previous) =>
              previous ??
              AddMealController(
                mealService: mealFirestoreService,
                authController: auth,
              ),
        ),
        ChangeNotifierProvider(
            create: (_) => FavoritesController(localStorage)),
        ChangeNotifierProvider(create: (_) => CartController(localStorage)),
        ChangeNotifierProxyProvider<AuthController, ProfileController>(
          create: (context) =>
              ProfileController(context.read<AuthController>()),
          update: (context, auth, previous) =>
              previous ?? ProfileController(auth),
        ),
      ],
      child: const RecipeApp(),
    ),
  );
}
