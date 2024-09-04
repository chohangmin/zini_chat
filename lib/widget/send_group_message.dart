import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendGroupMessage extends StatefulWidget {
  const SendGroupMessage({super.key, required this.chatRoomId});

  final String chatRoomId;

  @override
  State<SendGroupMessage> createState() => _SendGroupMessageState();
}

class _SendGroupMessageState extends State<SendGroupMessage> {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

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
        .doc(currentUserId)
        .get();
    currentUserName = userDocs.data()!['userName'];
    currentUserImage = userDocs.data()!['userImage'];
  }

  void _enteringChat() {
    text = myController.text;
    print('Test chat $text');
  }

  void _sendMessage() async {
    final chatDocRef = await FirebaseFirestore.instance
        .collection('groupChatRoom')
        .doc(widget.chatRoomId)
        .get();

    print("test 1");

    if (!chatDocRef.exists) {
      FirebaseFirestore.instance
          .collection('groupChatRoom')
          .doc(widget.chatRoomId)
          .set({});

      FirebaseFirestore.instance
          .collection('groupChatRoom')
          .doc(widget.chatRoomId)
          .collection('messages')
          .add({
        'text': text,
        'time': Timestamp.now(),
        'userId': currentUserId,
        'userName': currentUserName,
        'userImage': currentUserImage,
      });

      print("test 2");

      myController.clear();
    }
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
