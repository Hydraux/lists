import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/controllers/items/units_controller.dart';
import 'package:lists/models/items/item.dart';
import 'package:lists/widgets/item/item_card.dart';

class ShoppingListController extends GetxController {
  final storeList = GetStorage();
  List tempList = [].obs;
  List<Item> shoppingList = [];

  @override
  void onInit() {
    super.onInit();

    restoreItems();
  }

  int get shoppingListLength => shoppingList.length;

  List<Widget> getListItems() => shoppingList
      .asMap()
      .map((i, item) => MapEntry(i, _buildDismissableTile(item, i)))
      .values
      .toList();

  Widget _buildDismissableTile(Item item, int index) {
    return Card(
      key: Key(item.uniqueID),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Dismissible(
        direction: DismissDirection.startToEnd,
        key: UniqueKey(),
        onDismissed: (direction) {
          removeItem(index);
        },
        background: Container(
          color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.delete),
            ],
          ),
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: ItemCard(
            item: shoppingList[index],
            index: index,
            editMode: true,
            listType: 'Shopping List',
          ),
        ),
      ),
    );
  }

  void reorderList(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex--;
    }

    Item temp = shoppingList[oldIndex];
    shoppingList.removeAt(oldIndex);
    shoppingList.insert(newIndex, temp);

    updateValue(oldIndex);
    updateValue(newIndex);
  }

  void addItem() async {
    Item? item = new Item(
        name: 'Item Name', unit: Get.find<UnitsController>().blankUnit);
    item = await Get.toNamed('/shoppingList/newItem', arguments: item);
    if (item == null) return; //cancel was pressed
    final storageMap = {};
    final nameKey = 'name';
    final quantityKey = 'quantity';
    final unitKey = 'unit';
    final uniqueIDKey = 'uniqueID';

    storageMap[nameKey] = item.name;
    storageMap[quantityKey] = item.quantity;
    storageMap[uniqueIDKey] = item.uniqueID;
    storageMap[unitKey] = item.unit;

    tempList.add(storageMap);
    storeList.write('shoppingList', tempList);
    shoppingList.add(item);
  }

  void updateValue(int index) {
    final storageMap = {};

    final nameKey = 'name';
    final quantityKey = 'quantity';
    final unitKey = 'unit';
    final uniqueIDKey = 'uniqueID';

    Item item = shoppingList[index]; // pulls item out of shopping list

    // separates values for json storage
    storageMap[nameKey] = item.name;
    storageMap[quantityKey] = item.quantity;
    storageMap[unitKey] = item.unit;
    storageMap[uniqueIDKey] = item.uniqueID;

    // stores json values for getstorage
    tempList[index] = storageMap;

    storeList.write('shoppingList', tempList);
  }

  void removeItem(int index) {
    storeList.remove('name$index');
    storeList.remove('quantity$index');
    shoppingList.removeAt(index);
    tempList.removeAt(index);
  }

  void restoreItems() {
    if (storeList.hasData('shoppingList')) {
      tempList = storeList.read('shoppingList');

      String nameKey, quantityKey, unitKey, uniqueIDKey;

      for (int i = 0; i < tempList.length; i++) {
        final map = tempList[i];
        final index = i;

        nameKey = 'name';
        quantityKey = 'quantity';
        unitKey = 'unit';
        uniqueIDKey = 'uniqueID';

        final item = Item(name: map[nameKey], unit: map[unitKey]);
        item.uniqueID = map[
            uniqueIDKey]; //replaces item's uid with the saved UID at that index

        shoppingList.add(item);
        shoppingList[index].quantity = map[quantityKey];
      }
    }
  }
}
