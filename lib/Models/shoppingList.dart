import 'package:flutter/material.dart';
import 'package:lists/controllers/shoppingList.dart';

import '../main.dart';

Widget addItemButton(SLController controller, context) {
  return FloatingActionButton(
    onPressed: () {
      controller.addItem(context);
    },
    child: Icon(Icons.add),
  );
}

Widget darkModeButton() => IconButton(
      onPressed: () {
        MyApp().toggleTheme();
      },
      icon: Icon(Icons.dark_mode),
    );
