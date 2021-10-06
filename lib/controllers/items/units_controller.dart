import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/models/items/item.dart';
import 'package:lists/models/unit.dart';

class UnitsController extends GetxController {
  GetStorage unitsStorage = GetStorage();

  List<Unit> unitList = [];
  List<Unit> editableList =
      []; //Unit List w/o 'New...' and blank units; needed for editing the unit list
  List tempUnitList = [].obs;
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

  void setSelected(String val, Item item) {
    if (val == 'New...')
      addUnit(item);
    else
      selected.value = val;
  }

  void addUnit(Item? item) async {
    var name = await Get.toNamed('/NewUnit', arguments: item);
    final storageMap = {};
    final nameKey = 'name';
    final UIDKey = 'UID';
    bool duplicate = false;

    if (name == null) return; //cancel was pressed
    for (int i = 0; i < unitList.length; i++) {
      if (name == unitList[i].name) duplicate = true;
    }
    if (duplicate == false) {
      Unit newUnit = new Unit(name: name, UID: DateTime.now().toString());
      storageMap[nameKey] = newUnit.name;
      storageMap[UIDKey] = newUnit.UID;

      tempUnitList.add(storageMap);
      unitList.add(newUnit);
      editableList.add(newUnit);
      unitsStorage.write('Units', tempUnitList);
    }
    selected.value = name;
  }

  void removeUnit(int index) {
    unitsStorage.remove('name$index');
    unitsStorage.remove('UID$index');
    unitList.removeAt(index);
    tempUnitList.removeAt(index);
    editableList.removeAt(index);
  }

  void restoreUnits() {
    if (unitsStorage.hasData('Units')) {
      tempUnitList = unitsStorage.read('Units');

      final nameKey = 'name';
      final UIDKey = 'UID';

      for (int i = 0; i < tempUnitList.length; i++) {
        final map = tempUnitList[i];

        String name = map[nameKey];
        String UID = map[UIDKey];

        Unit newUnit = new Unit(name: name, UID: UID);
        unitList.add(newUnit);
        editableList.add(newUnit);
      }
    }
  }
}
