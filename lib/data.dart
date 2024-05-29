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
