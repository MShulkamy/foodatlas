import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

/// Controller (MVC) responsible for the app's ThemeMode.
/// Persists the user's choice using [LocalStorageService].
class ThemeController extends ChangeNotifier {
  ThemeController(this._localStorage) {
    _loadTheme();
  }

  final LocalStorageService _localStorage;

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void _loadTheme() {
    final saved = _localStorage.getThemeMode();
    _themeMode = saved == 'dark' ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    await _localStorage.setThemeMode(isDark ? 'dark' : 'light');
  }
}
