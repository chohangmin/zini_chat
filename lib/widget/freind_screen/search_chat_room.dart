import 'package:flutter/material.dart';
import 'package:zini_chat/widget/message/messages.dart';
import 'package:zini_chat/widget/message/send_message.dart';

class SearchChatRoom extends StatelessWidget {
  const SearchChatRoom(
      {super.key,
      required this.currentUserId,
      required this.opponentUserId});

  
  final String opponentUserId;

  final String currentUserId;

  @override
  Widget build(BuildContext context) {
  
    List<String> userIds = [currentUserId, opponentUserId];
    userIds.sort();
    String chatRoomId = userIds[0] + userIds[1];


    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Messages(
                  chatRoomId: chatRoomId,
                  currentUserId: currentUserId,
                  type: "chatRoom")),
          SendMessage(chatRoomId: chatRoomId, currentUserId: currentUserId,),
        ],
      ),
    );
  }
}
