import 'package:flutter/material.dart';

class GroupChatRoomCard extends StatelessWidget {
  const GroupChatRoomCard(
      {required this.latestMessage, required this.chatRoomName, super.key});

  final Map<String, dynamic> latestMessage;
  final String chatRoomName;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          margin: const EdgeInsets.all(1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 30,
                height: 30,
                child: CircleAvatar(),
              ),
              Text(
                chatRoomName,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        title: Text(latestMessage['text']),
        trailing: Text(latestMessage['time'].toDate().toString()),
      ),
    );
  }
}
