import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/Models/Unit.dart';

class UnitsController extends GetxController {
  GetStorage unitsStorage = GetStorage();

  List<Unit> unitList = [];
  var tempUnitList = [].obs;
  Unit blankUnit = new Unit(name: '');
  Unit newUnit = new Unit(name: 'New...');

  var selected = ''.obs;

  @override
  onInit() {
    restoreUnits();
    unitList.add(blankUnit);
    unitList.add(newUnit);

    super.onInit();
  }

  void setSelected(String val) {
    if (val == 'New...')
      addUnit();
    else
      selected.value = val;
  }

  void addUnit() async {
    String name = await Get.toNamed('/NewUnit');

    Unit newUnit = new Unit(name: name);
    unitList.add(newUnit);
    tempUnitList.add(newUnit);
    unitsStorage.write('Units', name);
    this.selected.value = newUnit.name;
  }

  void removeUnit() {}

  void restoreUnits() {
    if (unitsStorage.hasData('Units')) {
      List<String> tempUnits = unitsStorage.read('Units');

      for (String name in tempUnits) {
        Unit newUnit = new Unit(name: name);
        unitList.add(newUnit);
      }
    }
  }
}
