import 'package:lists/controllers/recipes_controller.dart';

class IngredientsController extends RecipesController {
  List<Widget> getListItems() => ingredients
      .asMap()
      .map((i, unit) => MapEntry(
          i,
          _buildIngredientCard(
            i,
          )))
      .values
      .toList();

  Widget _buildIngredientCard(int index) {
    return Card(
        key: Key(recipe.uniqueID),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: IngredientCard(
            item: ingredients[index], index: index, recipe: recipe));
  }

  void reorderList(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex--;
    }

    Item temp = ingredients[oldIndex];
    ingredients.removeAt(oldIndex);
    ingredients.insert(newIndex, temp);

    updateIngredient(ingredients[oldIndex]);
    updateIngredient(ingredients[newIndex]);
  }
}
