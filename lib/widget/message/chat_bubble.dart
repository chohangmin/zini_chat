
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble(
      {super.key,
      required this.text,
      required this.userImage,
      required this.userName,
      required this.isMe});

  final String text;
  final String userImage;
  final bool isMe;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: const Radius.circular(20),
                    topLeft: const Radius.circular(20),
                    bottomLeft: isMe
                        ? const Radius.circular(20)
                        : const Radius.circular(0),
                    bottomRight: isMe
                        ? const Radius.circular(0)
                        : const Radius.circular(20)),
                color: isMe ? Colors.blue : Colors.grey[400],
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 50,
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Positioned(
            top: 35,
            right: isMe ? 5 : null,
            left: isMe ? null : 5,
            child: CircleAvatar(
              backgroundImage: NetworkImage(userImage),
            )),
      ],
    );
  }
}
