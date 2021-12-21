import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/items_controller.dart';

class ShoppingList extends StatelessWidget {
  final controller = Get.find<ItemsController>(tag: 'shoppingList');
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppBar(
        centerTitle: true,
        title: Text('Shopping List'),
      ),
      Obx(() => ReorderableListView(
            shrinkWrap: true,
            onReorder: (oldIndex, newIndex) => controller.reorderList(oldIndex, newIndex),
            children: controller.itemWidgets,
          ))
    ]);
  }
}
