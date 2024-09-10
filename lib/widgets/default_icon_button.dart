import 'package:flutter/material.dart';
import 'package:reach_out_rural/constants/constants.dart';

class DefaultIconButton extends StatelessWidget {
  const DefaultIconButton(
      {super.key,
      required this.width,
      required this.height,
      required this.fontSize,
      required this.text,
      required this.press,
      required this.icon});
  final String text;
  final VoidCallback press;
  final double width;
  final double height;
  final double fontSize;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(
            foregroundColor: kWhiteColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: kPrimaryColor),
        onPressed: press,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: kWhiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              icon,
              color: kWhiteColor,
              size: 30,
            )
          ],
        ),
      ),
    );
  }
}
