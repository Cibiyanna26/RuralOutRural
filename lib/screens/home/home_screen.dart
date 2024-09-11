import 'package:flutter/material.dart';
import 'package:reach_out_rural/screens/home/chatbot/chatbot.dart';
import 'package:reach_out_rural/screens/home/scannerpage/scanner_page.dart';
import 'package:reach_out_rural/screens/home/dashboard/dashboard.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isListening = false;
  String _recognizedText = "";
  SpeechToText _speech = SpeechToText();
  late BuildContext _dialogContext; // Context for the dialog

  final List<Widget> _pages = [
    DashboardPage(),
    ChatBotPage(),
    ScannerPage(),
  ];

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

  // Open modal dialog when voice recognition starts
  void _showListeningDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        _dialogContext = context; // Save context for dialog
        return AlertDialog(
          title: Text("Listening..."),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text(
                _recognizedText.isEmpty
                    ? "Please say something..."
                    : _recognizedText,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _speech.stop();
                Navigator.pop(context);
                setState(() {
                  _isListening = false;
                });
              },
              child: Text("Stop Listening"),
            ),
          ],
        );
      },
    );
  }

  void _startListening() async {
    if (!_isListening) {
      setState(() {
        _recognizedText = ""; // Clear previous recognized text
        _isListening = true;
      });
      bool available = await _speech.initialize();
      if (available) {
        _showListeningDialog(); // Show the dialog when listening starts
        _speech.listen(onResult: _onSpeechResult);
      }
    } else {
      _speech.stop();
      setState(() {
        _isListening = false;
      });
      Navigator.pop(_dialogContext); // Close the dialog
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _recognizedText = result.recognizedWords; // Update subtitle in real-time
    });

    // Update the dialog content
    if (_isListening) {
      Navigator.of(_dialogContext).pop(); // Close current dialog
      _showListeningDialog(); // Show new dialog with updated text
    }

    // Navigate based on the recognized command
    final command = result.recognizedWords.toLowerCase();
    if (command.contains('chat')) {
      setState(() {
        _selectedIndex = 1; // Navigate to ChatBotPage
      });
    } else if (command.contains('scan') || command.contains('wound')) {
      setState(() {
        _selectedIndex = 2; // Navigate to ScannerPage
      });
    } else if (command.contains('home')) {
      setState(() {
        _selectedIndex = 0; // Navigate to DashboardPage
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt), label: 'Scanner'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startListening,
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
