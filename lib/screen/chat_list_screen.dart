import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zini_chat/widget/send_message.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chatRoom').snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final currentUserId = FirebaseAuth.instance.currentUser!.uid;

        final chatRoomDocs = snapshot.data!.docs;

        if (chatRoomDocs.isEmpty) {
          print("chat Room is empty");
          return const Center(
            child: Text('No chat rooms found.'),
          );
        }

        List<QueryDocumentSnapshot<Map<String, dynamic>>> userChatRooms =
            chatRoomDocs.where((chatRoom) {
          return chatRoom.id.contains(currentUserId);
        }).toList();

        if (userChatRooms.isEmpty) {
          print("Chat room check");
          return const Center(
            child: Text('No chat rooms found for the current user.'),
          );
        }

        return ListView.builder(
          itemCount: userChatRooms.length,
          itemBuilder: (context, index) {
            var chatRoom = userChatRooms[index];
            // FirebaseFirestore.instance.collection('chatRoom').doc(chatRoom.id).collection('messages')
            final partnerInfo = FirebaseFirestore.instance
                .collection('chatRoom')
                .doc(chatRoom.id)
                .collection('partnerInfo')
                .get();
            return Container(
              child: Row(children: [
                // Text(partnerInfo['userName']),
                // CircleAvatar(backgroundImage: NetworkImage(partnerInfo['userImage']),),
                ListTile(
                  title: Text(chatRoom.id),
                  onTap: () {},
                ),
              ]),
            );
          },
        );
      },
    );
  }
}
