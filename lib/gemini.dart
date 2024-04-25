import 'package:flutter/material.dart';
import 'package:flutter_gemini_bot/flutter_gemini_bot.dart';
import 'package:flutter_gemini_bot/models/chat_model.dart';

class MyHomePageGEmini extends StatefulWidget {
  const MyHomePageGEmini({super.key, required this.title});
  final String title;

  @override
  State<MyHomePageGEmini> createState() => _MyHomePageGEminiState();
}

class _MyHomePageGEminiState extends State<MyHomePageGEmini> {
  List<ChatModel> chatList = []; // Your list of ChatModel objects
  String apiKey = 'AIzaSyAsxXfhRINP3rnkugQo8KN_MQCATxRhVcs';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FlutterGeminiChat(
        chatContext: 'you are a flutter app developer',
        chatList: chatList,
        apiKey: apiKey,
        botChatBubbleColor: Colors.black,
        userChatBubbleColor: Colors.black,
        botChatBubbleTextColor: Colors.white,
      ),
    );
  }
}
