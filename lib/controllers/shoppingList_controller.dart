import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/Models/Item.dart';
import 'package:lists/Pages/new_item.dart';
import 'package:lists/Pages/shopping_list.dart';

class SLController {
  final storeList = GetStorage();
  List tempList = [];
  List<Item> shoppingList = [];

  int get shoppingListLength => shoppingList.length;

  void addItem(context) async {
    final storageMap = {};
    final index = shoppingList.length;
    final nameKey = 'name$index';
    final quantityKey = 'quantity$index';

    final item = await Navigator.of(context).push(PageRouteBuilder(
      opaque: false, // set to false
      pageBuilder: (_, __, ___) => NewItem(),
    ));

    storageMap[nameKey] = item.name;
    storageMap[quantityKey] = item.quantity;

    tempList.add(storageMap);
    storeList.write('shoppingList', tempList);
    shoppingList.add(item);
  }

  void removeItem(int index) {
    storeList.remove('name$index');
    storeList.remove('quantity$index');
    shoppingList.removeAt(index);
    tempList.removeAt(index);
  }

  void restoreItems() {
    tempList = storeList.read('shoppingList');

    String nameKey, quantityKey;

    for (int i = 0; i < tempList.length; i++) {
      final map = tempList[i];
      final index = i;

      nameKey = 'name$index';
      quantityKey = 'quantity$index';

      final item = Item(name: map[nameKey], quantity: map[quantityKey]);

      shoppingList.add(item);
    }
  }

  void initializeSL() {
    if (storeList.hasData('shoppingList')) restoreItems();
  }
}
