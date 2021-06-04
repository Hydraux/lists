import 'package:flutter/material.dart';
import 'package:lists/controllers/shoppingList.dart';

import '../main.dart';

Widget darkModeButton() => IconButton(
      onPressed: () {
        MyApp().toggleTheme();
      },
      icon: Icon(Icons.dark_mode),
    );
