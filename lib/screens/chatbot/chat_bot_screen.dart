import 'dart:developer';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/localization/language_constants.dart';
import 'package:reach_out_rural/models/chat_message.dart';
import 'package:reach_out_rural/models/doctor.dart';
import 'package:reach_out_rural/repository/api/api_repository.dart';
import 'package:reach_out_rural/screens/chatbot/message.dart';
import 'package:reach_out_rural/screens/chatbot/messasge_attachment_modal.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:reach_out_rural/utils/toast.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key, this.query});
  final String? query;

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final api = ApiRepository();
  final List<ChatMessage> chatMessages = [demoChatMessages[0]];
  final TextEditingController _messageController = TextEditingController();
  int _currentMessageIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _messageFocusNode = FocusNode();
  bool isRecording = false;
  final SpeechToText speech = SpeechToText();
  String _text = "";
  final toaster = ToastHelper();

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _sendMessage() async {
    _messageFocusNode.unfocus();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    _messageController.clear();
    final locale = await getLocale();
    Map<String, dynamic> data = {
      "text": message,
      "lang": locale.languageCode,
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  Future<void> _initSpeech() async {
    bool available = await speech.initialize();
    if (available) {
      setState(() {
        isRecording = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initQuery();
    _initSpeech();
  }

  void _initQuery() {
    if (widget.query == null) return;
    _messageController.text = widget.query!;
  }

  void _recordAudio() async {
    final locale = await getLocale();
    if (!isRecording) {
      bool available = await speech.initialize();
      if (available) {
        setState(() {
          isRecording = true;
        });
        await speech.listen(
          onResult: (result) {
            // _messageController.text = result.recognizedWords;
            _text = result.recognizedWords;
          },
          pauseFor: const Duration(seconds: 5),
          listenFor: const Duration(seconds: 10),
          listenOptions: SpeechListenOptions(
            enableHapticFeedback: true,
          ),
          localeId: locale
              .languageCode, // Set your locale based on the user's preferred language
        );
      }
    } else {
      _stopListening();
    }
  }

  void _sendAudio() async {
    final chatMessage = ChatMessage(
      text: _text,
      isSender: true,
      messageType: ChatMessageType.audio,
      messageStatus: MessageStatus.viewed,
    );
    setState(() {
      chatMessages.add(chatMessage);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    final locale = await getLocale();
    Map<String, dynamic> data = {
      "text": _text,
      "lang": locale.languageCode,
    };
    final res = await api.chatbot(data);
    final botChatReply = ChatMessage(
      text: res['text_response'],
      isSender: false,
      messageType: ChatMessageType.text,
      messageStatus: MessageStatus.viewed,
    );
    setState(() {
      chatMessages.add(botChatReply);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _audioConfirmationDialog() {
    _stopListening();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Audio Confirmation"),
        content: const Text("Are you sure you want to send this audio?"),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: _sendAudio,
            child: const Text("Send"),
          ),
        ],
      ),
    );
    context.pop();
  }

  void _stopListening() async {
    setState(() {
      isRecording = false;
    });
    await speech.stop();
  }

  void _showAttachmentModal() async {
    final result = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => const MessageAttachmentModal());
    _messageFocusNode.unfocus();
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
      text: chatResponse[_currentMessageIndex++ % chatResponse.length],
      isSender: false,
      messageType: ChatMessageType.text,
      messageStatus: MessageStatus.viewed,
    );
    setState(() {
      chatMessages.add(chatMessage);
      chatMessages.add(botChatReply);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    speech.stop();
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
                controller: _scrollController,
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
                    focusNode: _messageFocusNode,
                    controller: _messageController,
                    style: const TextStyle(fontSize: 16, color: kBlackColor),
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle:
                          const TextStyle(fontSize: 16, color: kGreyColor),
                      prefixIcon: AvatarGlow(
                        animate: isRecording,
                        glowColor: kPrimaryColor,
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 1000),
                        repeat: true,
                        child: GestureDetector(
                          onLongPress: _recordAudio,
                          onLongPressEnd: (details) {
                            _audioConfirmationDialog();
                          },
                          child: IconButton(
                              splashColor: kPrimaryColor.withOpacity(0.3),
                              focusColor: kPrimaryColor.withOpacity(0.3),
                              hoverColor: kPrimaryColor.withOpacity(0.3),
                              highlightColor: kPrimaryColor.withOpacity(0.3),
                              onPressed: () {},
                              icon: const Icon(
                                Iconsax.microphone_2,
                                color: kWhiteColor,
                              )),
                        ),
                      ),
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
                      contentPadding: const EdgeInsets.all(18),
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
