import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/controllers/items_controller.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/models/item.dart';
import 'package:lists/models/unit.dart';
import 'package:lists/views/unit_form.dart';

class UnitsController extends GetxController {
  GetStorage unitsStorage = GetStorage();

  RecipesController rsc = Get.find<RecipesController>();
  ItemsController slc = Get.find<ItemsController>(tag: 'shoppingList');

  List<ItemsController> ingredientControllers = [];
  List<Unit> unitList = [];
  List editableList = [].obs; //Unit List w/o 'New...' and blank units; needed for editing the unit list
  List<Unit> favoritesList = [];
  List obsFavorites = [].obs;

  List favoritesStorageList = [];
  List unitsStorageList = [];
  Unit blankUnit = Unit(name: '', id: 'blankUnit');
  Unit newUnit = Unit(name: 'New...', id: 'newUnit');
  Rx<Unit> selected = Unit(name: 'selected', id: 'selected').obs;

  @override
  onInit() {
    Future.delayed(Duration.zero, () {
      restoreUnits();

      if (!unitList.contains(blankUnit)) unitList.insert(0, blankUnit);
      if (!unitList.contains(newUnit)) unitList.add(newUnit);
      selected.value = blankUnit;
    });
    super.onInit();
  }

  RxList<DropdownMenuItem<String>> getDropdownItems() {
    RxList<DropdownMenuItem<String>> units = unitList
        .map((Unit unit) {
          return DropdownMenuItem<String>(
            value: unit.name,
            child: Center(
              child: Text(
                unit.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Theme.of(Get.context!).textTheme.bodyText1!.color),
              ),
            ),
          );
        })
        .toList()
        .obs;

    RxList<DropdownMenuItem<String>> favorites = favoritesList
        .map((Unit favorite) {
          return DropdownMenuItem<String>(
            value: favorite.name,
            child: Center(
              child: Text(
                favorite.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Theme.of(Get.context!).textTheme.bodyText1!.color),
              ),
            ),
          );
        })
        .toList()
        .obs;

    DropdownMenuItem<String>? divider;
    if (favoritesList.isNotEmpty) {
      divider = DropdownMenuItem(
          enabled: false,
          child: Container(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(0),
            child: Divider(
              thickness: 2,
              color: Theme.of(Get.context!).appBarTheme.backgroundColor,
            ),
          ));
    }
    RxList<DropdownMenuItem<String>> dropDownList = favorites;
    if (divider != null) dropDownList.add(divider);
    dropDownList.addAll(units);
    return dropDownList;
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
    Unit? unit = await Get.dialog(UnitForm());
    final storageMap = {};
    final nameKey = 'name';
    final idKey = 'id';
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
      storageMap[idKey] = unit.id;

      unitsStorageList.add(storageMap);
      unitList.add(unit);
      editableList.add(unit);
      unitsStorage.write('Units', unitsStorageList);

      editableList.sort((a, b) => a.name.compareTo(b.name));

      unitList.remove(newUnit);
      unitList.add(newUnit);
    }
    selected.value = unit;
  }

  void addUnit(Unit unit) async {
    final storageMap = {};
    final nameKey = 'name';
    final idKey = 'id';

    storageMap[nameKey] = unit.name;
    storageMap[idKey] = unit.id;

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
    final idKey = 'id';

    storageMap[nameKey] = unit.name;
    storageMap[idKey] = unit.id;

    favoritesStorageList.add(storageMap);
    favoritesList.add(unit);
    obsFavorites.add(unit);

    unitsStorage.write('UnitFavorites', favoritesStorageList);
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
        content: Text("This unit being used by $numUses items. Please modify or delete these items",
            style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color)),
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
    int numUses = 0;

    slc.items.forEach((item) {
      if (item.unit == unit.name) numUses++;
    });

    rsc.recipes.forEach((recipe) {
      if (recipe.ingredients != null)
        recipe.ingredients!.forEach((ingredient) {
          if (ingredient.unit == unit.name) numUses++;
        });
    });

    return numUses;
  }

  void removeUnit(Unit unit) {
    int index = editableList.indexOf(unit);
    unitList.remove(unit);
    unitsStorageList.removeAt(index);
    editableList.removeAt(index);

    unitsStorage.write('Units', unitsStorageList);
    selected.value = blankUnit;
  }

  void removeFavorite(Unit unit) {
    int index = favoritesList.indexOf(unit);

    favoritesList.removeWhere((element) => element.name == unit.name);
    obsFavorites.removeWhere((element) => element.name == unit.name);
    favoritesStorageList.removeAt(index);

    unitsStorage.write('Units', unitsStorageList);

    selected.value = blankUnit;
  }

  void restoreUnits() {
    if (unitsStorage.hasData('Units')) {
      final tempUnitList = unitsStorage.read('Units');

      final nameKey = 'name';
      final idKey = 'id';

      for (int i = 0; i < tempUnitList.length; i++) {
        final map = tempUnitList[i];

        String name = map[nameKey];
        String id = map[idKey];

        Unit unit = Unit(name: name, id: id);
        addUnit(unit);
      }
    }
    if (unitsStorage.hasData('UnitFavorites')) {
      final tempFavoritesList = unitsStorage.read('UnitFavorites');

      final nameKey = 'name';
      final idKey = 'id';

      for (int i = 0; i < tempFavoritesList.length; i++) {
        final map = tempFavoritesList[i];

        String name = map[nameKey];
        String id = map[idKey];

        Unit unit = Unit(name: name, id: id);
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
        key: Key(unit.id),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Dismissible(
          key: UniqueKey(),
          confirmDismiss: (direction) async {
            switch (direction) {
              case DismissDirection.endToStart:
                return confirmDismiss(obsFavorites[index], Get.context);
              case DismissDirection.startToEnd:
                return true;

              case DismissDirection.vertical:
              case DismissDirection.horizontal:
              case DismissDirection.up:
              case DismissDirection.down:
              case DismissDirection.none:
                assert(true);
            }
          },
          onDismissed: (direction) => direction == DismissDirection.startToEnd
              ? unfavorite(obsFavorites[index])
              : removeFavorite(obsFavorites[index]),
          background: Container(
            color: Colors.yellow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.star_border,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.black,
                  ),
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
    final idKey = 'id';

    Unit unit = obsFavorites[index]; // pulls item out of shopping list

    // separates values for json storage
    storageMap[nameKey] = unit.name;
    storageMap[idKey] = unit.id;

    // stores json values for getstorage
    favoritesStorageList[index] = storageMap;

    unitsStorage.write('UnitFavorites', favoritesStorageList);
  }
}
