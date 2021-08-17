import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/models/unit.dart';

class UnitsController extends GetxController {
  GetStorage unitsStorage = GetStorage();

  List<Unit> unitList = [];
  var tempUnitList = [].obs;
  Unit blankUnit = new Unit(name: '', UID: 'blankUnit');
  Unit newUnit = new Unit(name: 'New...', UID: 'newUnit');

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
    final storageMap = {};
    final nameKey = 'name';
    final UIDKey = 'UID';

    Unit newUnit = new Unit(name: name, UID: DateTime.now().toString());
    unitList.add(newUnit);

    storageMap[nameKey] = newUnit.name;
    storageMap[UIDKey] = newUnit.UID;

    tempUnitList.add(storageMap);
    unitsStorage.write('Units', tempUnitList);
    this.selected.value = newUnit.name;
  }

  void removeUnit() {}

  void restoreUnits() {
    if (unitsStorage.hasData('Units')) {
      tempUnitList.value = unitsStorage.read('Units');

      final nameKey = 'name';
      final UIDKey = 'UID';

      for (int i = 0; i < tempUnitList.length; i++) {
        final map = tempUnitList[i];

        String name = map[nameKey];
        String UID = map[UIDKey];

        Unit newUnit = new Unit(name: name, UID: UID);
        unitList.add(newUnit);
      }
    }
  }
}
