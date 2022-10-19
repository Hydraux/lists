import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/steps_controller.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/themes/proxy_decorator.dart';
import 'package:lists/widgets/step_card.dart';

class StepList extends StatelessWidget {
  const StepList({required this.recipe, required this.user});
  final Recipe recipe;
  final String user;

  @override
  Widget build(BuildContext context) {
    StepsController ssc = Get.find<StepsController>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => ReorderableListView(
                  proxyDecorator: proxyDecorator,
                  shrinkWrap: true,
                  children: ssc.steps.map((step) => StepCard(step: step, user: user)).toList(),
                  onReorder: (oldIndex, newIndex) => ssc.reorder(oldIndex, newIndex),
                ),
              ),
              if (recipe.editMode.value)
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ssc.addStep();
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
