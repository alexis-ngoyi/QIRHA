import 'package:flutter/material.dart';

Color formatColor(String originalHexCode) {
  // Convert hexadecimal color code to Color
  Color color = Color(int.parse(originalHexCode.replaceAll("#", "0x")));

  // Extract RGB values
  int red = color.red;
  int green = color.green;
  int blue = color.blue;

  return Color.fromARGB(255, red, green, blue);
}
