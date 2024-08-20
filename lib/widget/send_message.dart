import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendMessage extends StatefulWidget {
  const SendMessage(
      {super.key,
      required this.chatRoomId,
      required this.user1,
      required this.user2});

  final String chatRoomId;
  final String user1;
  final String user2;

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;

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
    print('test 1');
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .get();
    print('test 2');

    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatRoomId)
        .collection('messages')
        .add(
      {
        'text': text,
        'time': Timestamp.now(),
        'userID': currentUser,
        'userName': userData.data()!['userName'],
        'userImage': userData.data()!['userImage'],
      },
    );
    print('test 3');

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
          onPressed: () {
            if (text.trim().isEmpty) {
              print("Button is disabled, text is empty");
            } else {
              print("Button is enabled, sending message");
              _sendMessage();
            }
          },
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
