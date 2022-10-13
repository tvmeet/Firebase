import 'package:flutter/material.dart';

class TextStyleTheme {

  /*static TextStyle customTextStyle(
      Color color, double size, FontWeight fontWeight) {
    return TextStyle(
        fontFamily: "TH Sarabun New Regular", //Your font name
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
        decoration: TextDecoration. none);
  }*/
  static Text customText(String text,double size,Color color,FontWeight fontWeight){
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: fontWeight),
    );
  }
}