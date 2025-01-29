import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  static const String fontName = 'WorkSans';
  static const Color primaryColor = Color(0xff3653B9);
  static const Color secondaryYellowColor = Color(0xffffa62e);
  static const Color darkYellowColor = Color(0xffDD6F4E);
  static const Color darkBlueColor = Color(0xff29278C);

  static final ThemeData lightTheme = ThemeData(
      useMaterial3: true,

      // fontFamily: 'Gotham',
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        color: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(secondaryYellowColor),
          shadowColor: WidgetStateProperty.all(Colors.grey),
          textStyle: WidgetStateProperty.all(
            const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontFamily: fontName,
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Color.fromRGBO(0, 0, 0, 0.54),
          ),
          titleMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
          labelSmall: TextStyle(color: Color(0xff676677)),
          labelMedium: TextStyle(color: Color(0xff676677)),
          titleLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryYellowColor,
      ));
}
