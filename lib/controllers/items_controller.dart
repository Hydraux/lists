import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/auth_controller.dart';
import 'package:lists/controllers/units_controller.dart';
import 'package:lists/models/item.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/models/unit.dart';
import 'package:lists/views/item_form.dart';
import 'package:lists/widgets/ingredient_card.dart';
import 'package:lists/widgets/item_card.dart';

class ItemsController extends GetxController {
  late DatabaseReference database;

  final AuthController authController = Get.find<AuthController>();

  final String tag;
  final RxList<Item> checkList = RxList();
  final RxList<Item> items = RxList();
  final RxList<Item> databaseItems = RxList();
  final Recipe? recipe;
  String storageName = '';
  late String? user;

  ItemsController({required this.tag, this.recipe, this.user});

  @override
  void onInit() {
    if (user == null) user = authController.user;
    super.onInit();
    setStoragePath();
    _activateListeners();
  }

  void setStoragePath() {
    if (tag == 'shoppingList') {
      database = FirebaseDatabase.instance.ref('${user}/shoppingList');
    } else if (tag == 'ingredients') {
      database = FirebaseDatabase.instance.ref('${user}/recipes/${recipe!.id}/ingredients');
    }
  }

  void _activateListeners() {
    database.onChildAdded.listen((event) async {
      final snapshot = event.snapshot.value;
      Item item = Item.fromJson(snapshot as Map);
      List<Item> list;

      if (item.checkBox)
        list = checkList;
      else
        list = items;

      list.add(item);
      list.sort(
        (a, b) => a.index.compareTo(b.index),
      );
      databaseItems.add(item);
      databaseItems.sort(((a, b) => a.index.compareTo(b.index)));
    });

    database.onChildChanged.listen((event) {
      Map snapshot = event.snapshot.value as Map;

      Item item = Item.fromJson(snapshot);

      List<Item> list;

      if (item.checkBox)
        list = checkList;
      else
        list = items;

      int index = list.indexWhere((element) => element.id == item.id);

      if (index != -1) {
        list[index] = item;
        list.sort(((a, b) => a.index.compareTo(b.index)));
      }

      index = databaseItems.indexWhere((element) => element.id == item.id);

      databaseItems[index] = item;
      databaseItems.sort(((a, b) => a.index.compareTo(b.index)));
    });

    database.onChildRemoved.listen((event) {
      Map snapshot = event.snapshot.value as Map;
      Item item = Item.fromJson(snapshot);

      List<Item> list;
      if (item.checkBox)
        list = checkList;
      else
        list = items;

      list.removeWhere((element) => element.id == item.id);
      databaseItems.removeWhere((element) => element.id == item.id);
    });
  }

  List<Widget> getListItems(List<Item> list, bool local) {
    list.sort((a, b) => (a.index).compareTo(b.index));
    return list.asMap().map((i, item) => MapEntry(i, buildItemTile(item, local))).values.toList();
  }

  Widget buildItemTile(Item item, bool local) {
    if (tag == "shoppingList")
      return ItemCard(item: item, controller: this);
    else
      return IngredientCard(item: item, isc: this, local: local);
  }

  void reorderList(int oldIndex, int newIndex, List<Item> list) {
    if (oldIndex < newIndex) newIndex--;

    List<Item> tempList = List.from(list);

    Item temp = tempList.removeAt(oldIndex);
    tempList.insert(newIndex, temp);

    for (int i = 0; i < tempList.length; i++) {
      tempList[i] = tempList[i].copyWith(index: i);
    }

    list = tempList;

    list.forEach((Item item) {
      uploadItem(item);
    });
  }

  void modifyItem(Item item) async {
    Item? temp = await Get.dialog(ItemForm(item: item, type: 'Modify'));

    if (temp != null) {
      uploadItem(temp);
    }
  }

  void createItem() async {
    //Get Date
    String date = DateTime.now().toString();

    //Extract numbers
    double dateNumbers = double.parse(date.replaceAll(RegExp('[^0-9]'), ''));

    //Convert to string and remove decimal place
    String dateID = dateNumbers.toStringAsFixed(0);

    //Fetch number of DB entires
    final DataSnapshot? snapshot = await database.get();
    int index = 0;
    if (snapshot!.value != null) index = (snapshot.value as Map<dynamic, dynamic>).length;

    Item? item = Item(id: dateID, index: index);

    item = await Get.dialog(ItemForm(
      item: item,
      type: 'New',
    ));

    if (item == null) return; //cancel was pressed
    uploadItem(item);
  }

  void removeItem(String id, List<Item> list) async {
    Item item = list.firstWhere((element) => element.id == id);

    list.remove(item);

    for (int i = 0; i < list.length; i++) {
      list[i].copyWith(index: i);
    }
    database.child(id).remove();
  }

  void uploadItem(Item item) {
    String id = item.id;
    final itemRef = database.child(id);
    Map<String, dynamic> jsonItem = item.toJson();
    itemRef.set(jsonItem);
  }

  double getFraction(String quantity) {
    if (quantity.isMixedFraction) {
      MixedFraction mixedFraction = quantity.toMixedFraction();
      return mixedFraction.toDouble();
    } else if (quantity.indexOf('/') != -1) {
      Fraction fraction = quantity.toFraction();
      return fraction.toDouble();
    } else {
      return double.parse(quantity);
    }
  }

  void check(Item item) {
    items.remove(item);
    item = item.copyWith(checkBox: true);
    checkList.add(item);
    uploadItem(item);
  }

  void uncheck(Item item) {
    checkList.remove(item);
    item = item.copyWith(checkBox: false);
    items.add(item);
    uploadItem(item);
  }

  Color getCardColor(Item item) {
    Color color;
    if (tag == "ingredients") {
      color = Get.theme.secondaryHeaderColor;
    } else {
      color = Get.theme.cardColor;
    }

    if (item.checkBox) color = Colors.grey;

    return color;
  }

  void sendToShoppingList() async {
    UnitsController unitsController;
    try {
      unitsController = Get.find<UnitsController>();
    } catch (e) {
      unitsController = UnitsController();
    }

    DatabaseReference localDatabase =
        FirebaseDatabase.instance.ref('${FirebaseAuth.instance.currentUser!.uid}/shoppingList');

    // checkList.forEach((Item item) {
    //   if (item.checkBox) {
    //     int index = unitsController.units.indexWhere((Unit unit) => unit.name == item.unit);

    //     if (index == -1 && item.unit != '') // unit not found
    //     {
    //       unitsController.createUnit(item.unit);
    //     }

    //     item = item.copyWith(checkBox: false, index: items.length);
    //     localDatabase.child(item.id).set(item.toJson());
    //   }
    // });

    for (int i = 0; i < checkList.length; i++) {
      Item item = checkList[i];
      if (item.checkBox) {
        int index = unitsController.units.indexWhere((Unit unit) => unit.name == item.unit);

        if (index == -1 && item.unit != '') // unit not found
        {
          unitsController.createUnit(item.unit);
        }

        DataSnapshot dataSnapshot = await localDatabase.get();

        if (dataSnapshot.exists) {
          Map snapshotMap = dataSnapshot.value as Map;
          index = snapshotMap.length;
        } else {
          index = 0;
        }

        item = item.copyWith(checkBox: false, index: index);
        await localDatabase.child(item.id).set(item.toJson());
      }
    }
  }
}
