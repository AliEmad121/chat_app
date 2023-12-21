import 'package:chat_app/components/custom_scaffold.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(title: "Chats",body: Container(height: 100,width: 100,
      color: Colors.red),);
  }
}