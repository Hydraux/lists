import 'package:flutter/material.dart';
import 'package:lists/models/recipes/recipe.dart';
import 'package:lists/widgets/recipe/step_card.dart';

class StepList extends StatelessWidget {
  const StepList({
    required this.recipe,
    required this.controller,
  });
  final controller;
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              Text(
                'Steps: ',
                style: TextStyle(fontSize: 20),
                maxLines: 2,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: recipe.StepsLength,
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
                      onPressed: () async {
                        await recipe.controller!.addStep(context, recipe);
                        controller.updateValue(recipe);
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
