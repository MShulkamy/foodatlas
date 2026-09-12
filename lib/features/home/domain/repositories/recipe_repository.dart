import '../../data/models/recipe_model.dart';

abstract class RecipeRepository {
  Future<List<RecipeModel>> getAllRecipes({int limit, int skip});
  Future<List<RecipeModel>> searchRecipes(String query);
  Future<List<String>> getTags();
  Future<RecipeModel> getRecipeById(int id);
}
