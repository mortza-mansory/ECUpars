import 'package:flutter/material.dart';

class AppTheme {
  static const nightBackground = Color.fromRGBO(44, 45, 49, 1);
  static const nightIconCard = Color.fromRGBO(84, 84, 84, 1);

  static const dayBackground = Color.fromRGBO(255, 255, 255, 1.0);
  static const dayIconCard = Color.fromRGBO(255, 242, 226, 1);

  static const ecuColor = Color.fromRGBO(255, 107, 107, 1);

  static const nightParsColor = Colors.white;
  static const dayParsColor = Colors.black;

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: nightBackground,
    iconTheme: IconThemeData(color: Colors.white)
  );

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: dayBackground,
    cardColor: dayIconCard,
  );
}
