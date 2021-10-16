import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/widgets/step_card.dart';

class StepList extends StatelessWidget {
  const StepList({
    required this.recipe,
    required this.controller,
  });
  final controller;
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    RecipesController rsc = Get.find<RecipesController>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: recipe.steps.length,
                itemBuilder: (context, index) => StepCard(
                  recipe: recipe,
                  index: index,
                ),
              ),
              if (recipe.editMode.value)
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        rsc.addStep(context, recipe);
                        controller.updateValue(recipe);
                      },
                      child: Icon(Icons.add),
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
