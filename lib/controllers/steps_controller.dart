import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/views/step_form.dart';

class StepsController extends GetxController {
  Recipe recipe;
  DatabaseReference database;
  final RecipesController controller = Get.find<RecipesController>();

  StepsController({required this.recipe, required this.database});

  Future<List<String>> extractJson(DataSnapshot snapshot) async {
    // Get data from DB
    List<String> steps = [];
    //convert to map
    if (snapshot.value != null) {
      Map map = snapshot.value as Map;

      // Convert to list
      List list = map.values.toList();

      list.forEach((element) {
        steps.add(element.toString());
      });
    }

    return steps;
  }

  void addStep() async {
    List<String> temp = [];
    if (recipe.steps != null) temp = recipe.steps!;
    String? step = await Get.dialog(StepForm());
    if (step == null) return; //cancel was pressed
    temp.add(step);
    recipe.copyWith(steps: temp);
    database.set(recipe.steps);
  }

  void removeStep(String step) async {
    List<String> temp = [];
    if (recipe.steps != null) temp = recipe.steps!;
    temp.remove(step);
    recipe.copyWith(steps: temp);
    database.set(recipe.steps);
  }

  void modifyStep(String step, int index) async {
    DataSnapshot snapshot = await database.get();
    List steps = snapshot.value as List;
    String? temp = await Get.dialog(StepForm(
      step: step,
      index: index,
    ));

    if (temp == null) return; // cancel was pressed
    steps[index] = temp;
    database.set(steps);
  }
}
