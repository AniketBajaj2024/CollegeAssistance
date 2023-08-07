import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class DialogflowService {
  static Future<String> sendMessage(String message) async {
    final dialogflowURL =
        'https://dialogflow.googleapis.com/v2/projects/your-project-id/agent/sessions/your-session-id:detectIntent';
    final headers = {
      'Authorization': 'Bearer your-dialogflow-access-token',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'queryInput': {
        'text': {'text': message, 'languageCode': 'en'}
      }
    });

    final response =
        await http.post(Uri.parse(dialogflowURL), headers: headers, body: body);
    return response.body;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot App',
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();
  List<String> _chatHistory = [];

  void _sendMessage() async {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _chatHistory.add('You: $message');
      setState(() {});

      String chatbotResponse = await DialogflowService.sendMessage(message);
      var responseJson = json.decode(chatbotResponse);
      String chatbotMessage = responseJson['queryResult']['fulfillmentText'];

      _chatHistory.add('Chatbot: $chatbotMessage');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chatbot Demo')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(_chatHistory[index]));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(labelText: 'Message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
