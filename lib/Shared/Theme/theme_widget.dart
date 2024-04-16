import 'package:flutter/material.dart';
import 'package:seventh_project/Shared/Theme/config.dart';

class themeData {
  static ThemeData light(BuildContext context) {
    return ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        hintColor: Color(0xff875b31),
        // hintColor: Color(0xff5e6a7a),
        hoverColor: Colors.grey.shade300,
        splashColor: Colors.grey.shade300,
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0.0,
            centerTitle: true,
            iconTheme: IconThemeData(size: context.IconSize),
            titleTextStyle:
                TextStyle(color: Colors.black, fontSize: context.LargeFont)),
        cardColor: Color(0xfff0eee2));
  }

  static ThemeData dark(BuildContext context) {
    return ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        hintColor: Colors.brown.shade200,
        // hintColor: Color(0xffb69067),
        // hintColor: Color(0xffa4abb6),
        hoverColor: Colors.grey.shade800,
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.black,
            elevation: 0.0,
            centerTitle: true,
            iconTheme: IconThemeData(size: context.IconSize),
            titleTextStyle:
                TextStyle(color: Colors.white, fontSize: context.LargeFont)),
        cardColor: Color(0xff403e32));
  }
}
