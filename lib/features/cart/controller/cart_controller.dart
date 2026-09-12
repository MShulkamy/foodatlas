import 'package:flutter/material.dart';
import '../../../core/services/local_storage_service.dart';
import '../../home/data/models/recipe_model.dart';
import '../data/models/cart_item_model.dart';

/// Controller (MVC) for the Shopping Cart. Keeps recipeId -> quantity
/// persisted locally, and resolves full [RecipeModel] data on demand.
class CartController extends ChangeNotifier {
  CartController(this._localStorage) {
    _quantities = _localStorage.getCartRaw().map((k, v) => MapEntry(int.parse(k), v as int));
  }

  final LocalStorageService _localStorage;
  late Map<int, int> _quantities;
  final Map<int, RecipeModel> _recipeCache = {};

  Map<int, int> get quantities => _quantities;

  int get itemCount => _quantities.values.fold(0, (a, b) => a + b);

  List<CartItemModel> get items {
    return _quantities.entries
        .where((e) => _recipeCache.containsKey(e.key))
        .map((e) => CartItemModel(recipe: _recipeCache[e.key]!, quantity: e.value))
        .toList();
  }

  double get totalPrice => items.fold(0, (sum, item) => sum + item.estimatedPrice);

  /// Call this whenever recipes are loaded so the cart can resolve item details.
  void cacheRecipes(List<RecipeModel> recipes) {
    for (final r in recipes) {
      _recipeCache[r.id] = r;
    }
    notifyListeners();
  }

  Future<void> addToCart(RecipeModel recipe) async {
    _recipeCache[recipe.id] = recipe;
    _quantities[recipe.id] = (_quantities[recipe.id] ?? 0) + 1;
    notifyListeners();
    await _persist();
  }

  Future<void> incrementQuantity(int recipeId) async {
    _quantities[recipeId] = (_quantities[recipeId] ?? 0) + 1;
    notifyListeners();
    await _persist();
  }

  Future<void> decrementQuantity(int recipeId) async {
    final current = _quantities[recipeId] ?? 0;
    if (current <= 1) {
      _quantities.remove(recipeId);
    } else {
      _quantities[recipeId] = current - 1;
    }
    notifyListeners();
    await _persist();
  }

  Future<void> removeFromCart(int recipeId) async {
    _quantities.remove(recipeId);
    notifyListeners();
    await _persist();
  }

  Future<void> clearCart() async {
    _quantities.clear();
    notifyListeners();
    await _persist();
  }

  bool isInCart(int recipeId) => _quantities.containsKey(recipeId);

  Future<void> _persist() async {
    final raw = _quantities.map((k, v) => MapEntry(k.toString(), v));
    await _localStorage.saveCartRaw(raw);
  }
}
