import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zini_chat/widget/messages.dart';
import 'package:zini_chat/widget/send_message.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({required this.currentUserId, super.key});

  final String currentUserId;

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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title: opponentUserInfo['userName'],
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
                                      chatRoomId: chatRoom.id,
                                      currentUserId: currentUserId,
                                      type: "chatRoom",
                                    )),
                                    SendMessage(
                                      chatRoomId: chatRoom.id,
                                      currentUserId: currentUserId,

                                    ),
                                  ],
                                ),
                              ),
                            ));
                      },
                      child: Card(
                        child: ListTile(
                          leading: Container(
                            margin: const EdgeInsets.all(1),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        opponentUserInfo!['userImage']),
                                  ),
                                ),
                                Text(opponentUserInfo['userName']),
                              ],
                            ),
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
