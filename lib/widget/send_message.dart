import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendMessage extends StatefulWidget {
  const SendMessage(this.chatRoomId, {super.key});

  final String chatRoomId;

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final user1 = FirebaseAuth.instance.currentUser;
  String user2 = 'AAAAAA';
  final myController = TextEditingController();
  String text = '';

  @override
  void initState() {
    super.initState();
    myController.addListener(_enteringChat);
  }

  @override
  void dispose() {
    myController.clear();
    super.dispose();
  }

  void _enteringChat() {
    text = myController.text;
    print('Test Chat $text');
  }

  void _sendMessage() async {
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user1!.uid)
        .get();

    List<String> userIds = [user1!.uid, user2];
    userIds.sort();
    String chatRoomId = userIds[0] + userIds[1];

    await FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection('messages')
        .add(
      {
        'text': text,
        'time': Timestamp.now(),
        'userID': user1!.uid,
        'userName': userData.data()!['userName'],
        'userImage': userData.data()!['userImage'],
      },
    );

    myController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: TextField(
            controller: myController,
          ),
        ),
        IconButton(
          onPressed: text.trim().isEmpty ? null : _sendMessage,
          icon: const Icon(
            Icons.send,
            color: Colors.blue,
          ),
          color: Colors.blue,
        )
      ],
    );
  }
}
