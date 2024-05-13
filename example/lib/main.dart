import 'package:arbenn_chat/data.dart';
import 'package:flutter/material.dart';
import 'package:arbenn_chat/arbenn_chat.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ValueNotifierList<ChatMessageData> messages;

  @override
  void initState() {
    super.initState();
    messages = ValueNotifierList([]);
  }

  addMessage() {
    messages.add(ChatMessageData(
        senderName: "Nicolas",
        senderId: 2,
        date: DateTime.now(),
        message:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry."));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: ArbennChat(
                    currentUserId: 1,
                    messages: messages,
                  ),
                ),
                TextButton(onPressed: addMessage, child: const Text("clickme"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
