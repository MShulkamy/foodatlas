class AppConstants {
  AppConstants._();

  // Fake API (dummyjson.com) - used for the Home / Recipes feature.
  static const String baseUrl = 'https://dummyjson.com';
  static const String recipesEndpoint = '/recipes';
  static const String recipeSearchEndpoint = '/recipes/search';
  static const String recipeTagsEndpoint = '/recipes/tags';

  // Local storage keys
  static const String keyThemeMode = 'key_theme_mode';
  static const String keyFavorites = 'key_favorites';
  static const String keyCart = 'key_cart';
  static const String keyOnboardingSeen = 'key_onboarding_seen';
  static const String keyCachedUserName = 'key_cached_user_name';
  static const String keyCachedUserEmail = 'key_cached_user_email';

  // Misc
  static const Duration splashDuration = Duration(seconds: 3);
}
