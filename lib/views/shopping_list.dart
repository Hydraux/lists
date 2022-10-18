import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/items_controller.dart';

class ShoppingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ItemsController>(tag: 'shoppingList');
    return Column(children: [
      AppBar(
        centerTitle: true,
        title: Text('Shopping List'),
      ),
      Expanded(
        child: Obx(() => ReorderableListView(
              shrinkWrap: true,
              onReorder: (oldIndex, newIndex) => controller.reorderList(oldIndex, newIndex),
              children: controller.getListItems(),
            )),
      )
    ]);
  }
}
