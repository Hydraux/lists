import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lists/Pages/new_item.dart';
import 'package:lists/main.dart';
import '../Item.dart';
import '../item_card.dart';

class ShoppingList extends StatefulWidget {
  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  static final storeList = GetStorage();
  List<Item> shoppingList = [];
  List tempList = [];

  void _addItem() async {
    final storageMap = {};
    final index = shoppingList.length;
    final nameKey = 'name$index';
    final quantityKey = 'quantity$index';

    final item = await Navigator.of(context).push(PageRouteBuilder(
      opaque: false, // set to false
      pageBuilder: (_, __, ___) => NewItem(),
    ));

    storageMap[nameKey] = item.name;
    storageMap[quantityKey] = item.quantity;

    tempList.add(storageMap);
    setState(() {
      storeList.write('shoppingList', tempList);
      shoppingList.add(item);
    });
  }

  void _removeItem(int index) {
    storeList.remove('name$index');
    storeList.remove('quantity$index');
    setState(() {
      shoppingList.removeAt(index);
      tempList.removeAt(index);
    });
  }

  void restoreItems() {
    tempList = storeList.read('shoppingList');

    String nameKey, quantityKey;

    for (int i = 0; i < tempList.length; i++) {
      final map = tempList[i];
      final index = i;

      nameKey = 'name$index';
      quantityKey = 'quantity$index';

      final item = Item(name: map[nameKey], quantity: map[quantityKey]);

      shoppingList.add(item);
    }
  }

  void initState() {
    super.initState();
    if (storeList.hasData('shoppingList')) restoreItems();
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
          itemCount: shoppingList.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                setState(() {
                  _removeItem(index);
                });
              },
              child: itemCard(
                item: shoppingList[index],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addItem();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
