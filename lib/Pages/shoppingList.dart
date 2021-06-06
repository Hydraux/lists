import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/Models/Items/ItemCard.dart';
import 'package:lists/Models/shoppingList.dart';
import 'package:lists/controllers/shoppingList.dart';

class ShoppingList extends GetView<SLController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Center(child: Text('Shopping List')),
          actions: <Widget>[darkModeButton()]),
      body: ListView.separated(
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
              editMode: true,
              listType: 'Shopping List',
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(
          color: Theme.of(context).primaryColor,
          thickness: 3,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.addItem(context);
        },
        child: Icon(Icons.add),
        heroTag: ShoppingList,
      ),
    );
  }
}
