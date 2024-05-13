import 'package:arbenn_chat/data.dart';
import 'package:flutter/material.dart';

class ArbennChat extends StatelessWidget {
  final int currentUserId;
  final ValueNotifierList<ChatMessageData> messages;
  final ScrollController? controller;

  const ArbennChat({
    super.key,
    required this.messages,
    required this.currentUserId,
    this.controller,
  });

  Widget _buildList(List<ChatMessageData> messages) {
    List<Widget> messagesWidgets = [];
    for (var i = 0; i < messages.length; i++) {
      final m = messages[i];
      final isCurrentUser = m.senderId == currentUserId;
      final showProfile = !isCurrentUser &&
          (i == messages.length - 1 ||
              messages[i + 1].senderId != messages[i].senderId);
      messagesWidgets.add(ChatMessage(
        data: m,
        isCurrentUser: isCurrentUser,
        showProfile: showProfile,
        showName: !isCurrentUser &&
            (i == 0 || messages[i - 1].senderId != messages[i].senderId),
        pictureUrl: showProfile ? m.pictureUrl : null,
      ));
    }
    return ListView(
      controller: controller,
      children: messagesWidgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: messages,
        builder: (BuildContext context, List<ChatMessageData> messages, _) {
          return _buildList(messages);
        });
  }
}
