import '../../domain/repositories/recipe_repository.dart';
import '../datasources/recipe_remote_datasource.dart';
import '../models/recipe_model.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  RecipeRepositoryImpl(this._remote);
  final RecipeRemoteDataSource _remote;

  @override
  Future<List<RecipeModel>> getAllRecipes({int limit = 30, int skip = 0}) {
    return _remote.getAllRecipes(limit: limit, skip: skip);
  }

  @override
  Future<List<RecipeModel>> searchRecipes(String query) {
    return _remote.searchRecipes(query);
  }

  @override
  Future<List<String>> getTags() {
    return _remote.getTags();
  }

  @override
  Future<RecipeModel> getRecipeById(int id) {
    return _remote.getRecipeById(id);
  }
}
