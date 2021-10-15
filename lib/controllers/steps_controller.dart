import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/models/recipe.dart';

class StepsController {
  GetStorage storageList = GetStorage();

  Future<void> addStep(context, Recipe recipe) async {
    String? step = await Get.toNamed('/RecipeList/Recipe/newStep');
    if (step == null) return; //cancel was pressed

    updateStep(recipe, length, step);
  }

  void updateStep(Recipe recipe, int index, String step) {
    steps[index] = step;

    storageList.write('steps:${recipe.id}', steps);
  }

  void removeStep(String step) {
    steps.remove(step);

    storageList.write('steps:${recipe.id}', steps);
  }

  void restoreSteps() {
    if (storageList.hasData('steps:${recipe.id}')) {
      var tempStepsList = storageList.read('steps:${recipe.id}');
      for (String step in tempStepsList) steps.add(step);
    }
  }
}
