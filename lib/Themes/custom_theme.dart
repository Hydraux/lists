import 'package:flutter/material.dart';

class CustomTheme with ChangeNotifier {
  static bool _isDarkTheme = true;
  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Colors.grey,
      accentColor: Colors.blue,
      cardColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
    );
  } //lightTheme

  static ThemeData get darkTheme {
    return ThemeData(
      accentColor: Colors.blueGrey[800],
      cardColor: Colors.blueGrey[800],
      scaffoldBackgroundColor: Colors.blueGrey[900],
      textTheme: ThemeData.dark().textTheme,
      iconTheme: ThemeData.dark().iconTheme,
    );
  } //darkTheme
}
