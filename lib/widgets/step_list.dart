import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/steps_controller.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/widgets/step_card.dart';

class StepList extends StatelessWidget {
  const StepList({required this.recipe});
  final Recipe recipe;

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
              StreamBuilder(
                  stream: ssc.controller.database.child('${recipe.id}/steps').onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if ((snapshot.data! as DatabaseEvent).snapshot.value != null) {
                        List<dynamic> list = (snapshot.data as DatabaseEvent).snapshot.value as List<dynamic>;
                        List<String> steps = [];
                        if (list.isNotEmpty)
                          list.forEach((element) {
                            steps.add(element);
                          });
                        recipe.copyWith(steps: steps);
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: list.length,
                          itemBuilder: (context, index) => StepCard(
                            recipe: recipe,
                            step: list[index],
                            index: index,
                          ),
                        );
                      } else {
                        return Center();
                      }
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
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
