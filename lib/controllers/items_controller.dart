import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/models/item.dart';
import 'package:lists/models/recipe.dart';
import 'package:lists/views/item_form.dart';
import 'package:lists/widgets/item_card.dart';
import 'package:intl/intl.dart';

class ItemsController extends GetxController {
  final RxList<Item> items = RxList<Item>([]);
  final itemStorage = GetStorage();
  final String tag;
  final RxList _storageList = RxList([]);
  final Recipe? recipe;
  final NumberFormat nf = NumberFormat.decimalPattern();
  String storageName = '';

  List get storageList => _storageList;

  ItemsController({required this.tag, this.recipe});

  @override
  void onInit() {
    super.onInit();
    setStoragePath();

    restoreItems();
  }

  void setStoragePath() {
    if (tag == 'shoppingList') {
      storageName = 'items';
    } else if (tag == 'ingredients') {
      storageName = recipe!.id + ':ingredients';
    }
  }

  List<Widget> getListItems() =>
      items.asMap().map((i, item) => MapEntry(i, _buildDismissableTile(item, i))).values.toList();

  Widget _buildDismissableTile(Item item, int index) {
    return Card(
      color: tag == 'shoppingList' ? Theme.of(Get.context!).cardColor : Theme.of(Get.context!).secondaryHeaderColor,
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
          child: GestureDetector(
            onTap: () async {
              Item? temp = await Get.dialog(ItemForm(item: item, type: 'Modify'));
              if (temp != null) {
                item = item.copyWith(name: temp.name, quantity: temp.quantity, unit: temp.unit);
                updateValues(item);
              }
            },
            child: ItemCard(
              item: items[index],
              index: index,
              editMode: true,
            ),
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

    updateValues(items[oldIndex]);
    updateValues(items[newIndex]);
  }

  void addItem() async {
    Item? item = Item(id: DateTime.now().toString());

    item = await Get.dialog(ItemForm(
      item: item,
      type: 'New',
    ));

    if (item == null) return; //cancel was pressed

    items.add(item);
    updateValues(item);
  }

  void removeItem(int index) {
    Item item = items.removeAt(index);

    _storageList.removeWhere((element) => element['id'] == item.id);
    itemStorage.write(storageName, _storageList);
  }

  void updateValues(Item item) {
    final Map storageMap = {};

    // separates values for json storage
    storageMap['name'] = item.name;
    storageMap['quantity'] = item.quantity;
    storageMap['unit'] = item.unit;
    storageMap['id'] = item.id;

    // stores json values for getstorage
    int index = _storageList.indexWhere((element) => element['id'] == item.id);
    items[items.indexWhere((element) => element.id == item.id)] = item;

    if (index == -1) //item not found
    {
      _storageList.add(storageMap);
    } else {
      _storageList[index] = storageMap;
    }

    itemStorage.write(storageName, _storageList);
  }

  void restoreItems() {
    if (itemStorage.hasData(storageName)) {
      _storageList.value = itemStorage.read(storageName);

      _storageList.forEach((element) {
        Item item =
            Item(id: element['id'], name: element['name'], quantity: element['quantity'], unit: element['unit']);
        items.add(item);
      });
    }
  }
}
