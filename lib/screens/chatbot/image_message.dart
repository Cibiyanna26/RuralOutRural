import 'package:flutter/material.dart';
import 'package:reach_out_rural/constants/constants.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      child: AspectRatio(
        aspectRatio: 1.6,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Material(
              child: Ink.image(
                  image: const AssetImage("assets/images/bp-check.jpg"),
                  fit: BoxFit.cover,
                  child: InkWell(
                    splashColor: kPrimaryColor.withOpacity(0.3),
                    hoverColor: kPrimaryColor.withOpacity(0.3),
                    focusColor: kPrimaryColor.withOpacity(0.3),
                    highlightColor: kPrimaryColor.withOpacity(0.3),
                    overlayColor: WidgetStateProperty.all(
                      kPrimaryColor.withOpacity(0.3),
                    ),
                    onTap: () {},
                  )),
            )),
      ),
    );
  }
}
