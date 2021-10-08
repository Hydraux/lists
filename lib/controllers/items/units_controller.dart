import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/controllers/shopping_list_controller.dart';
import 'package:lists/models/items/item.dart';
import 'package:lists/models/unit.dart';

class UnitsController extends GetxController {
  GetStorage unitsStorage = GetStorage();
  ShoppingListController shoppingListController =
      Get.find(); //needed for unit deletion

  List<Item> shoppingList = [];
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

  Future<bool> confirmDismiss(int index, context) async {
    int numUses = checkUses(index);

    if (numUses > 0) //unit is in use
    {
      return await Get.dialog(AlertDialog(
        title: Text("Unit In Use"),
        content: Text(
            "This unit being used by $numUses items. Please modify or delete these items"),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(result: false),
            child: Text("Ok"),
          )
        ],
      ));
    } else {
      // unit is not in use
      return true;
    }
  }

  int checkUses(int index) {
    Unit unit = editableList[index];
    shoppingList = shoppingListController.shoppingList;
    int numUses = 0;
    //loop through shopping list to see if unit is used
    for (int i = 0; i < shoppingList.length; i++) {
      String listUnit = shoppingList[i].unit.string;
      String unitName = unit.name;

      if (listUnit == unitName) {
        //if the unit is used in shopping list
        numUses++;
      }
    }

    if (numUses > 0) {
      // unit is in use
      return numUses;
    } else {
      // unit is not in use
      removeUnit(index, unit);
      return 0;
    }
  }

  void removeUnit(int index, Unit unit) {
    unitsStorage.remove('name$index');
    unitsStorage.remove('UID$index');
    unitList.removeWhere((element) => element.UID == unit.UID);
    tempUnitList.removeAt(index);
    editableList.removeAt(index);

    selected.value = "";
    //after a unit is deleted from the dropdown list modify unit is broken
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
