import 'package:flutter/material.dart';

import '../main.dart';

Widget darkModeButton() => IconButton(
      onPressed: () {
        MyApp().toggleTheme();
      },
      icon: Icon(Icons.dark_mode),
    );
