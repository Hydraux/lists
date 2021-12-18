import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/items_controller.dart';
import 'package:lists/controllers/recipes_controller.dart';
import 'package:lists/models/unit.dart';
import 'package:lists/views/unit_form.dart';

class UnitsController extends GetxController {
  final database = FirebaseDatabase.instance.ref('${FirebaseAuth.instance.currentUser!.uid}/units');

  final RecipesController rsc = Get.find<RecipesController>();
  final ItemsController slc = Get.find<ItemsController>(tag: 'shoppingList');

  final List<ItemsController> ingredientControllers = [];

  final RxList<Widget> unitWidgets = RxList();
  final RxList<Unit> units = RxList();
  final List<Unit> favorites = [];

  final Unit blankUnit = Unit(name: '', id: '', index: -1);
  final Unit newUnit = Unit(name: 'New...', id: 'newUnit', index: -1);
  final Rx<Unit> selected = Unit(name: '', id: 'selected', index: -1).obs;

  @override
  onInit() {
    Future.delayed(Duration.zero, () {});

    _activateListeners();
    super.onInit();
  }

  void _activateListeners() {
    units.value = [];
    database.onValue.listen((event) {
      final snapshot = event.snapshot;
      unitWidgets.value = getListItems(snapshot);
    });
  }

  void restoreUnits() async {
    final snapshot = await database.get();
    if (snapshot.value != null) {
      Map map = snapshot.value as Map;
      List list = map.values.toList();
      list.forEach((element) {
        units.add(Unit.fromJson(element));
      });
    }
  }

  Future<void> createUnit() async {
    //Get Date
    String date = DateTime.now().toString();

    //Extract numbers
    double dateNumbers = double.parse(date.replaceAll(RegExp('[^0-9]'), ''));

    //Convert to string and remove decimal place
    String dateID = dateNumbers.toStringAsFixed(0);
    final DataSnapshot? snapshot = await database.get();
    int index = 0;
    if (snapshot!.value != null) index = (snapshot.value as Map<dynamic, dynamic>).length;

    Unit unit = Unit(id: dateID, index: index);
    String name = await Get.dialog(UnitForm());

    unit = unit.copyWith(name: name);

    bool exists = false;

    units.forEach((element) {
      if (element.name == unit.name) {
        exists = true;
      }
    });

    if (!exists) {
      uploadUnit(unit);
      units.add(unit);
    }
    selected.value = unit;
  }

  void uploadUnit(Unit unit) {
    String id = unit.id;
    final unitRef = database.child(id);
    Map<String, dynamic> jsonItem = unit.toJson();
    unitRef.set(jsonItem);
    setSelected(unit.name);
  }

  RxList<DropdownMenuItem<String>> getDropdownItems() {
    DropdownMenuItem<String> newUnit = DropdownMenuItem(
      child: Center(
          child: Text(
        'New...',
        style: TextStyle(fontSize: 18),
      )),
      value: 'New...',
    );
    DropdownMenuItem<String> blankUnit = DropdownMenuItem(
      child: Text(''),
      value: '',
    );
    List<DropdownMenuItem<String>> unitDropDownItems = units
        .map((Unit unit) {
          return DropdownMenuItem<String>(
            value: unit.name,
            child: Center(
              child: Text(
                unit.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Theme.of(Get.context!).textTheme.bodyText1!.color, fontSize: 18),
              ),
            ),
          );
        })
        .toList()
        .obs;

    // RxList<DropdownMenuItem<String>> favoriteDropDownItems = favorites
    //     .map((Unit favorite) {
    //       return DropdownMenuItem<String>(
    //         value: favorite.name,
    //         child: Center(
    //           child: Text(
    //             favorite.name,
    //             overflow: TextOverflow.ellipsis,
    //             style: TextStyle(color: Theme.of(Get.context!).textTheme.bodyText1!.color),
    //           ),
    //         ),
    //       );
    //     })
    //     .toList()
    //     .obs;

