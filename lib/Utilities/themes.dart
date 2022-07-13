import 'package:flutter/material.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primarySwatch: Colors.blueGrey,
    colorScheme: const ColorScheme.light(),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blueGrey,
    ),
    primaryColor: Colors.blueGrey,
  );

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white60,   
    colorScheme: const ColorScheme.dark(),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black12,
    ),
  );
}
