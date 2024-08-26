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
    final userData1 = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user1)
        .get();
    final userData2 = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user2)
        .get();
    print('test 2');

    final chatDocRef = await FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatRoomId)
        .get();

    if (!chatDocRef.exists) {
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(widget.chatRoomId)
          .set({});

      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(widget.chatRoomId)
          .collection('usersInfo')
          .add({
        'user1Id': userData1.data()!['userId'],
        'user1Name': userData1.data()!['userName'],
        'user1Image': userData1.data()!['userImage'],
        'user2Id': userData2.data()!['userId'],
        'user2Name': userData2.data()!['userName'],
        'user2Image': userData2.data()!['userImage'],
      });
    }

    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatRoomId)
        .collection('messages')
        .add(
      {
        'text': text,
        'time': Timestamp.now(),
        'userId': currentUser,
        'userName': userData1.data()!['userName'],
        'userImage': userData1.data()!['userImage'],
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
