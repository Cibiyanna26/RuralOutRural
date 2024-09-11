import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:reach_out_rural/constants/constants.dart'; // To decode JSON response

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false; // To show loading spinner when waiting for response

  // Method to handle sending messages
  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        // Add user message to the chat
        _messages.add({"sender": "user", "message": _controller.text});
        _isLoading = true; // Show loading spinner
      });

      final userMessage = _controller.text;
      _controller.clear(); // Clear the input field after sending

      // Send the message to the backend and get the response
      final botResponse = await _getBotResponse(userMessage);

      setState(() {
        _messages.add({"sender": "bot", "message": botResponse});
        _isLoading = false; // Hide loading spinner
      });
    }
  }

  // Method to send request to backend and get the bot response
  Future<String> _getBotResponse(String userMessage) async {
    const String apiUrl = BASE_URL + TEXT_TO_TEXT; // API endpoint

    try {
      print(apiUrl);
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            {"text": userMessage, "lang": "en"}), // Send user input as JSON
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data[
            'text_response']; // Assume the backend sends a 'response' field
      } else {
        return 'Error: Unable to get response from bot';
      }
    } catch (e) {
      return 'Error: Something went wrong';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Bot'),
      ),
      body: Column(
        children: [
          // Expanded list of messages
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message['sender'] == 'user';

                return Align(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUserMessage ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message['message']!,
                      style: TextStyle(
                        color: isUserMessage ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(), // Show loading indicator
            ),
          // Input area for typing a message
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Text field for input
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
                  onPressed: _sendMessage, // Call sendMessage method
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter your message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Send button
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: ChatBotPage()));
}
