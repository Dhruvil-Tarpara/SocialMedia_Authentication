import 'package:flutter/material.dart';

class ConstTheme {
  ConstTheme._();

  static final ConstTheme theme = ConstTheme._();

  ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green.shade100,
        ),
        primaryColor: const Color(0xffDddddd),
        primaryColorLight: const Color(0x1aF5E0C3),
        primaryColorDark: const Color(0xff936F3E),
        canvasColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        cardColor: const Color(0xaaF5E0C3),
        dividerColor: const Color(0x1f6D42CE),
        focusColor: const Color(0x1aF5E0C3),
        hoverColor: const Color(0xffDEC29B),
        highlightColor: const Color(0xff936F3E),
      );

  ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
        ),
        primaryIconTheme: const IconThemeData(color: Colors.white),
        indicatorColor: Colors.white,
        brightness: Brightness.dark,
        primaryColor: Colors.green,
        primaryColorLight: Colors.black,
        primaryColorDark: const Color(0xff936F3E),
        canvasColor: Colors.white,
        scaffoldBackgroundColor: Colors.black,
      );
}
