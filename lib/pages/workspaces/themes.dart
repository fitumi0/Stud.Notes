import 'package:flutter/material.dart';

const mainColor = 0xFFA5AEFF;
const subColor = 0xFFC8E4FE;
const wheatColor = 0xFFebebeb;
const lightGrey = 0xFFC8C8C8;


Map<int, Color> color =
{
  50:Color.fromRGBO(0,0,0, .1),
  100:Color.fromRGBO(0,0,0, .2),
  200:Color.fromRGBO(0,0,0, .3),
  300:Color.fromRGBO(0,0,0, .4),
  400:Color.fromRGBO(0,0,0, .5),
  500:Color.fromRGBO(0,0,0, .6),
  600:Color.fromRGBO(0,0,0, .7),
  700:Color.fromRGBO(0,0,0, .8),
  800:Color.fromRGBO(0,0,0, .9),
  900:Color.fromRGBO(0,0,0, 1),
};

ThemeData darkTheme = ThemeData.dark();

ThemeData mainTheme = ThemeData(
  appBarTheme: AppBarTheme(
    centerTitle: true,
  ),
    brightness: Brightness.light,
    primarySwatch: MaterialColor(mainColor, color),

    iconTheme: IconThemeData(color: Color(wheatColor)),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(mainColor),
    ),
    fontFamily: "Montserrat-SemiBold",
    textTheme: TextTheme(
        subtitle1: TextStyle(
            fontFamily: "Montserrat-Regular",
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black),
    )
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