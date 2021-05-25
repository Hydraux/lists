import 'package:flutter/material.dart';
import 'Item.dart';
import 'item_card.dart';

void main() => runApp(MaterialApp(
  home: ShoppingList(),
));


class ShoppingList extends StatefulWidget {
  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {

  List<Item> shoppingList = [
    Item(name: 'This is an item', quantity: 1),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: Center(child: Text('Shopping List')),
        ),
      body: Column(
        children: shoppingList.map((item) => ItemCard(item: item)).toList(),
        )
      
    );
  }
}

