import 'package:flutter/material.dart';
import '../data/models/recipe_model.dart';
import '../domain/repositories/recipe_repository.dart';

enum ViewState { initial, loading, loaded, error }

/// Controller (MVC) for the Home feature: loads recipes + tags from the
/// fake API and exposes category-filtered lists to the view.
class HomeController extends ChangeNotifier {
  HomeController(this._repository) {
    loadHome();
  }

  final RecipeRepository _repository;

  ViewState state = ViewState.initial;
  String? errorMessage;

  List<RecipeModel> _allRecipes = [];
  List<String> tags = [];
  String selectedTag = 'الكل';

  List<RecipeModel> get recipesAll => _allRecipes;

  List<RecipeModel> get recipes {
    if (selectedTag == 'الكل') return _allRecipes;
    return _allRecipes
        .where((r) => r.tags.any((t) => t.toLowerCase() == selectedTag.toLowerCase()))
        .toList();
  }

  List<RecipeModel> get trending {
    final sorted = [..._allRecipes]..sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(8).toList();
  }

  Future<void> loadHome() async {
    state = ViewState.loading;
    notifyListeners();
    try {
      final results = await Future.wait([
        _repository.getAllRecipes(limit: 40),
        _repository.getTags(),
      ]);
      _allRecipes = results[0] as List<RecipeModel>;
      final fetchedTags = results[1] as List<String>;
      tags = ['الكل', ...fetchedTags.take(10)];
      state = ViewState.loaded;
    } catch (e) {
      errorMessage = e.toString();
      state = ViewState.error;
    }
    notifyListeners();
  }

  void selectTag(String tag) {
    selectedTag = tag;
    notifyListeners();
  }

  Future<void> refresh() => loadHome();
}
