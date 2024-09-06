import 'package:flutter/material.dart';
import 'package:reach_out_rural/constants/constants.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton(
      {super.key,
      required this.width,
      required this.height,
      required this.fontSize,
      required this.text,
      required this.press});
  final String text;
  final VoidCallback press;
  final double width;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: kprimaryColor),
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
