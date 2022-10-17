import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/auth_controller.dart';
import 'package:lists/models/item.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/views/item_form.dart';
import 'package:lists/widgets/item_card.dart';

class ItemsController extends GetxController {
  late DatabaseReference database;

  final AuthController _authController = Get.find<AuthController>();

  final String tag;
  final List<Item> checkList = [];
  final Recipe? recipe;
  final RxList<Item> items = RxList();
  String storageName = '';

  ItemsController({required this.tag, this.recipe});

  @override
  void onInit() {
    super.onInit();
    setStoragePath();
    _activateListeners();
  }

  void setStoragePath() {
    if (tag == 'shoppingList') {
      database = FirebaseDatabase.instance.ref('${_authController.user}/shoppingList');
    } else if (tag == 'ingredients') {
      database = FirebaseDatabase.instance.ref('${_authController.user}/recipes/${recipe!.id}/ingredients');
    }
  }

  void _activateListeners() {
    database.onChildAdded.listen((event) async {
      print("got here");
      final snapshot = event.snapshot.value;
      Item item = Item.fromJson(snapshot as Map);

      // if (items.length > 0) {
      //   items.insert(item.index, item);
      //   itemWidgets.insert(item.index, itemWidget);
      // } else {
      //   items.add(item);
      //   itemWidgets.add(itemWidget);
      // }
      items.add(item);
      items.sort(((a, b) => a.index.compareTo(b.index)));
    });

    database.onChildChanged.listen((event) {
      Map snapshot = event.snapshot.value as Map;

      Item item = Item.fromJson(snapshot);
      Key itemKey = Key(item.id);

      int index = items.indexWhere((element) => element.id == item.id);

      items[index] = item;
    });

    database.onChildRemoved.listen((event) {
      Map snapshot = event.snapshot.value as Map;
      Item item = Item.fromJson(snapshot);
      Key itemKey = Key(item.id);
      items.removeWhere((element) => element.id == item.id);
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
    return items.asMap().map((i, item) => MapEntry(i, buildItemTile(item))).values.toList();
  }

  Widget buildItemTile(Item item) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      key: UniqueKey(), //Key(item.id),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Dismissible(
          direction: DismissDirection.endToStart,
          key: UniqueKey(),
          onDismissed: (direction) {
            removeItem(item.id);
          },
          background: Container(
            color: Theme.of(Get.context!).errorColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.delete),
                ),
              ],
            ),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: GestureDetector(
                onTap: () async {
                  modifyItem(item);
                },
                child: ItemCard(
                  item: item,
                  editMode: true,
                )),
          ),
        ),
      ),
    );
  }

  void check(Item item) {
    checkList.add(item);
  }

  void uncheck(Item item) {
    checkList.remove(item);
  }

  void reorderList(int oldIndex, int newIndex) async {
    uploadItem(items[oldIndex].copyWith(index: newIndex));

    if (oldIndex < newIndex) {
      newIndex = newIndex - 1;
      for (int i = oldIndex + 1; i <= newIndex; i++) {
        uploadItem(items[i].copyWith(index: i - 1));
      }
    } else {
      for (int i = oldIndex - 1; i >= newIndex; i--) {
        uploadItem(items[i].copyWith(index: i + 1));
      }
    }
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

  void removeItem(String id) async {
    Item item = items.firstWhere((element) => element.id == id);

    items.forEach((element) {
      if (element.index > item.index) {
        element = element.copyWith(index: element.index - 1);
        uploadItem(element);
      }
    });
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
}
