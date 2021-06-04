import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/Models/Recipe.dart';
import 'package:lists/Pages/Item.dart';
import 'package:lists/controllers/Recipes.dart';

class RecipePage extends StatelessWidget {
  final RecipesController recipesController;
  final Recipe recipe;
  RxBool _editMode = false.obs;
  RecipePage({required this.recipe, required this.recipesController});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        appBar: AppBar(
          title: Center(child: Text(recipe.name.string)),
          actions: [
            IconButton(
                onPressed: () {
                  _editMode.toggle();
                },
                color: _editMode.value ? Colors.yellow : null,
                icon: Icon(Icons.edit))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Padding(
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
                            return ItemCard(
                              index: index,
                              item: recipe.Ingredients[index],
                              editMode: _editMode.value,
                            );
                          },
                          itemCount: recipe.IngredientsLength,
                        ),
                        if (_editMode.value)
                          Center(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await recipe.controller!
                                      .addIngredient(context, recipe);
                                  recipesController.updateValue(recipe);
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
              ),
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
                        if (_editMode.value)
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
        )));
  }
}
