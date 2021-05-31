import 'dart:ui';

import 'package:flutter/material.dart';

import '../Models/Item.dart';

class NewItem extends StatefulWidget {
  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final itemName = TextEditingController();
  final itemQuantity = TextEditingController();

  @override
  void dispose() {
    itemName.dispose();
    itemQuantity.dispose();
    super.dispose();
  }

  Item makeItem() {
    Item newItem = new Item();
    newItem.name = itemName.text;
    newItem.quantity = int.parse(itemQuantity.text);
    return newItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Theme.of(context).backgroundColor,
              ),
              height: 200,
              width: 300,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        autofocus: true,
                        controller: itemName,
                        decoration: InputDecoration(
                          labelText: 'New Item: ',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: itemQuantity,
                        decoration: InputDecoration(
                          labelText: 'Quantity: ',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context, makeItem());
                              },
                              icon: Icon(Icons.check_circle)),
                          new Spacer(),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.cancel))
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ));
  }
}
