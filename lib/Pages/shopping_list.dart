import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lists/Models/Item.dart';
import 'package:lists/Models/item_card.dart';
import 'package:lists/controllers/shoppingList_controller.dart';
import 'package:lists/main.dart';
import 'package:lists/controllers/shoppingList_controller.dart';

class ShoppingList extends StatefulWidget {
  final SLController controller = SLController();

  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  void initState() {
    super.initState();
    widget.controller.initializeSL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Center(child: Text('Shopping List')),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                MyApp().toggleTheme();
              },
              icon: Icon(Icons.dark_mode),
            )
          ]),
      body: ListView.builder(
          itemCount: widget.controller.shoppingListLength,
          itemBuilder: (context, index) {
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                setState(() {
                  widget.controller.removeItem(index);
                });
              },
              child: itemCard(
                item: widget.controller.shoppingList[index],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.controller.addItem(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
