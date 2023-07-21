import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  static const String fontName = 'WorkSans';
  static const Color primaryColor = Color(0xff3653B9);

  static final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        color: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontFamily: fontName,
          fontWeight: FontWeight.w500,
          fontSize: 20,
          color: primaryColor,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: Color(0xffFFA62E),
      ));
}
