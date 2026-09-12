import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/recipe_model.dart';

/// Talks directly to the fake API (dummyjson.com/recipes).
class RecipeRemoteDataSource {
  RecipeRemoteDataSource(this._client);
  final ApiClient _client;

  Future<List<RecipeModel>> getAllRecipes({int limit = 30, int skip = 0}) async {
    try {
      final response = await _client.get(
        AppConstants.recipesEndpoint,
        query: {'limit': limit, 'skip': skip},
      );
      final list = (response.data['recipes'] as List)
          .map((e) => RecipeModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return list;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<RecipeModel>> searchRecipes(String query) async {
    try {
      final response = await _client.get(
        AppConstants.recipeSearchEndpoint,
        query: {'q': query},
      );
      final list = (response.data['recipes'] as List)
          .map((e) => RecipeModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return list;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<String>> getTags() async {
    try {
      final response = await _client.get(AppConstants.recipeTagsEndpoint);
      return List<String>.from(response.data as List);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<RecipeModel> getRecipeById(int id) async {
    try {
      final response = await _client.get('${AppConstants.recipesEndpoint}/$id');
      return RecipeModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
