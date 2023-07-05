import 'package:flutter/material.dart';
const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
  50: Color(0xFFF7F5F0),
  100: Color(0xFFEAE6D9),
  200: Color(0xFFDCD6C0),
  300: Color(0xFFCEC5A7),
  400: Color(0xFFC4B894),
  500: Color(_primaryPrimaryValue),
  600: Color(0xFFB2A579),
  700: Color(0xFFAA9B6E),
  800: Color(0xFFA29264),
  900: Color(0xFF938251),
});
const int _primaryPrimaryValue = 0xFFB9AC81;

const MaterialColor primaryAccent = MaterialColor(_primaryAccentValue, <int, Color>{
  100: Color(0xFFFFFDF6),
  200: Color(_primaryAccentValue),
  400: Color(0xFFFFE290),
  700: Color(0xFFFFDB76),
});
const int _primaryAccentValue = 0xFFFFEFC3;