    DropdownMenuItem<String>? divider;
    // if (favoritesList.isNotEmpty) {
    //   divider = DropdownMenuItem(
    //       enabled: false,
    //       child: Container(
    //         margin: EdgeInsets.all(0),
    //         padding: EdgeInsets.all(0),
    //         child: Divider(
    //           thickness: 2,
    //           color: Theme.of(Get.context!).appBarTheme.backgroundColor,
    //         ),
    //       ));
    // }
    RxList<DropdownMenuItem<String>> dropDownList = RxList();
    if (divider != null) dropDownList.add(divider);

    dropDownList.add(blankUnit);
    dropDownList.addAll(unitDropDownItems);
    dropDownList.add(newUnit);
    return dropDownList;
  }

  void setSelected(val) {
    if (val == newUnit.name) {
      createUnit();
    } else {
      List<Unit> combinedList = units + favorites;
      //combinedList.add(blankUnit);
      for (Unit unit in combinedList) {
        if (unit.name == val) {
          selected.value = unit;
        } else if (blankUnit.name == val) {
          selected.value = blankUnit;
        }
      }
    }
  }

  void favorite(Unit unit) {
    removeUnit(unit.id);

    uploadFavorite(unit);
  }

  void unfavorite(Unit unit) {
    removeFavorite(unit);
    uploadUnit(unit);
  }

  void uploadFavorite(Unit unit) {
    String id = unit.id;
    final unitRef = database.child('favorites').child(id);
    Map<String, dynamic> jsonItem = unit.toJson();
    unitRef.set(jsonItem);
  }

  Future<bool> confirmDismiss(String unit) async {
    int numUses = await checkUses(unit);

    if (numUses > 0) //unit is in use
    {
      return await Get.dialog(AlertDialog(
        title: Text(
          "Unit In Use",
          style: TextStyle(color: Theme.of(Get.context!).textTheme.bodyText1!.color),
        ),
        content: Text("This unit being used by $numUses items. Please modify or delete these items",
            style: TextStyle(color: Theme.of(Get.context!).textTheme.bodyText1!.color)),
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

  Future<int> checkUses(String unit) async {
    int numUses = 0;

    rsc.recipes.forEach((recipe) {
      if (recipe.ingredients != null)
        recipe.ingredients!.forEach((ingredient) {
          if (ingredient.unit == unit) numUses++;
        });
    });

    slc.items.forEach((item) {
      if (item.unit == unit) numUses++;
    });

    return numUses;
  }

  void removeUnit(String id) async {
    selected.value = blankUnit;

    database.child(id).remove();
    units.removeWhere((element) => element.id == id);

    units.forEach((element) {
      if (element.id == id) {
        element = element.copyWith(index: element.index - 1);
        uploadUnit(element);
      }
    });

    units.removeWhere((element) => element.id == id);
  }

  void removeFavorite(Unit unit) async {
    database.child('favorites').child(unit.id).remove();
    units.removeWhere((element) => element.id == unit.id);

    units.forEach((element) {
      if (element.index > unit.index) {
        element = element.copyWith(index: unit.index - 1);
        uploadUnit(element);
      }
    });
  }

  List<Widget> getListItems(DataSnapshot snapshot) {
    Map<dynamic, dynamic> mapDB = Map<dynamic, dynamic>();

    if (snapshot.value != null) {
      //Extract data from DB
      mapDB = snapshot.value as Map<dynamic, dynamic>;
    }
    //convert to list and sort
    List list = mapDB.values.toList();
    list.sort((a, b) => (a['index']).compareTo(b['index']));
    return list.asMap().map((i, unit) => MapEntry(i, _buildUnitTile(unit, i))).values.toList();
  }

  Widget _buildUnitTile(Map unit, int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      key: Key(unit['id']),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Dismissible(
            key: UniqueKey(),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart)
                return confirmDismiss(unit['name']);
              else
                return false;
            },
            onDismissed: (direction) {
              removeUnit(unit['id']);
              unitWidgets.removeAt(index);
              if (direction == DismissDirection.startToEnd) favorite(units[index]);
            },
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
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              title: Center(
                child: Text(
                  unit['name'],
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )),
      ),
    );
  }

  void reorderList(int oldIndex, int newIndex) {}
}
