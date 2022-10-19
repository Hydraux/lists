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
  late String? user;

  ItemsController({required this.tag, this.recipe, this.user});

  @override
  void onInit() {
    if (user == null) user = _authController.user;
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

      items.add(item);
      items.sort(
        (a, b) => a.index.compareTo(b.index),
      );
    });

    database.onChildChanged.listen((event) {
      Map snapshot = event.snapshot.value as Map;

      Item item = Item.fromJson(snapshot);

      int index = items.indexWhere((element) => element.id == item.id);

      items[index] = item;
      items.sort(((a, b) => a.index.compareTo(b.index)));
    });

    database.onChildRemoved.listen((event) {
      Map snapshot = event.snapshot.value as Map;
      Item item = Item.fromJson(snapshot);
      items.removeWhere((element) => element.id == item.id);
    });
  }

  List<Widget> getListItems() {
    items.sort((a, b) => (a.index).compareTo(b.index));
    return items.asMap().map((i, item) => MapEntry(i, buildItemTile(item))).values.toList();
  }

  Widget buildItemTile(Item item) {
    return Card(
      color: tag == "ingredients" ? Get.theme.secondaryHeaderColor : Get.theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      key: UniqueKey(), //Key(item.id),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: user == _authController.user
            ? Dismissible(
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
              )
            : ItemCard(
                item: item,
                editMode: true,
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

  // void reorderList(int oldIndex, int newIndex) async {
  //   uploadItem(items[oldIndex].copyWith(index: newIndex));

  //   if (oldIndex < newIndex) {
  //     for (int i = oldIndex + 1; i <= newIndex; i++) {
  //       uploadItem(items[i].copyWith(index: i - 1));
  //     }
  //   } else {
  //     //old index > new index
  //     for (int i = oldIndex - 1; i >= newIndex; i--) {
  //       uploadItem(items[i].copyWith(index: i + 1));
  //     }
  //   }
  //   items.sort(((a, b) => a.index.compareTo(b.index)));
  // }

  void reorderList(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex--;

    List<Item> tempList = List.from(items);

    Item temp = tempList.removeAt(oldIndex);
    tempList.insert(newIndex, temp);

    for (int i = 0; i < tempList.length; i++) {
      tempList[i] = tempList[i].copyWith(index: i);
    }

    items.value = tempList;

    items.forEach((Item item) {
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
