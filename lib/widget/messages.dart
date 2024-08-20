import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zini_chat/widget/chat_bubble.dart';

class Messages extends StatelessWidget {
  const Messages(this.chatRoomId, {super.key});

  final String chatRoomId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('time')
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data == null) {
          return const Center(
            child: Text('Snapshot data is null'),
          );
        }

        final chatDocs = snapshot.data!.docs;
        final currentUser = FirebaseAuth.instance.currentUser;

        return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              return ChatBubble(
                  text: chatDocs[index]['text'],
                  userImage: chatDocs[index]['userImage'],
                  userName: chatDocs[index]['userName'],
                  isMe: chatDocs[index]['userId'] == currentUser!.uid);
            });
      },
    );
  }
}
