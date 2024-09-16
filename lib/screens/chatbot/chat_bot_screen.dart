import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/models/chat_message.dart';
import 'package:reach_out_rural/models/doctor.dart';
import 'package:reach_out_rural/repository/api/api_repository.dart';
import 'package:reach_out_rural/screens/chatbot/message.dart';
import 'package:reach_out_rural/screens/chatbot/messasge_attachment_modal.dart';
import 'package:reach_out_rural/utils/size_config.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final api = ApiRepository();
  final List<ChatMessage> chatMessages = [demoChatMessages[0]];
  final TextEditingController _messageController = TextEditingController();
  int _currentMessageIndex = 0;

  void _sendMessage() async {
    final message = _messageController.text;
    if (message.isEmpty) {
      return;
    }
    final chatMessage = ChatMessage(
      text: message,
      isSender: true,
      messageType: ChatMessageType.text,
      messageStatus: MessageStatus.viewed,
    );
    setState(() {
      chatMessages.add(chatMessage);
    });
    _messageController.clear();
    Map<String, dynamic> data = {
      "text": message,
      "lang": "en",
    };
    final res = await api.chatbot(data);
    final textResponse = res['text_response'];
    log(textResponse);
    final botMessage = ChatMessage(
      text: textResponse,
      isSender: false,
      messageType: ChatMessageType.text,
      messageStatus: MessageStatus.viewed,
    );
    setState(() {
      chatMessages.add(botMessage);
    });
    final nearbyDoctors0 = res['doctors'] as List<dynamic>?;
    if (nearbyDoctors0!.isNotEmpty) {
      final nearbyDoctors = nearbyDoctors0
          .map((doctor) => Doctor.fromJson(doctor as Map<String, dynamic>))
          .toList();
      String doctors = "Here are some nearby doctors\n\n";
      int i = 1;
      for (final doctor in nearbyDoctors) {
        doctors += "${i++}) ${doctor.name} - ${doctor.specialization}\n";
        doctors += "+${doctor.phoneNumber}\n";
        doctors += "Experience: ${doctor.experienceYears} years\n";
        doctors += "${doctor.locationName}\n\n";
      }
      final doctorMessage = ChatMessage(
        text: doctors.trimRight(),
        isSender: false,
        messageType: ChatMessageType.text,
        messageStatus: MessageStatus.viewed,
      );
      setState(() {
        chatMessages.add(doctorMessage);
      });
    }
  }

  void _showAttachmentModal() async {
    final result = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => const MessageAttachmentModal());
    if (result == null) return;
    final file = result[0] as File;
    final type = result[1] as ChatMessageType;
    final chatMessage = ChatMessage(
      text: file.path.split('/').last,
      isSender: true,
      messageType: type,
      messageStatus: MessageStatus.viewed,
      attachment: file.path,
    );
    final botChatReply = ChatMessage(
      text: chatResponse[_currentMessageIndex++],
      isSender: false,
      messageType: ChatMessageType.text,
      messageStatus: MessageStatus.viewed,
    );
    setState(() {
      chatMessages.add(chatMessage);
      chatMessages.add(botChatReply);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
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
            onPressed: () {
              context.push('/voice');
            },
          ),
          IconButton(
            icon: const Icon(Iconsax.video),
            onPressed: () {
              context.push('/video');
            },
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
                itemCount: chatMessages.length,
                itemBuilder: (context, index) =>
                    Message(message: chatMessages[index]),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
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
                    controller: _messageController,
                    style: const TextStyle(fontSize: 16, color: kBlackColor),
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle:
                          const TextStyle(fontSize: 16, color: kGreyColor),
                      prefixIcon: IconButton(
                          splashColor: kPrimaryColor.withOpacity(0.3),
                          focusColor: kPrimaryColor.withOpacity(0.3),
                          hoverColor: kPrimaryColor.withOpacity(0.3),
                          highlightColor: kPrimaryColor.withOpacity(0.3),
                          onPressed: () {},
                          icon: const Icon(
                            Iconsax.microphone_2,
                            color: kBlackColor,
                          )),
                      suffixIcon: IconButton(
                          onPressed: _showAttachmentModal,
                          splashColor: kPrimaryColor.withOpacity(0.3),
                          focusColor: kPrimaryColor.withOpacity(0.3),
                          hoverColor: kPrimaryColor.withOpacity(0.3),
                          highlightColor: kPrimaryColor.withOpacity(0.3),
                          icon: const Icon(Iconsax.paperclip,
                              color: kBlackColor)),
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
                    backgroundColor:
                        WidgetStateProperty.all<Color>(kPrimaryColor),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  onPressed: _sendMessage,
                  padding: const EdgeInsets.all(14),
                  icon: const Icon(
                    Iconsax.send_1,
                    color: kWhiteColor,
                    size: 28,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
