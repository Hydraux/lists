import 'package:flutter/material.dart';
import 'package:lists/Themes/config.dart';
import 'Item.dart';
import 'item_card.dart';

class ShoppingList extends StatefulWidget {
  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List<Item> shoppingList = [
    Item(name: 'This is an item', quantity: 1),
    Item(name: 'This is an item', quantity: 1),
    Item(name: 'This is an item', quantity: 1),
  ];

  void addItem() {
    setState(() {
      shoppingList.add(Item(name: 'added', quantity: 2));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Center(child: Text('Shopping List')),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                currentTheme.toggleTheme();
              },
              icon: Icon(Icons.dark_mode),
            )
          ]),
      body: ListView.builder(
          itemCount: shoppingList.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.startToEnd,
              onDismissed: (direction) {
                setState(() {
                  shoppingList.removeAt(index);
                });
              },
              child: itemCard(
                item: shoppingList[index],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addItem();
        },
        child: Icon(Icons.add),
        //backgroundColor: Colors.blueGrey[800],
      ),
    );
  }
}
