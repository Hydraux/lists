import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/shopping_list_controller.dart';
import 'package:lists/widgets/dark_mode_button.dart';

class ShoppingList extends GetView<ShoppingListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(child: Text('Shopping List')),
          actions: <Widget>[darkModeButton()]),
      body: ReorderableListView(
        onReorder: controller.reorderList,
        children: controller.getListItems(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.addItem();
        },
        child: Icon(Icons.add),
        heroTag: ShoppingList,
      ),
    );
  }
}
