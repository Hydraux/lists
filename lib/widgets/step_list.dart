import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/controllers/steps_controller.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/widgets/step_card.dart';

class StepList extends StatelessWidget {
  const StepList({required this.recipe});
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    StepsController ssc = Get.find<StepsController>(tag: recipe.id);
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
                itemCount: recipe.steps == null ? 0 : recipe.steps!.length,
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
                        ssc.addStep(recipe);
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
