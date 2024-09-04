import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zini_chat/widget/messages.dart';
import 'package:zini_chat/widget/send_group_message.dart';

class SearchGroupChatRoom extends StatelessWidget {
  const SearchGroupChatRoom({super.key, required this.invitedUsers});

  final Set<String> invitedUsers;

  @override
  Widget build(BuildContext context) {
    final List<String> listInvitedUsers = invitedUsers.toList();
    listInvitedUsers.sort();
    String chatRoomId = listInvitedUsers.join("");
    List<int> utf8bytes = utf8.encode(chatRoomId);
    if (utf8bytes.length <= 1500) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
                child: Messages(chatRoomId: chatRoomId, type: "groupChatRoom")),
            SendGroupMessage(
              chatRoomId: chatRoomId,
            )
          ],
        ),
      );
    }
    return const Text('Too many inviters...');
  }
}
