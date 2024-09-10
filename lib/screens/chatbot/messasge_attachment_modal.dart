import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';

class MessageAttachmentModal extends StatelessWidget {
  const MessageAttachmentModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 150,
        width: double.infinity,
        child: Card(
          margin: const EdgeInsets.all(18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MessageAttachmentCard(
                      press: () {
                        Navigator.pop(context);
                      },
                      iconData: Iconsax.image,
                      title: "Image",
                    ),
                    MessageAttachmentCard(
                      press: () {
                        Navigator.pop(context);
                      },
                      iconData: Iconsax.video,
                      title: "Video",
                    ),
                    MessageAttachmentCard(
                      press: () {
                        Navigator.pop(context);
                      },
                      iconData: Iconsax.document_text,
                      title: "File",
                    ),
                    MessageAttachmentCard(
                      press: () {
                        Navigator.pop(context);
                      },
                      iconData: Iconsax.music,
                      title: "Audio",
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

class MessageAttachmentCard extends StatelessWidget {
  final VoidCallback press;
  final IconData iconData;
  final String title;

  const MessageAttachmentCard(
      {super.key,
      required this.press,
      required this.iconData,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              child: Icon(
                iconData,
                size: 29,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .color!
                    .withOpacity(0.8),
                fontVariations: [const FontVariation.weight(700)],
              ),
            )
          ],
        ),
      ),
    );
  }
}
