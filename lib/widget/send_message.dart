import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendMessage extends StatefulWidget {
  const SendMessage(
      {super.key, required this.chatRoomId, required this.currentUserId});

  final String chatRoomId;
  final String currentUserId;

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  late final currentUserName;
  late final currentUserImage;

  final myController = TextEditingController();
  String text = '';

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    myController.addListener(_enteringChat);
  }

  @override
  void dispose() {
    myController.clear();
    super.dispose();
  }

  void _getUserInfo() async {
    final userDocs = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentUserId)
        .get();
    currentUserName = userDocs.data()!['userName'];
    currentUserImage = userDocs.data()!['userImage'];
  }

  void _enteringChat() {
    text = myController.text;
    print('Test Chat $text');
  }

  void _sendMessage() async {
    final chatDocRef = await FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatRoomId)
        .get();

    if (!chatDocRef.exists) {
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(widget.chatRoomId)
          .set({});
    }

    FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatRoomId)
        .collection('messages')
        .add(
      {
        'text': text,
        'time': Timestamp.now(),
        'userId': widget.currentUserId,
        'userName': currentUserName,
        'userImage': currentUserImage,
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
