/// Recipe model mapped from the fake API (dummyjson.com/recipes).
class RecipeModel {
  const RecipeModel({
    required this.id,
    required this.name,
    required this.image,
    required this.ingredients,
    required this.instructions,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    required this.difficulty,
    required this.cuisine,
    required this.caloriesPerServing,
    required this.tags,
    required this.rating,
    required this.reviewCount,
    required this.mealType,
  });

  final int id;
  final String name;
  final String image;
  final List<String> ingredients;
  final List<String> instructions;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final String difficulty;
  final String cuisine;
  final num caloriesPerServing;
  final List<String> tags;
  final double rating;
  final int reviewCount;
  final List<String> mealType;

  int get totalTimeMinutes => prepTimeMinutes + cookTimeMinutes;

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? const []),
      instructions: List<String>.from(json['instructions'] ?? const []),
      prepTimeMinutes: json['prepTimeMinutes'] as int? ?? 0,
      cookTimeMinutes: json['cookTimeMinutes'] as int? ?? 0,
      servings: json['servings'] as int? ?? 1,
      difficulty: json['difficulty'] as String? ?? 'Easy',
      cuisine: json['cuisine'] as String? ?? '',
      caloriesPerServing: json['caloriesPerServing'] as num? ?? 0,
      tags: List<String>.from(json['tags'] ?? const []),
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      mealType: List<String>.from(json['mealType'] ?? const []),
    );
  }
}
