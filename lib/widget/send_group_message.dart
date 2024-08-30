import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendGroupMessage extends StatefulWidget {
  const SendGroupMessage({super.key, required this.chatRoomId});

  final String chatRoomId;

  @override
  State<SendGroupMessage> createState() => _SendGroupMessageState();
}

class _SendGroupMessageState extends State<SendGroupMessage> {
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
    print('Test chat $text');
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
