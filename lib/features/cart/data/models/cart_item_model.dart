import '../../../home/data/models/recipe_model.dart';

/// Represents a recipe added to the shopping cart with its quantity.
class CartItemModel {
  CartItemModel({required this.recipe, this.quantity = 1});

  final RecipeModel recipe;
  int quantity;

  double get estimatedPrice => (recipe.caloriesPerServing / 100) * 1.5 * quantity + 3.99 * quantity;
}
