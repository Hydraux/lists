import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/models/recipe.dart';

class StepsController {
  GetStorage storageList = GetStorage();
  RxList<String> steps = RxList<String>([]);
  int get length => steps.length;

  Future<void> addStep(context, Recipe recipe) async {
    String? step = await Get.toNamed('/RecipeList/Recipe/newStep');
    if (step == null) return; //cancel was pressed

    updateStep(recipe, length, step);
  }

  void updateStep(Recipe recipe, int index, String step) {
    steps[index] = step;

    storageList.write('steps:${recipe.uniqueID}', steps);
  }

  void removeStep(String step) {
    steps.remove(step);

    storageList.write('steps:${recipe.uniqueID}', steps);
  }

  void restoreSteps() {
    if (storageList.hasData('steps:${recipe.uniqueID}')) {
      var tempStepsList = storageList.read('steps:${recipe.uniqueID}');
      for (String step in tempStepsList) steps.add(step);
    }
  }
}
