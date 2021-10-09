import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/controllers/shopping_list_controller.dart';
import 'package:lists/widgets/item/item_card.dart';
import 'package:lists/widgets/dark_mode_button.dart';

class ShoppingList extends GetView<ShoppingListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            child: Card(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: ItemCard(
                  item: controller.shoppingList[index],
                  index: index,
                  editMode: true,
                  listType: 'Shopping List',
                ),
              ),
            ),
          );
        },
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
