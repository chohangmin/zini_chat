import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zini_chat/widget/group_chat_screen/add_group.dart';
import 'package:zini_chat/widget/group_chat_screen/group_chat_list.dart';
import 'package:zini_chat/widget/message/search_group_chat_room.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({required this.currentUserId, super.key});

  final String currentUserId;

  @override
  State<GroupChatScreen> createState() => _GroupChatListState();
}

class _GroupChatListState extends State<GroupChatScreen> {
  final Set<String> _selectedUsers = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GroupChatList(
              currentUserId: widget.currentUserId,
            ),
          ),
          AddGroup(
            selectedUsers: _selectedUsers,
            currentUserId: widget.currentUserId,
          ),
        ],
      ),
    );
  }
}
