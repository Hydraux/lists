import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
    recipe = recipe.copyWith(steps: steps);
    updateStorage();
  }

  void removeStep(String step) {
    recipe.steps!.remove(step);

    updateStorage();
  }

  void modifyStep(String step, int index) {
    recipe.steps![index] = step;
    updateStorage();
  }

  updateStorage() {
    controller.getStorage.write(recipe.id + ':steps', recipe.steps);
    controller.updateStorage(recipe);
  }
}
