import 'package:flutter/material.dart';

final ThemeData lightTheme = buildLightTheme();
final ThemeData darkTheme = buildDarkTheme();

ThemeData buildLightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
      colorScheme: ColorScheme.fromSwatch(accentColor: Colors.amberAccent),
      textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white)),
      secondaryHeaderColor: Colors.blue.shade500,
      dividerColor: Colors.transparent,
      appBarTheme: AppBarTheme(color: Colors.blue.shade800),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.blue.shade800,
        selectedItemColor: Colors.yellowAccent,
        unselectedItemColor: Colors.white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue.shade700, foregroundColor: Colors.white),
      cardColor: Colors.blue.shade700,
      cardTheme: CardTheme(
        elevation: 5,
      ),
      hintColor: Colors.white,
      dialogBackgroundColor: Colors.blueGrey.shade600,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Colors.blue.shade500))));
}

ThemeData buildDarkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
      colorScheme: ColorScheme.fromSwatch(accentColor: Colors.red),
      textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white)),
      secondaryHeaderColor: Colors.white,
      dividerColor: Colors.transparent,
      backgroundColor: Color(0x121212),
      scaffoldBackgroundColor: Color.fromRGBO(18, 18, 18, 1),
      appBarTheme: AppBarTheme(color: Color.fromRGBO(255, 255, 255, 0.10)),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.10),
          selectedItemColor: Colors.greenAccent.shade700),
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
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Colors.deepPurpleAccent))));
}
