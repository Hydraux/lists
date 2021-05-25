import 'package:flutter/material.dart';
import 'shopping_list.dart';


void main() => runApp(MaterialApp(
  home: MyApp(),
));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: Center(child: Text('Shopping List')),
        ),
      body: ShoppingList(),
      
    );
  }
}

