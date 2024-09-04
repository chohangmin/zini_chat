import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zini_chat/widget/add_group.dart';
import 'package:zini_chat/widget/group_chat_list.dart';
import 'package:zini_chat/widget/search_group_chat_room.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

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
          const Expanded(
            child: GroupChatList(),
          ),
          AddGroup(selectedUsers: _selectedUsers),
        ],
      ),
    );
  }
}
