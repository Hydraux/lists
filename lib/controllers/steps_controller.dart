import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/views/step_form.dart';

class StepsController extends GetxController {
  Recipe recipe;
  DatabaseReference database;
  final RecipesController controller = Get.find<RecipesController>();
  final RxList<String> steps = RxList();

  StepsController({required this.recipe, required this.database});

  @override
  void onInit() {
    _activateListeners();
    super.onInit();
  }

  void _activateListeners() {
    database.onChildAdded.listen((event) {
      String step = event.snapshot.value as String;
      steps.add(step);
    });
  }

  void addStep() async {
    String? step = await Get.dialog(StepForm());
    if (step == null) return; //cancel was pressed

    database.child(steps.length.toString()).set(step);
  }

  void removeStep(String step) async {
    List<String> temp = List.from(steps);

    temp.remove(step);
    steps.value = List.from(temp);
    database.set(steps);
  }

  void modifyStep(String step) async {
    int index = steps.indexOf(step);
    String? temp = await Get.dialog(StepForm(
      step: step,
    ));

    if (temp == null) return; // cancel was pressed
    steps[index] = temp;
    database.set(steps);
  }

  reorder(int oldIndex, int newIndex) {
    List<String> temp = List.from(steps);
    if (oldIndex < newIndex) newIndex--;
    String step = temp.removeAt(oldIndex);
    temp.insert(newIndex, step);
    steps.value = List.from(temp);
    database.set(steps);
  }
}
