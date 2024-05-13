import 'package:flutter/material.dart';

/// TODO: Should be aded to a utils repo
class ProfileMiniature extends StatefulWidget {
  final String? pictureUrl;
  final double size;
  const ProfileMiniature({super.key, required this.pictureUrl, this.size = 20});

  @override
  State<ProfileMiniature> createState() => _ProfileMiniatureState();
}

class _ProfileMiniatureState extends State<ProfileMiniature> {
  late ImageProvider<Object> _image;

  @override
  void initState() {
    _image = widget.pictureUrl == null
        ? const AssetImage('assets/images/user_placeholder.png',
            package: "arbenn_chat")
        : NetworkImage(widget.pictureUrl!) as ImageProvider<Object>;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CircleAvatar(
        backgroundImage: _image,
        onBackgroundImageError: ((exception, stackTrace) => setState(
              () => _image =
                  const AssetImage('assets/images/user_placeholder.png'),
            )),
      ),
    );
  }
}

class ValueNotifierList<T> extends ValueNotifier<List<T>> {
  ValueNotifierList(super.value);

  void add(T valueToAdd) {
    value = [...value, valueToAdd];
  }

  void remove(T valueToRemove) {
    value = value.where((value) => value != valueToRemove).toList();
  }
}

class ChatMessageData {
  final DateTime date;
  final String message;
  final int senderId;
  final String senderName;
  final String? pictureUrl;

  const ChatMessageData({
    required this.senderName,
    required this.senderId,
    required this.date,
    required this.message,
    this.pictureUrl,
  });

  static ChatMessageData ofJson(Map<String, dynamic> json) {
    return ChatMessageData(
      date: DateTime.parse(json["send_date"]),
      message: json["content"],
      senderId: json["authorid"],
      senderName: json["first_name"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "send_date": date.toString(),
      "first_name": senderName,
      "content": message,
      "authorid": senderId
    };
  }
}

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
      child: SizedBox(
        width: width * 0.5,
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
