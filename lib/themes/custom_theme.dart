import 'package:flutter/material.dart';

final ThemeData lightTheme = buildLightTheme();
final ThemeData darkTheme = buildDarkTheme();

ThemeData buildLightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
      //focusColor: Colors.yellow,
      dialogTheme: DialogTheme(backgroundColor: Colors.blue.shade800),
      iconTheme: IconThemeData(color: Colors.white),
      colorScheme: ColorScheme.fromSwatch(accentColor: Colors.amberAccent),
      textTheme:
          TextTheme(bodyText1: TextStyle(color: Colors.white, fontSize: 20), bodyText2: TextStyle(color: Colors.black)),
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
      dialogTheme: DialogTheme(backgroundColor: Colors.grey[850]),
      errorColor: Color(0xFFCA5369),
      //focusColor: Colors.yellow.shade100,
      colorScheme: ColorScheme.fromSwatch(
        accentColor: Colors.amber.shade100,
      ),
      textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.amber.shade200, fontSize: 20),
          bodyText2: TextStyle(color: Colors.blue.shade200)),
      secondaryHeaderColor: Colors.grey.shade800,
      dividerColor: Colors.transparent,
      backgroundColor: Color(0x121212),
      scaffoldBackgroundColor: Color.fromRGBO(18, 18, 18, 1),
      appBarTheme: AppBarTheme(
          color: Colors.grey.shade900,
          foregroundColor: Colors.amber.shade200,
          iconTheme: IconThemeData(color: Colors.amber.shade200)),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.amber.shade200,
        unselectedItemColor: Colors.white,
      ),
      bottomAppBarColor: Colors.grey.shade900,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.grey.shade800,
        foregroundColor: Colors.blue.shade200,
      ),
      // //cardColor: Colors.blue.shade400,
      cardTheme: CardTheme(
        elevation: 5,
        color: Colors.grey.shade800,
      ),
      dialogBackgroundColor: Colors.grey.shade900,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueAccent.shade100))));
}
