import 'package:flutter/material.dart';

class SizeConfig {
  SizeConfig._();

  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late TextScaler textScaleFactor;
  static Orientation? orientation;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    textScaleFactor = _mediaQueryData.textScaler;
  }

  static double getProportionateScreenWidth(double inputWidth) =>
      (inputWidth / 375.0) * screenWidth;

  static double getProportionateScreenHeight(double inputHeight) =>
      (inputHeight / 812.0) * screenHeight;

  static double getProportionateTextSize(double inputTextSize) =>
      textScaleFactor.scale(inputTextSize);
}
