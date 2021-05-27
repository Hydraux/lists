import 'package:flutter/material.dart';
import 'package:lists/Themes/config.dart';
import 'shopping_list.dart';
import 'Themes/custom_theme.dart';
import 'Themes/config.dart';

void main() => runApp(
      myApp(),
    );

class myApp extends StatefulWidget {
  @override
  _myAppState createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShoppingList(),
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: currentTheme.currentTheme,
    );
  }
}
