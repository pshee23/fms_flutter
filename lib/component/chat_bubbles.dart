import 'package:flutter/material.dart';

import '../model/chat_message.dart';

class ChatBubbles extends StatelessWidget {
  const ChatBubbles({
    required this.chatMessage,
    required this.isRead,
    required this.isMe,
    super.key});

  final ChatMessage chatMessage;
  final bool isRead;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    bool isNotice = false;
    if(chatMessage.type != 'CHAT') {
      isNotice = true;
    }
    if(isNotice) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(12)
            ),
            width: 300,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Text(
                chatMessage.content,
                style: TextStyle(
                    color: Colors.white,
                ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Text(isRead ? '' : '1'),
          Container(
            decoration: BoxDecoration(
              color: isMe ? Colors.grey[300] : Colors.blue,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                  bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0)
              ),
            ),
            width: 145,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Text(
                chatMessage.content,
                style: TextStyle(
                    color: isMe ? Colors.black : Colors.white
                )
            ),
          ),
        ],
      );
    }
  }
}
