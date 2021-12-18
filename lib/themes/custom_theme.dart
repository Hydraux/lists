import 'package:flutter/material.dart';

final ThemeData lightTheme = buildLightTheme();
final ThemeData darkTheme = buildDarkTheme();

ThemeData buildLightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
      focusColor: Colors.yellow,
      iconTheme: IconThemeData(color: Colors.white),
      colorScheme: ColorScheme.fromSwatch(accentColor: Colors.amberAccent),
      textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white), bodyText2: TextStyle(color: Colors.white)),
      secondaryHeaderColor: Colors.blue.shade500,
      dividerColor: Colors.transparent,
      appBarTheme: AppBarTheme(color: Colors.blue.shade800),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.blue.shade800,
        unselectedItemColor: Colors.black,
      ),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: Colors.blue.shade700, foregroundColor: Colors.white),
      cardColor: Colors.blue.shade700,
      cardTheme: CardTheme(
        elevation: 5,
      ),
      hintColor: Colors.white,
      dialogBackgroundColor: Colors.blue.shade800,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue.shade500))));
}

ThemeData buildDarkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
      focusColor: Colors.greenAccent.shade700,
      colorScheme: ColorScheme.fromSwatch(accentColor: Colors.red),
      textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white), bodyText2: TextStyle(color: Colors.white)),
      secondaryHeaderColor: Colors.deepPurpleAccent.shade200,
      dividerColor: Colors.transparent,
      backgroundColor: Color(0x121212),
      scaffoldBackgroundColor: Color.fromRGBO(18, 18, 18, 1),
      appBarTheme: AppBarTheme(color: Color.fromRGBO(255, 255, 255, 0.10)),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.greenAccent.shade700, unselectedItemColor: Colors.white),
      bottomAppBarColor: Color.fromRGBO(255, 255, 255, 0.10),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.deepPurpleAccent.shade700,
        foregroundColor: Colors.white,
      ),
      cardColor: Colors.deepPurpleAccent.shade700,
      cardTheme: CardTheme(
        elevation: 5,
      ),
      dialogBackgroundColor: Colors.deepPurpleAccent.shade700,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent))));
}
