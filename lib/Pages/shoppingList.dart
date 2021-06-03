import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/Pages/Item.dart';
import 'package:lists/Models/shoppingList.dart';
import 'package:lists/controllers/shoppingList.dart';

class ShoppingList extends GetView<SLController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Center(child: Text('Shopping List')),
          actions: <Widget>[darkModeButton()]),
      body: ListView.builder(
        itemCount: controller.shoppingListLength,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              controller.removeItem(index);
            },
            child: ItemCard(
              item: controller.shoppingList[index],
              index: index,
            ),
          );
        },
      ),
      floatingActionButton: addItemButton(controller, context),
    );
  }
}
