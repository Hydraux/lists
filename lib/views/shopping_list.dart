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
        child: Obx(() => ReorderableListView.builder(
              shrinkWrap: true,
              onReorder: (oldIndex, newIndex) => controller.reorderList(oldIndex, newIndex),
              itemBuilder: (context, index) => controller.buildItemTile(controller.items[index]),
              itemCount: controller.items.length,
            )),
      )
    ]);
  }
}
