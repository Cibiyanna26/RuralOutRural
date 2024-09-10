import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/models/chat_message.dart';
import 'package:reach_out_rural/screens/chatbot/message.dart';
import 'package:reach_out_rural/screens/chatbot/messasge_attachment_modal.dart';

class ChatBotScreen extends StatelessWidget {
  const ChatBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: kPrimaryColor,
        foregroundColor: kWhiteColor,
        title: Row(
          children: [
            SvgPicture.asset(
              "assets/icons/chatbot.svg",
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Chat Bot",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "Active 3m ago",
                  style: TextStyle(fontSize: 12),
                )
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.call),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Iconsax.video),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: demoChatMessages.length,
                itemBuilder: (context, index) =>
                    Message(message: demoChatMessages[index]),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const ChatInputField(),
        ],
      ),
    );
  }
}

class ChatInputField extends StatelessWidget {
  const ChatInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: kBlackColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type your message...',
                prefixIcon: IconButton(
                    splashColor: kPrimaryColor.withOpacity(0.3),
                    focusColor: kPrimaryColor.withOpacity(0.3),
                    hoverColor: kPrimaryColor.withOpacity(0.3),
                    highlightColor: kPrimaryColor.withOpacity(0.3),
                    onPressed: () {},
                    icon: const Icon(Iconsax.microphone_2)),
                suffixIcon: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => const MessageAttachmentModal());
                    },
                    splashColor: kPrimaryColor.withOpacity(0.3),
                    focusColor: kPrimaryColor.withOpacity(0.3),
                    hoverColor: kPrimaryColor.withOpacity(0.3),
                    highlightColor: kPrimaryColor.withOpacity(0.3),
                    icon: const Icon(Iconsax.paperclip)),
                filled: true,
                fillColor: Colors.blueGrey[50],
                labelStyle: const TextStyle(fontSize: 12),
                contentPadding: const EdgeInsets.all(20),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey[50]!),
                  borderRadius: BorderRadius.circular(25),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey[50]!),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(kPrimaryColor),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            onPressed: () {},
            padding: const EdgeInsets.all(14),
            icon: const Icon(
              Iconsax.send_1,
              color: kWhiteColor,
              size: 28,
            ),
          )
        ],
      ),
    );
  }
}
