import 'package:get/get.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/views/step_form.dart';

class StepsController extends GetxController {
  Recipe recipe;
  List<String> steps = [];
  final RecipesController controller = Get.find<RecipesController>();

  StepsController({required this.recipe});

  void addStep() async {
    if (recipe.steps != null) steps = recipe.steps!;
    String? step = await Get.dialog(StepForm());

    if (step == null) return; //cancel was pressed
    steps.add(step);
    updateStorage();
  }

  void removeStep(String step) {
    recipe.steps!.remove(step);

    updateStorage();
  }

  void modifyStep(String step, int index) {
    List<String> temp = recipe.steps!;
    temp[index] = step;
    recipe.copyWith(steps: temp);
    updateStorage();
  }

  updateStorage() {
    controller.updateStorage(recipe);
  }
}
