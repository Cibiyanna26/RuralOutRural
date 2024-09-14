import 'package:flutter/material.dart';
import 'package:reach_out_rural/constants/constants.dart';

class DefaultButtonLoader extends StatelessWidget {
  const DefaultButtonLoader(
      {super.key,
      required this.width,
      required this.height,
      required this.fontSize,
      required this.text,
      required this.press,
      required this.isLoading});
  final bool isLoading;
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
                foregroundColor: kWhiteColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: kPrimaryColor),
            onPressed: isLoading ? null : press,
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(kWhiteColor),
                      backgroundColor: kPrimaryColor,
                    ),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: kWhiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )));
  }
}
