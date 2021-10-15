import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/models/item.dart';
import 'package:lists/views/item_form.dart';
import 'package:lists/widgets/item_card.dart';

class ItemsController extends GetxController {
  final itemStorage = GetStorage();

  List _storageList = [].obs;
  RxList<Item> items = RxList<Item>([]);

  @override
  void onInit() {
    super.onInit();

    restoreItems();
  }

  List<Widget> getListItems() => items
      .asMap()
      .map((i, item) => MapEntry(i, _buildDismissableTile(item, i)))
      .values
      .toList();

  Widget _buildDismissableTile(Item item, int index) {
    return Card(
      key: Key(item.id),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Dismissible(
        direction: DismissDirection.endToStart,
        key: UniqueKey(),
        onDismissed: (direction) {
          removeItem(index);
        },
        background: Container(
          color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.delete),
            ],
          ),
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: ItemCard(
            item: items[index],
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

    Item item = items.removeAt(oldIndex);
    items.insert(newIndex, item);

    updateValue(oldIndex);
    updateValue(newIndex);
  }

  void addItem() async {
    Item item = Item(id: DateTime.now().toString());
    item = await Get.to(() => ItemForm(
          item: item,
          type: 'New',
        ));
    if (item.name == '') return; //cancel was pressed

    items.add(item);
    updateValue(items.length);
  }

  void removeItem(int index) {
    items.removeAt(index);

    updateValue(index);
  }

  void updateValue(int index) {
    final storageMap = {};
    final nameKey = 'name';
    final quantityKey = 'quantity';
    final unitKey = 'unit';
    final idKey = 'id';
    final item = items[index];

    // separates values for json storage
    storageMap[nameKey] = item.name;
    storageMap[quantityKey] = item.quantity;
    storageMap[unitKey] = item.unit;
    storageMap[idKey] = item.id;

    // stores json values for getstorage
    _storageList[index] = storageMap;

    itemStorage.write('items', _storageList);
  }

  void restoreItems() {
    if (itemStorage.hasData('items')) {
      Map _storageList = itemStorage.read('items');

      _storageList.forEach((key, value) {
        items.add(value);
      });
    }
  }
}
