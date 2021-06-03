import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/Pages/newItem.dart';
import 'package:lists/Models/Item.dart';
import 'package:lists/Pages/Item.dart';

class SLController extends GetxController {
  final storeList = GetStorage();
  List tempList = [].obs;
  List<Item> shoppingList = [];

  @override
  void onInit() {
    super.onInit();

    restoreItems();
  }

  int get shoppingListLength => shoppingList.length;

  void addItem(context) async {
    final storageMap = {};
    final index = shoppingList.length;
    final nameKey = 'name$index';
    final quantityKey = 'quantity$index';

    final item = await Get.toNamed('/shoppingList/newItem');

    if (item == null) return; //cancel was pressed
    storageMap[nameKey] = item.name.value;
    storageMap[quantityKey] = item.quantity.value;

    tempList.add(storageMap);
    storeList.write('shoppingList', tempList);
    shoppingList.add(item);
  }

  void updateValue(int index) {
    final storageMap = {};
    final nameKey = 'name$index';
    final quantityKey = 'quantity$index';
    Item item = shoppingList[index];
    storageMap[nameKey] = item.name.string;
    storageMap[quantityKey] = item.quantity.value.toInt();

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

      String nameKey, quantityKey;

      for (int i = 0; i < tempList.length; i++) {
        final map = tempList[i];
        final index = i;

        nameKey = 'name$index';
        quantityKey = 'quantity$index';

        final item = Item(input: map[nameKey]);

        shoppingList.add(item);
        shoppingList[index].quantity.value = map[quantityKey];
      }
    }
  }
}
