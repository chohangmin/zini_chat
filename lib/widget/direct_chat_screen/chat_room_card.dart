import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoomCard extends StatelessWidget {
  const ChatRoomCard(
      {required this.latestMessage, required this.opponentUserInfo, super.key});

  final DocumentSnapshot<Map<String, dynamic>>? opponentUserInfo;
  final Map<String, dynamic> latestMessage;

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
              SizedBox(
                width: 30,
                height: 30,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(opponentUserInfo!['userImage']),
                ),
              ),
              Text(opponentUserInfo!['userName']),
            ],
          ),
        ),
        title: Text(
          latestMessage['text'],
        ),
        trailing: Text(
          latestMessage['time'].toDate().toString(),
        ),
      ),
    );
  }
}
