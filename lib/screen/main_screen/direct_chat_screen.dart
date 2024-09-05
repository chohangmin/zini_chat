import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zini_chat/widget/direct_chat_screen/chat_room_card.dart';
import 'package:zini_chat/widget/message/messages.dart';
import 'package:zini_chat/widget/message/send_message.dart';

class DirectChatScreen extends StatelessWidget {
  const DirectChatScreen({required this.currentUserId, super.key});

  final String currentUserId;

  void directChat(context, String chatRoomId,
      DocumentSnapshot<Map<String, dynamic>>? opponentUserInfo) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text(opponentUserInfo!['userName']),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.exit_to_app),
                )
              ],
            ),
            body: Column(
              children: [
                Expanded(
                    child: Messages(
                  chatRoomId: chatRoomId,
                  currentUserId: currentUserId,
                  type: "chatRoom",
                )),
                SendMessage(
                  chatRoomId: chatRoomId,
                  currentUserId: currentUserId,
                ),
              ],
            ),
          ),
        ));
  }

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

            String opponentUserId = chatRoom.id.replaceAll(currentUserId, '');

            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chatRoom')
                  .doc(chatRoom.id)
                  .collection('messages')
                  .orderBy('time', descending: true)
                  .limit(1)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData) {
                  return const Text('No message data found in chat room');
                }

                final latestMessage = snapshot.data!.docs.first.data();

                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(opponentUserId)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Text('No opponent user found.');
                    }

                    final opponentUserInfo = snapshot.data;

                    return GestureDetector(
                      onTap: () {
                        directChat(context, chatRoom.id, opponentUserInfo);
                      },
                      child: ChatRoomCard(
                          latestMessage: latestMessage,
                          opponentUserInfo: opponentUserInfo),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
