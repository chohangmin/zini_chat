import 'package:flutter/material.dart';
import 'package:zini_chat/widget/messages.dart';
import 'package:zini_chat/widget/send_message.dart';

class SearchChatRoom extends StatelessWidget {
  const SearchChatRoom({super.key, required this.user1, required this.user2});

  final String user1;
  final String user2;

  @override
  Widget build(BuildContext context) {
    List<String> userIds = [user1, user2];
    userIds.sort();
    String chatRoomId = userIds[0] + userIds[1];

    return Scaffold(
      body: Column(
        children: [
          Expanded(child: Messages(chatRoomId)),
          SendMessage(chatRoomId),
        ],
      ),
    );
  }
}
