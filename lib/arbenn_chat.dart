import 'package:arbenn_chat/data.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final ChatMessageData data;
  final bool isCurrentUser;
  final bool showName;
  final String? pictureUrl;
  final bool showProfile;

  const ChatMessage({
    super.key,
    required this.data,
    this.isCurrentUser = false,
    this.showName = false,
    this.showProfile = false,
    this.pictureUrl,
  });

  Future<void> save() async {}

  Widget _buildName() {
    return Container(
        margin: const EdgeInsets.only(left: 40),
        child:
            Text(data.senderName, style: TextStyle(color: Colors.grey[500])));
  }

  Widget _buildMessage(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isCurrentUser ? Colors.blue : Colors.grey[200]),
      child: Container(
        constraints: BoxConstraints(maxWidth: width * 0.5),
        child: Text(
          data.message,
          textWidthBasis: TextWidthBasis.longestLine,
          style: TextStyle(
              color: isCurrentUser ? Colors.white : Colors.grey[800],
              fontSize: 15),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showName) _buildName(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isCurrentUser)
              SizedBox(
                width: 40,
                child: showProfile
                    ? ProfileMiniature(pictureUrl: pictureUrl, size: 30)
                    : null,
              ),
            _buildMessage(context),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          if (isCurrentUser) Expanded(child: Container()),
          _buildBody(context)
        ],
      ),
    );
  }
}

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
