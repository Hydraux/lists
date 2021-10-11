import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/shopping_list_controller.dart';
import '../../models/items/item.dart';

class ItemCard extends StatelessWidget {
  final ShoppingListController controller = Get.find();
  final RxBool _editMode = true.obs;
  final int index;
  final Item item;
  final String listType;

  ItemCard({
    required this.item,
    required this.index,
    required bool editMode,
    required this.listType,
  }) {
    this._editMode.value = editMode;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Get.toNamed('/ModifyItem', arguments: item);
        controller.updateValue(index);
      },
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() => Text(item.name.value.toString(),
                  style: TextStyle(fontSize: 20))),
            ),
          ),
          Expanded(
            flex: 0,
            child: Container(
                height: 30.0,
                child: Center(
                    child: Obx(
                  () => Text(
                    '${item.quantity} ${item.unit}',
                    style: TextStyle(fontSize: 20),
                  ),
                ))),
          ),
        ],
      ),
    );
  }
}
