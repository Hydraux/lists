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

  List<Unit> unitList = [];
  List editableList = []
      .obs; //Unit List w/o 'New...' and blank units; needed for editing the unit list
  List<Unit> favoritesList = [];
  List obsFavorites = [].obs;

  List favoritesStorageList = [];
  List unitsStorageList = [];
  Unit blankUnit = new Unit(name: '', uniqueID: 'blankUnit');
  Unit newUnit = new Unit(name: 'New...', uniqueID: 'newUnit');
  Rx<Unit> selected = Unit(name: 'selected', uniqueID: 'selected').obs;

  @override
  onInit() {
    Future.delayed(Duration.zero, () {
      restoreUnits();

      unitList.add(blankUnit);
      unitList.add(newUnit);
      selected.value = blankUnit;
    });
    super.onInit();
  }

  void setSelected(val, Item item) {
    if (val == newUnit.name)
      createUnit(item);
    else {
      List<Unit> combinedList = unitList + favoritesList;
      for (Unit unit in combinedList) {
        if (unit.name == val) {
          selected.value = unit;
        }
      }
    }
  }

  void favorite(Unit unit) {
    removeUnit(unit);

    addFavorite(unit);
  }

  void unfavorite(Unit unit) {
    removeFavorite(unit);
    addUnit(unit);
  }

  void createUnit(Item? item) async {
    var unit = await Get.toNamed('/NewUnit', arguments: item);
    final storageMap = {};
    final nameKey = 'name';
    final uniqueIDKey = 'uniqueID';
    bool duplicate = false;

    if (unit == null) return; //cancel was pressed
    for (Unit listUnit in unitList) {
      if (unit.name == listUnit.name) duplicate = true;
    }
    for (Unit listUnit in favoritesList) {
      if (unit.name == listUnit.name) duplicate = true;
    }
    if (duplicate == false) {
      storageMap[nameKey] = unit.name;
      storageMap[uniqueIDKey] = unit.uniqueID;

      unitsStorageList.add(storageMap);
      unitList.add(unit);
      editableList.add(unit);
      unitsStorage.write('Units', unitsStorageList);

      editableList.sort((a, b) => a.name.compareTo(b.name));

      unitList.remove(newUnit);
      unitList.add(newUnit);
    }
    selected = unit;
  }

  void addUnit(Unit unit) {
    final storageMap = {};
    final nameKey = 'name';
    final uniqueIDKey = 'uniqueID';

    storageMap[nameKey] = unit.name;
    storageMap[uniqueIDKey] = unit.uniqueID;

    unitsStorageList.add(storageMap);
    unitList.add(unit);
    editableList.add(unit);
    unitsStorage.write('Units', unitsStorageList);

    unitList.sort((a, b) => a.name.compareTo(b.name));
    editableList.sort((a, b) => a.name.compareTo(b.name));

    unitList.remove(newUnit);
    unitList.add(newUnit);
  }

  void addFavorite(Unit unit) {
    final storageMap = {};
    final nameKey = 'name';
    final uniqueIDKey = 'uniqueID';

    storageMap[nameKey] = unit.name;
    storageMap[uniqueIDKey] = unit.uniqueID;

    favoritesStorageList.add(storageMap);
    favoritesList.add(unit);
    obsFavorites.add(unit);

    unitsStorage.write('Units/Favorites', favoritesStorageList);
  }

  Future<bool> confirmDismiss(Unit unit, context) async {
    int numUses = checkUses(unit);

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

  int checkUses(Unit unit) {
    List<Item> shoppingList = shoppingListController.shoppingList;
    int numUses = 0;

    for (Item item
        in shoppingList) //loop through shopping list to see if unit is used
    {
      String listUnit = item.unit.name;
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
        String listUnit = ingredient.unit.name;
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
      return 0;
    }
  }

  void removeUnit(Unit unit) {
    int index = editableList.indexOf(unit);
    unitsStorage.remove('name$index');
    unitsStorage.remove('uniqueID$index');
    unitList.removeWhere((element) => element.name == unit.name);
    unitsStorageList.removeAt(index);
    editableList.removeAt(index);

    selected.value = blankUnit;
  }

  void removeFavorite(Unit unit) {
    int index = favoritesList.indexOf(unit);
    unitsStorage.remove('name$index');
    unitsStorage.remove('uniqueID$index');
    favoritesList.removeWhere((element) => element.name == unit.name);
    obsFavorites.removeWhere((element) => element.name == unit.name);
    favoritesStorageList.removeAt(index);

    selected.value = blankUnit;
  }

  void restoreUnits() {
    if (unitsStorage.hasData('Units')) {
      final tempUnitList = unitsStorage.read('Units');

      final nameKey = 'name';
      final uniqueIDKey = 'uniqueID';

      for (int i = 0; i < tempUnitList.length; i++) {
        final map = tempUnitList[i];

        String name = map[nameKey];
        String uniqueID = map[uniqueIDKey];

        Unit unit = new Unit(name: name, uniqueID: uniqueID);
        addUnit(unit);
      }
    }
    if (unitsStorage.hasData('Units/Favorites')) {
      final tempFavoritesList = unitsStorage.read('Units/Favorites');

      final nameKey = 'name';
      final uniqueIDKey = 'uniqueID';

      for (int i = 0; i < tempFavoritesList.length; i++) {
        final map = tempFavoritesList[i];

        String name = map[nameKey];
        String uniqueID = map[uniqueIDKey];

        Unit unit = new Unit(name: name, uniqueID: uniqueID);
        addFavorite(unit);
      }
    }
  }

  List<Widget> getListItems() => obsFavorites
      .asMap()
      .map((i, unit) => MapEntry(
          i,
          _buildDismissableTile(
            unit,
            i,
          )))
      .values
      .toList();

  Widget _buildDismissableTile(Unit unit, int index) {
    return Card(
        key: Key(unit.uniqueID),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Dismissible(
          direction: DismissDirection.startToEnd,
          key: UniqueKey(),
          confirmDismiss: (direction) =>
              confirmDismiss(obsFavorites[index], Get.context),
          onDismissed: (direction) {
            removeFavorite(obsFavorites[index]);
          },
          background: Container(
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          child: Card(
            elevation: 5,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    unfavorite(obsFavorites[index]);
                  },
                  icon: Icon(Icons.star),
                  color: Colors.yellow,
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Text(
                      obsFavorites[index].name,
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
          ),
        ));
  }

  void reorderList(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex--;
    }

    Unit temp = obsFavorites[oldIndex];
    obsFavorites.removeAt(oldIndex);
    obsFavorites.insert(newIndex, temp);

    updateValue(oldIndex);
    updateValue(newIndex);
  }

  void updateValue(int index) {
    final storageMap = {};

    final nameKey = 'name';
    final uniqueIDKey = 'uniqueID';

    Unit unit = obsFavorites[index]; // pulls item out of shopping list

    // separates values for json storage
    storageMap[nameKey] = unit.name;
    storageMap[uniqueIDKey] = unit.uniqueID;

    // stores json values for getstorage
    favoritesStorageList[index] = storageMap;

    unitsStorage.write('Units/Favorites', favoritesStorageList);
  }
}
