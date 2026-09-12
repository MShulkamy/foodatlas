import 'package:flutter/material.dart';
import '../../../core/services/local_storage_service.dart';
import '../../home/data/models/recipe_model.dart';

/// Controller (MVC) that manages the favorite recipe ids and persists
/// them locally via [LocalStorageService].
class FavoritesController extends ChangeNotifier {
  FavoritesController(this._localStorage) {
    _favoriteIds = _localStorage.getFavoriteIds().toSet();
  }

  final LocalStorageService _localStorage;
  late Set<int> _favoriteIds;

  Set<int> get favoriteIds => _favoriteIds;

  bool isFavorite(int recipeId) => _favoriteIds.contains(recipeId);

  Future<void> toggleFavorite(int recipeId) async {
    if (_favoriteIds.contains(recipeId)) {
      _favoriteIds.remove(recipeId);
    } else {
      _favoriteIds.add(recipeId);
    }
    notifyListeners();
    await _localStorage.saveFavoriteIds(_favoriteIds.toList());
  }

  List<RecipeModel> filterFavorites(List<RecipeModel> allRecipes) {
    return allRecipes.where((r) => _favoriteIds.contains(r.id)).toList();
  }
}
