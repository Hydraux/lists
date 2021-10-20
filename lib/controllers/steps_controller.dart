import 'package:get/get.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/views/step_form.dart';

class StepsController extends GetxController {
  final Recipe recipe;
  final RecipesController controller;
  StepsController({required this.recipe, required this.controller});

  void addStep(Recipe recipe) async {
    List<String> steps = recipe.steps ?? [];
    String? step = await Get.dialog(StepForm());

    if (step == null) return; //cancel was pressed

    final Recipe temp = recipe.copyWith(steps: steps);
    controller.updateStorage(temp);
  }

  void removeStep(Recipe recipe, String step) {
    recipe.steps!.remove(step);

    controller.updateStorage(recipe);
  }

  void modifyStep(Recipe recipe, String step, int index) {
    recipe.steps![index] = step;
    controller.updateStorage(recipe);
  }
}
