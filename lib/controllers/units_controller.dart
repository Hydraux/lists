import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Recipedia/controllers/items_controller.dart';
import 'package:Recipedia/controllers/recipes_controller.dart';
import 'package:Recipedia/models/unit.dart';
import 'package:Recipedia/views/unit_form.dart';
import 'package:Recipedia/widgets/unit_card.dart';

class UnitsController extends GetxController {
  final RecipesController rsc = Get.find<RecipesController>();
  final ItemsController slc = Get.find<ItemsController>(tag: 'shoppingList');
  final DatabaseReference database = FirebaseDatabase.instance.ref('${FirebaseAuth.instance.currentUser!.uid}/units');

  final RxList<Unit> units = RxList();
  final RxList<Unit> favorites = RxList();

  final Unit blankUnit = Unit(name: '', id: '', index: -1, favorite: false);
  final Unit newUnit = Unit(name: 'New...', id: 'newUnit', index: -1, favorite: false);
  final Rx<Unit> selected = Unit(name: '', id: 'selected', index: -1, favorite: false).obs;

  @override
  onInit() {
    _activateListeners();
    super.onInit();
  }

  void _activateListeners() {
    database.onChildAdded.listen((event) {
      Map JsonUnit = event.snapshot.value as Map;
      Unit unit = Unit.fromJson(JsonUnit);
      List<Unit> list;
      if (unit.favorite == null) {
        unit = unit.copyWith(favorite: false);
      }

      if (unit.favorite)
        list = favorites;
      else
        list = units;

      list.add(unit);
      getOrder(list);
      setSelected(unit.name);
    });

    database.onChildChanged.listen((event) {
      Map JsonUnit = event.snapshot.value as Map;
      Unit unit = Unit.fromJson(JsonUnit);

      List<Unit> list = unit.favorite ? favorites : units;

      int index = list.indexWhere((Unit element) => unit.id == element.id);

      if (index != -1) {
        list[index] = unit;
      } else {
        list.add(unit);
      }

      getOrder(favorites);
      getOrder(units);
    });

    database.onChildRemoved.listen((event) {
      Map JsonUnit = event.snapshot.value as Map;
      Unit unit = Unit.fromJson(JsonUnit);

      List<Unit> list = unit.favorite ? favorites : units;
      list.removeWhere((element) => unit.id == element.id);
      getOrder(list);
    });
  }

  void createUnit(String? name) async {
    //Get Date
    String date = DateTime.now().toString();

    //Extract numbers
    double dateNumbers = double.parse(date.replaceAll(RegExp('[^0-9]'), ''));

    //Convert to string and remove decimal place
    String dateID = dateNumbers.toStringAsFixed(0);
    final DataSnapshot? snapshot = await database.get();
    int index = 0;
    if (snapshot!.value != null) index = (snapshot.value as Map<dynamic, dynamic>).length;

    Unit unit = Unit(id: dateID, index: index, favorite: false);

    if (name == null) name = await Get.dialog(UnitForm());

    unit = unit.copyWith(name: name);

    bool exists = false;

    units.forEach((element) {
      if (element.name == unit.name) {
        exists = true;
      }
    });

    if (!exists) {
      uploadUnit(unit);
    }
  }

  void uploadUnit(Unit unit) async {
    String id = unit.id;
    final unitRef = database.child(id);
    Map<String, dynamic> jsonItem = unit.toJson();
    await unitRef.set(jsonItem);
  }

  RxList<DropdownMenuItem<String>> getDropdownItems() {
    DropdownMenuItem<String> newUnit = DropdownMenuItem(
      child: Center(
          child: Text(
        'New...',
        style: TextStyle(fontSize: 18, color: Theme.of(Get.context!).textTheme.bodyText2!.color),
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

    RxList<DropdownMenuItem<String>> favoriteDropDownItems = favorites
        .map((Unit favorite) {
          return DropdownMenuItem<String>(
            value: favorite.name,
            child: Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                if (selected != favorite)
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                Center(
                  child: Text(
                    favorite.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Theme.of(Get.context!).textTheme.bodyText1!.color),
                  ),
                ),
              ],
            ),
          );
        })
        .toList()
        .obs;

    DropdownMenuItem<String>? divider;
    if (favorites.isNotEmpty) {
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
    RxList<DropdownMenuItem<String>> dropDownList = RxList();
    dropDownList.addAll(favoriteDropDownItems);
    if (divider != null) dropDownList.add(divider);

    dropDownList.add(blankUnit);
    dropDownList.addAll(unitDropDownItems);
    dropDownList.add(newUnit);
    return dropDownList;
  }

  void setSelected(val) {
    if (val == newUnit.name) {
      createUnit(null);
    } else {
      List<Unit> combinedList = List<Unit>.from(units) + List<Unit>.from(favorites);
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
      ItemsController ingredientsController = ItemsController(tag: recipe.id);
      ingredientsController.items.forEach((item) {
        if (item.unit == unit) {
          numUses++;
        }
      });
    });

    slc.items.forEach((item) {
      if (item.unit == unit) numUses++;
    });

    return numUses;
  }

  void removeUnit(String id) async {
    setSelected(blankUnit);
    await database.child(id).remove();
  }

  void toggleFavorite(Unit unit) {
    List<Unit> list = unit.favorite ? favorites : units;

    list.removeWhere((element) => element.id == unit.id);
    unit = unit.copyWith(favorite: !unit.favorite);
    database.child(unit.id).set(unit.toJson());
  }

  List<Widget> getListItems(List<Unit> list) {
    return list
        .asMap()
        .map((i, unit) => MapEntry(
            i,
            UnitCard(
              unit: unit,
              controller: this,
            )))
        .values
        .toList();
  }

  void reorderList(int oldIndex, int newIndex) {} //TODO: Implement reorder units

  void getOrder(List<Unit> list) {
    for (int i = 0; i < list.length; i++) {
      if (i != list[i].index) {
        list[i] = list[i].copyWith(index: i);
        uploadUnit(list[i]);
      }
    }
  }
}
