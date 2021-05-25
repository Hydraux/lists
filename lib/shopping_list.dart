import 'package:flutter/material.dart';
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

  

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: shoppingList.length,
        itemBuilder: (context, index){
          final item = shoppingList[index];
          return Dismissible(
            key: Key(item.toString()),
            onDismissed: (direction){
              setState((){
                shoppingList.removeAt(index);
              });
            },
            child: itemCard(
              item: shoppingList[index],
            ),
            
            );
        }
        );
  }
}
