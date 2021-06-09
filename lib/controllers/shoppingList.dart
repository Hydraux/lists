import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/Models/Items/Item.dart';

class SLController extends GetxController {
  final storeList = GetStorage();
  List tempList = [].obs;
  List<Item> shoppingList = [];
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    restoreItems();
  }

  int get shoppingListLength => shoppingList.length;

  void addItem(context) async {
    final item = await Get.toNamed('/shoppingList/newItem');
    final storageMap = {};
    final nameKey = 'name';
    final quantityKey = 'quantity';
    final unitKey = 'unit';
    final UIDKey = 'UID';

    if (item == null) return; //cancel was pressed
    storageMap[nameKey] = item.name.value;
    storageMap[quantityKey] = item.quantity.value;
    storageMap[UIDKey] = item.UID;
    storageMap[unitKey] = item.unit.string;

    tempList.add(storageMap);
    storeList.write('shoppingList', tempList);
    shoppingList.add(item);
  }

  void updateValue(int index) {
    final storageMap = {};

    final nameKey = 'name';
    final quantityKey = 'quantity';
    final unitKey = 'unit';

    Item item = shoppingList[index];

    storageMap[nameKey] = item.name.string;
    storageMap[quantityKey] = item.quantity.value.toInt();
    storageMap[unitKey] = item.unit.string;

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

      String nameKey, quantityKey, unitKey;

      for (int i = 0; i < tempList.length; i++) {
        final map = tempList[i];
        final index = i;

        nameKey = 'name';
        quantityKey = 'quantity';
        unitKey = 'unit';

        final item = Item(input: map[nameKey], unit: map[unitKey]);

        shoppingList.add(item);
        shoppingList[index].quantity.value = map[quantityKey];
      }
    }
  }
}
