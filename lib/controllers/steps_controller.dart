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

    database.onChildChanged.listen(((event) {
      String databaseStep = event.snapshot.value as String;
      //int index = steps.indexWhere((step) => step == databaseStep);
      steps[int.parse(event.snapshot.key!)] = databaseStep;
    }));

    database.onChildRemoved.listen((event) {
      String step = event.snapshot.value as String;
      steps.remove(step);
    });
  }

  void addStep() async {
    String? step = await Get.dialog(StepForm());
    if (step == null) return; //cancel was pressed

    database.child(steps.length.toString()).set(step);
  }

  void removeStep(String step) async {
    int index = steps.indexOf(step);

    database.child(index.toString()).remove();
  }

  void modifyStep(String step) async {
    int index = steps.indexOf(step);

    String temp = await Get.dialog(StepForm(
      step: step,
      index: index,
    ));

    if (temp != '') {
      step = temp;
    }
    database.child(index.toString()).set(step);
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
