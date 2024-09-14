import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/models/chat_message.dart';

class MessageAttachmentModal extends StatefulWidget {
  const MessageAttachmentModal({super.key});

  @override
  State<MessageAttachmentModal> createState() => _MessageAttachmentModalState();
}

class _MessageAttachmentModalState extends State<MessageAttachmentModal> {
  void _pickImage() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      final File file = File(result.files.single.path!);
      const ChatMessageType messageType = ChatMessageType.image;
      if (!mounted) return;
      context.pop([file, messageType]);
    }
  }

  void _pickVideo() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (result != null) {
      final File file = File(result.files.single.path!);
      const ChatMessageType messageType = ChatMessageType.video;
      if (!mounted) return;
      context.pop([file, messageType]);
    }
  }

  void _pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'png', 'jpg'],
    );
    if (result != null) {
      final File file = File(result.files.single.path!);
      const ChatMessageType messageType = ChatMessageType.file;
      if (!mounted) return;
      context.pop([file, messageType]);
    }
  }

  void _pickAudio() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result != null) {
      final File file = File(result.files.single.path!);
      const ChatMessageType messageType = ChatMessageType.audio;
      if (!mounted) return;
      context.pop([file, messageType]);
    }
  }

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
                      press: _pickImage,
                      iconData: Iconsax.image,
                      title: "Image",
                    ),
                    MessageAttachmentCard(
                      press: _pickVideo,
                      iconData: Iconsax.video,
                      title: "Video",
                    ),
                    MessageAttachmentCard(
                      press: _pickFile,
                      iconData: Iconsax.document_text,
                      title: "File",
                    ),
                    MessageAttachmentCard(
                      press: _pickAudio,
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
