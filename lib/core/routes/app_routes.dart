import 'package:flutter/material.dart';
import '../../features/auth/view/forgot_password_screen.dart';
import '../../features/auth/view/login_screen.dart';
import '../../features/auth/view/signup_screen.dart';
import '../../features/home/view/home_screen.dart';
import '../../features/home/view/recipe_details_screen.dart';
import '../../features/home/data/models/recipe_model.dart';
import '../../features/splash/view/splash_screen.dart';
import '../../features/cart/view/cart_screen.dart';
import '../../features/favorites/view/favorites_screen.dart';
import '../../features/profile/view/profile_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String recipeDetails = '/recipe-details';
  static const String cart = '/cart';
  static const String favorites = '/favorites';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashScreen(),
        login: (_) => const LoginScreen(),
        signUp: (_) => const SignUpScreen(),
        forgotPassword: (_) => const ForgotPasswordScreen(),
        home: (_) => const HomeScreen(),
        cart: (_) => const CartScreen(),
        favorites: (_) => const FavoritesScreen(),
        profile: (_) => const ProfileScreen(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == recipeDetails) {
      final recipe = settings.arguments as RecipeModel;
      return MaterialPageRoute(builder: (_) => RecipeDetailsScreen(recipe: recipe));
    }
    return null;
  }
}
