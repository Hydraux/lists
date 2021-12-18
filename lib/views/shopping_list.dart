import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/auth_controller.dart';
import 'package:lists/controllers/items_controller.dart';
import 'package:lists/views/units_page.dart';
import 'package:lists/widgets/dark_mode_button.dart';

class ShoppingList extends StatelessWidget {
  final controller = Get.find<ItemsController>(tag: 'shoppingList');
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppBar(title: Center(child: Text('Shopping List')), actions: <Widget>[darkModeButton()]),
      Obx(() => ReorderableListView(
            shrinkWrap: true,
            onReorder: (oldIndex, newIndex) => controller.reorderList(oldIndex, newIndex),
            children: controller.itemWidgets,
          ))
    ]);
  }
}
