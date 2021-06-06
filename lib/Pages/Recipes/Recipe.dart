import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/Models/Recipes/IngredientList.dart';
import 'package:lists/Models/Recipes/Recipe.dart';
import 'package:lists/controllers/Recipes/Recipes.dart';

class RecipePage extends GetView<RecipesController> {
  final Recipe recipe;

  RecipePage({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return GetX<RecipesController>(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Center(child: Text(recipe.name.string)),
          actions: [
            IconButton(
                onPressed: () {
                  recipe.editMode.toggle();
                },
                color: recipe.editMode.value ? Colors.yellow : null,
                icon: Icon(Icons.edit))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              IngredientList(recipe: recipe, controller: controller),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
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
                        Text('Steps: ', style: TextStyle(fontSize: 20)),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: recipe.StepsLength,
                          itemBuilder: (context, index) => Row(
                            children: [
                              Text('Step ${index + 1}'),
                              Text(recipe.Steps[index]),
                            ],
                          ),
                        ),
                        if (recipe.editMode.value)
                          Center(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
