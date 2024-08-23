import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zini_chat/widget/messages.dart';
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
                  return const Text('Data not found');
                }

                final latestMessage = snapshot.data!.docs.first.data();

                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chatRoom')
                      .doc(chatRoom.id)
                      .collection('partnerInfo')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Text('Data not found');
                    }

                    final partnerInfo = snapshot.data!.docs.first.data();

                    print('Time Check ${latestMessage['time'].toString()}');

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title: Text(partnerInfo['userName']),
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
                                    Expanded(child: Messages(chatRoom.id)),
                                    SendMessage(
                                      chatRoomId: chatRoom.id,
                                      user1: currentUserId,
                                      user2: partnerInfo['userId'],
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      },
                      child: Card(
                        child: ListTile(
                          leading: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(partnerInfo['userImage']),
                              ),
                              Text(partnerInfo['userName']),
                            ],
                          ),
                          title: Text(
                            latestMessage['text'],
                          ),
                          trailing: Text(
                            latestMessage['time'].toDate().toString(),
                          ),
                        ),
                      ),
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
