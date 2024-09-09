import 'package:flutter/material.dart';
import 'package:reach_out_rural/screens/home/chatbot/chatbot.dart';
import 'package:reach_out_rural/screens/home/scannerpage/scanner_page.dart';
import 'package:reach_out_rural/screens/home/dashboard/dashboard.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:reach_out_rural/screens/home/prescription_page/prescription_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isListening = false;
  final List<Widget> _pages = [
    DashboardPage(),
    ChatBotPage(),
    ScannerPage(),
    PrescriptionPage(),
  ];
  SpeechToText _speech = SpeechToText();

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {});
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(onResult: _onSpeechResult);
      }
    } else {
      _speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    final command = result.recognizedWords.toLowerCase();
    if (command.contains('chat')) {
      setState(() {
        _selectedIndex = 1; // Navigate to ChatBotPage
      });
    } else if (command.contains('scan') || command.contains('wound')) {
      setState(() {
        _selectedIndex = 2; // Navigate to ScannerPage
      });
    } else if (command.contains('prescription')) {
      setState(() {
        _selectedIndex = 3; // Navigate to PrescriptionPage
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: Icon(Icons.chat),
              color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
              onPressed: () => _onItemTapped(1),
            ),
            Spacer(),
            FloatingActionButton(
              onPressed: _startListening,
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
              ),
              backgroundColor: Colors.blue,
              elevation: 8.0,
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.camera_alt),
              color: _selectedIndex == 2 ? Colors.blue : Colors.grey,
              onPressed: () => _onItemTapped(2),
            ),
            IconButton(
              icon: Icon(Icons.report),
              color: _selectedIndex == 3 ? Colors.blue : Colors.grey,
              onPressed: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
