import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Thin wrapper around [SharedPreferences] so the rest of the app
/// never talks to the plugin directly (Clean Architecture boundary).
class LocalStorageService {
  LocalStorageService(this._prefs);

  final SharedPreferences _prefs;

  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  // ---------------- Theme ----------------
  String getThemeMode() => _prefs.getString(AppConstants.keyThemeMode) ?? 'light';
  Future<void> setThemeMode(String mode) => _prefs.setString(AppConstants.keyThemeMode, mode);

  // ---------------- Favorites (list of recipe ids) ----------------
  List<int> getFavoriteIds() {
    final raw = _prefs.getString(AppConstants.keyFavorites);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List;
    return decoded.map((e) => e as int).toList();
  }

  Future<void> saveFavoriteIds(List<int> ids) =>
      _prefs.setString(AppConstants.keyFavorites, jsonEncode(ids));

  // ---------------- Cart (map of recipeId -> quantity, stored as JSON) ----------------
  Map<String, dynamic> getCartRaw() {
    final raw = _prefs.getString(AppConstants.keyCart);
    if (raw == null || raw.isEmpty) return {};
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> saveCartRaw(Map<String, dynamic> cart) =>
      _prefs.setString(AppConstants.keyCart, jsonEncode(cart));

  // ---------------- Onboarding / session cache ----------------
  bool getOnboardingSeen() => _prefs.getBool(AppConstants.keyOnboardingSeen) ?? false;
  Future<void> setOnboardingSeen(bool value) => _prefs.setBool(AppConstants.keyOnboardingSeen, value);

  String? getCachedUserName() => _prefs.getString(AppConstants.keyCachedUserName);
  Future<void> setCachedUserName(String name) => _prefs.setString(AppConstants.keyCachedUserName, name);

  String? getCachedUserEmail() => _prefs.getString(AppConstants.keyCachedUserEmail);
  Future<void> setCachedUserEmail(String email) => _prefs.setString(AppConstants.keyCachedUserEmail, email);

  Future<void> clearSessionCache() async {
    await _prefs.remove(AppConstants.keyCachedUserName);
    await _prefs.remove(AppConstants.keyCachedUserEmail);
  }
}
