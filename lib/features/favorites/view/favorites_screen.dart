import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/state_widgets.dart';
import '../../home/controller/home_controller.dart';
import '../../home/widgets/recipe_card.dart';
import '../controller/favorites_controller.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favController = context.watch<FavoritesController>();
    final homeController = context.watch<HomeController>();
    final favorites = favController.filterFavorites(homeController.recipesAll);

    return Scaffold(
      appBar: AppBar(title: const Text('المفضلة')),
      body: SafeArea(
        child: favorites.isEmpty
            ? const AppEmptyView(
                message: 'لا توجد وصفات مفضلة بعد',
                icon: Icons.favorite_border_rounded,
                subtitle: 'اضغط على أيقونة القلب لإضافة وصفاتك المفضلة',
              )
            : GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
                itemCount: favorites.length,
                itemBuilder: (_, i) => RecipeCard(recipe: favorites[i]),
              ),
      ),
    );
  }
}
