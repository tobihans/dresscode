import 'package:flutter/material.dart';

class CustomColors {
  static final raw = <String, int>{
    'primary': 0xFFFF3800,
    'primaryBg': 0xFFF8F9FA,
    'primaryText': 0xFF000000,
    'lightGreyBg': 0xFFF1F5F8,
  };

  static final material = <String, MaterialColor>{
    'primary': MaterialColor(raw['primary']!, const {
      50: Color.fromRGBO(255, 56, 0, .1),
      100: Color.fromRGBO(255, 56, 0, .2),
      200: Color.fromRGBO(255, 56, 0, .3),
      300: Color.fromRGBO(255, 56, 0, .4),
      400: Color.fromRGBO(255, 56, 0, .5),
      500: Color.fromRGBO(255, 56, 0, .6),
      600: Color.fromRGBO(255, 56, 0, .7),
      700: Color.fromRGBO(255, 56, 0, .8),
      800: Color.fromRGBO(255, 56, 0, .9),
      900: Color.fromRGBO(255, 56, 0, 1),
    }),
    'primaryBg': MaterialColor(raw['primaryBg']!, const {
      50: Color.fromRGBO(248, 249, 250, .1),
      100: Color.fromRGBO(248, 249, 250, .2),
      200: Color.fromRGBO(248, 249, 250, .3),
      300: Color.fromRGBO(248, 249, 250, .4),
      400: Color.fromRGBO(248, 249, 250, .5),
      500: Color.fromRGBO(248, 249, 250, .6),
      600: Color.fromRGBO(248, 249, 250, .7),
      700: Color.fromRGBO(248, 249, 250, .8),
      800: Color.fromRGBO(248, 249, 250, .9),
      900: Color.fromRGBO(248, 249, 250, 1),
    }),
    'primaryText': MaterialColor(raw['primaryText']!, const {
      50: Color.fromRGBO(0, 0, 0, .1),
      100: Color.fromRGBO(0, 0, 0, .2),
      200: Color.fromRGBO(0, 0, 0, .3),
      300: Color.fromRGBO(0, 0, 0, .4),
      400: Color.fromRGBO(0, 0, 0, .5),
      500: Color.fromRGBO(0, 0, 0, .6),
      600: Color.fromRGBO(0, 0, 0, .7),
      700: Color.fromRGBO(0, 0, 0, .8),
      800: Color.fromRGBO(0, 0, 0, .9),
      900: Color.fromRGBO(0, 0, 0, 1),
    }),
    'lightGreyBg': MaterialColor(raw['lightGreyBg']!, const {
      50: Color.fromRGBO(17, 24, 39, .1),
      100: Color.fromRGBO(17, 24, 39, .2),
      200: Color.fromRGBO(17, 24, 39, .3),
      300: Color.fromRGBO(17, 24, 39, .4),
      400: Color.fromRGBO(17, 24, 39, .5),
      500: Color.fromRGBO(17, 24, 39, .6),
      600: Color.fromRGBO(17, 24, 39, .7),
      700: Color.fromRGBO(17, 24, 39, .8),
      800: Color.fromRGBO(17, 24, 39, .9),
      900: Color.fromRGBO(17, 24, 39, 1),
    }),
  };
}
