import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/recipes/recipes_controller.dart';
import 'package:lists/widgets/recipe/ingredient_card.dart';
import 'package:lists/models/recipes/recipe.dart';

class IngredientList extends StatelessWidget {
  const IngredientList({
    required this.recipe,
    required this.controller,
  });

  final Recipe recipe;
  final RecipesController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 3,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ingredients: ',
                style: TextStyle(fontSize: 20),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return IngredientCard(
                    index: index,
                    item: recipe.Ingredients[index],
                    listType: 'Ingredients List',
                    recipe: recipe,
                  );
                },
                itemCount: recipe.IngredientsLength,
              ),
              if (recipe.editMode.value)
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        recipe.controller!.addIngredient(context, recipe);
                      },
                      child: Icon(Icons.add),
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
