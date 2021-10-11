import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/controllers/recipes/recipes_controller.dart';
import 'package:lists/controllers/shopping_list_controller.dart';
import 'package:lists/models/items/item.dart';
import 'package:lists/models/recipes/recipe.dart';
import 'package:lists/models/unit.dart';

class UnitsController extends GetxController {
  GetStorage unitsStorage = GetStorage();
  ShoppingListController shoppingListController =
      Get.find(); //needed for unit deletion
  RecipesController recipeListController = Get.find();

  List<Item> shoppingList = [];
  List<Unit> unitList = [];
  List<Unit> editableList =
      []; //Unit List w/o 'New...' and blank units; needed for editing the unit list
  List tempUnitList = [].obs;
  Unit blankUnit = new Unit(name: '', uniqueID: 'blankUnit');
  Unit newUnit = new Unit(name: 'New...', uniqueID: 'newUnit');

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
    final uniqueIDKey = 'uniqueID';
    bool duplicate = false;

    if (name == null) return; //cancel was pressed
    for (int i = 0; i < unitList.length; i++) {
      if (name == unitList[i].name) duplicate = true;
    }
    if (duplicate == false) {
      Unit newUnit = new Unit(name: name, uniqueID: DateTime.now().toString());
      storageMap[nameKey] = newUnit.name;
      storageMap[uniqueIDKey] = newUnit.uniqueID;

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
        title: Text(
          "Unit In Use",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
        ),
        content: Text(
            "This unit being used by $numUses items. Please modify or delete these items",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1!.color)),
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

    for (Item item
        in shoppingList) //loop through shopping list to see if unit is used
    {
      String listUnit = item.unit.string;
      String unitName = unit.name;

      if (listUnit == unitName) //if the unit is used in shopping list
      {
        numUses++;
      }
    }

    for (Recipe recipe
        in recipeListController.recipeList) //loop through all recipes
    {
      for (Item ingredient
          in recipe.ingredients) //loop through all ingredients in the recipe
      {
        String listUnit = ingredient.unit.string;
        String unitName = unit.name;

        if (listUnit == unitName) {
          numUses++;
        }
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
    unitsStorage.remove('uniqueID$index');
    unitList.removeWhere((element) => element.uniqueID == unit.uniqueID);
    tempUnitList.removeAt(index);
    editableList.removeAt(index);

    selected.value = "";
    //after a unit is deleted from the dropdown list modify unit is broken
  }

  void restoreUnits() {
    if (unitsStorage.hasData('Units')) {
      tempUnitList = unitsStorage.read('Units');

      final nameKey = 'name';
      final uniqueIDKey = 'uniqueID';

      for (int i = 0; i < tempUnitList.length; i++) {
        final map = tempUnitList[i];

        String name = map[nameKey];
        String uniqueID = map[uniqueIDKey];

        Unit newUnit = new Unit(name: name, uniqueID: uniqueID);
        unitList.add(newUnit);
        editableList.add(newUnit);
      }
    }
  }
}
