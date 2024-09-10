import 'package:flutter/material.dart';
import 'package:reach_out_rural/constants/constants.dart';

class VideoMessage extends StatelessWidget {
  const VideoMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                  child: Ink.image(
                      image:
                          const AssetImage("assets/images/bp-check-doctor.jpg"),
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
                      ))),
            ),
            Container(
              height: 25,
              width: 25,
              decoration: const BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                size: 16,
                color: kWhiteColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
