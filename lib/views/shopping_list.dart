import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/items_controller.dart';
import 'package:lists/views/units_page.dart';
import 'package:lists/widgets/dark_mode_button.dart';
import 'package:lists/widgets/list_reorderable.dart';

class ShoppingList extends StatelessWidget {
  final controller = Get.find<ItemsController>(tag: 'shoppingList');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              tooltip: 'Units',
              onPressed: () {
                Get.to(() => UnitsPage());
              },
              icon: Icon(Icons.adjust),
            ),
            title: Center(child: Text('Shopping List')),
            actions: <Widget>[darkModeButton()]),
        body: ListReorderable(controller: controller));
  }
}
