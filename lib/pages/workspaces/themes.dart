import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData.dark();

ThemeData mainTheme = ThemeData(
    brightness: Brightness.light,
    //primaryColor: Colors.blue,
    primarySwatch: Colors.blueGrey,
    iconTheme: IconThemeData(color: Colors.black),
    fontFamily: "Montserrat-Bold",
    textTheme: const TextTheme(
        subtitle1: TextStyle(
            fontFamily: "Montserrat-SemiBold",
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black),
        subtitle2: TextStyle(
            fontFamily: "Montserrat-Medium",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black54))
);

ThemeData pinkTheme = mainTheme.copyWith(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFFF49FB6),
);

ThemeData halloweenTheme = mainTheme.copyWith(
  primaryColor: const Color(0xFF55705A),
  scaffoldBackgroundColor: const Color(0xFFE48873),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    foregroundColor: Color(0xFFea8e71),
    backgroundColor: Color(0xFF2b2119),
  ),
);

ThemeData darkBlueTheme = ThemeData.dark().copyWith(
  primaryColor: const Color(0xFF1E1E2C),
  scaffoldBackgroundColor: const Color(0xFF2D2D44),
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      color: Color(0xFF33E1Ed),
    ),
  ),
);