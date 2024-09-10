import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/screens/chatbot/chat_bot_screen.dart';
import 'package:reach_out_rural/screens/dashboard/dashboard_screen.dart';
import 'package:reach_out_rural/screens/prescription/prescription_screen.dart';
import 'package:reach_out_rural/screens/scanner/scanner_screen.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:reach_out_rural/widgets/custom_bottom_navbar.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

const List<Widget> _screens = <Widget>[
  DashboardScreen(),
  ChatBotScreen(),
  ScannerScreen(),
  PrescriptionScreen()
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isListening = false;
  late SpeechToText _speechToText;

  @override
  void initState() {
    super.initState();
    _speechToText = SpeechToText();
  }

  Future<void> _captureVoice() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });
        await _speechToText.listen(onResult: _onSpeechResult);
      }
    } else {
      setState(() {
        _isListening = false;
      });
      await _speechToText.stop();
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    final command = result.recognizedWords.toLowerCase();
    log(command);
    if (command.contains('home')) {
      setState(() {
        _currentIndex = 0; // Navigate to DashboardScreen
      });
    } else if (command.contains('chat')) {
      setState(() {
        _currentIndex = 1; // Navigate to ChatBotScreen
      });
    } else if (command.contains('scan') || command.contains('wound')) {
      setState(() {
        _currentIndex = 2; // Navigate to ScannerPage
      });
    } else if (command.contains('prescription')) {
      setState(() {
        _currentIndex = 3; // Navigate to PrescriptionPage
      });
    }
  }

  void _onPressed(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void dispose() {
    _speechToText.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavbar(
        isListening: _isListening,
        currentIndex: _currentIndex,
        onPressed: _onPressed,
        onCaptureVoice: _captureVoice,
      ),
    );
  }
}
