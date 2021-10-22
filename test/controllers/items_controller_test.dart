import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/controllers/items_controller.dart';
import 'package:lists/models/item.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/views/item_form.dart';
import 'package:mockito/mockito.dart';

void main() {
  test('Given a tag when setStoragePath() is called then proper storage name is set', () async {
    //Arrange
    ItemsController slcontroller = ItemsController(tag: 'shoppingList');
    ItemsController ilcontroller = ItemsController(tag: 'ingredients', recipe: Recipe(id: 'id', name: 'name'));
    //Act
    slcontroller.setStoragePath();
    ilcontroller.setStoragePath();

    //Assert
    expect(slcontroller.storageName, 'items');
    expect(ilcontroller.storageName, ilcontroller.recipe!.id + ':ingredients');
  });

  test(
      'Given a list of 3 items, when the first is moved to the end of the list then the order of items is second, third, first',
      () {
    //Arrange
    final ItemsController controller = ItemsController(tag: 'shoppingList');
    final Item first = Item(id: 'first', name: 'first', quantity: 1);
    final Item second = Item(id: 'second', name: 'second', quantity: 2);
    final Item third = Item(id: 'third', name: 'third', quantity: 3);

    controller.items.add(first);
    controller.items.add(second);
    controller.items.add(third);

    final int oldIndex = 0;
    final int newIndex = 3;

    //Act
    controller.reorderList(oldIndex, newIndex);

    //Assert
    expect(controller.items, [second, third, first]);
  });

  test('Given a list of 3 items and an index, when removeItem is called the item is properly removed', () {
    //Arrange
    final ItemsController controller = ItemsController(tag: 'shoppingList');
    final Item first = Item(id: 'first', name: 'first', quantity: 1);
    final Item second = Item(id: 'second', name: 'second', quantity: 2);
    final Item third = Item(id: 'third', name: 'third', quantity: 3);
    final int index = 1;
    final RxList storageMap;

    controller.onInit();
    controller.items.addAll([first, second, third]);
    controller.updateValues(first);
    controller.updateValues(second);
    controller.updateValues(third);

    //Act
    storageMap = controller.itemStorage.read('items');

    controller.removeItem(index);

    //Assert
    expect(controller.items.indexOf(second), -1);
    expect(controller.storageList.indexWhere((element) => element['id'] == second.id), -1);
    expect(storageMap[index]['name'] == second.name, false);
  });

  test('Given an item when updateValues is called then the item is properly written to storage', () {
    //Arrange
    final Item item = Item(id: 'id', name: 'name', quantity: 1);
    final ItemsController controller = ItemsController(tag: 'shoppingList');
    final RxList storageMap;

    controller.onInit();
    controller.items.add(item);

    //Act
    controller.updateValues(item);
    storageMap = controller.itemStorage.read('items');

    //Assert
    expect(controller.storageList.indexWhere((element) => element['name'] == item.name), 0);
    expect(storageMap[0]['name'], item.name);
  });

  test('Given itemStorage, when restoreItems is called, the proper list of items is added to ItemController.items', () {
    //Arrange
    final Item first = Item(id: 'first', name: 'first', quantity: 1);
    final Item second = Item(id: 'second', name: 'second', quantity: 2);
    final Item third = Item(id: 'third', name: 'third', quantity: 3);
    final List<Item> items = RxList([first, second, third]);
    final ItemsController controller = ItemsController(tag: 'shoppingList');
    final List<Map> storageList = [
      {'id': first.id, 'name': first.name, 'quantity': first.quantity, 'unit': first.unit},
      {'id': second.id, 'name': second.name, 'quantity': second.quantity, 'unit': second.unit},
      {'id': third.id, 'name': third.name, 'quantity': third.quantity, 'unit': third.unit},
    ];

    controller.itemStorage.write('items', storageList);

    //Act
    controller.onInit();

    //Assert

    expect(controller.items[0].id, items[0].id);
    expect(controller.items[0].name, items[0].name);
    expect(controller.items[0].quantity, items[0].quantity);
    expect(controller.items[1].id, items[1].id);
    expect(controller.items[1].name, items[1].name);
    expect(controller.items[1].quantity, items[1].quantity);
    expect(controller.items[2].id, items[2].id);
    expect(controller.items[2].name, items[2].name);
    expect(controller.items[2].quantity, items[2].quantity);
  });
}
