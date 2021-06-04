import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomTheme {
  ThemeData lightTheme = ThemeData(
    primaryColor: Colors.grey,
    accentColor: Colors.blue,
    cardColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.black),
      hintStyle: TextStyle(color: Colors.black),
    ),
  ); //lightTheme

  ThemeData darkTheme = ThemeData(
      primaryColor: Colors.blueGrey[800],
      brightness: Brightness.dark,
      accentColor: Colors.blueGrey[800],
      cardColor: Colors.blueGrey[800],
      canvasColor: Colors.blueGrey[800],
      backgroundColor: Colors.blueGrey[900],
      scaffoldBackgroundColor: Colors.blueGrey[900],
      textTheme: ThemeData.dark().textTheme,
      iconTheme: ThemeData.dark().iconTheme,
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.white),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blueGrey[700])); //darkTheme

}
