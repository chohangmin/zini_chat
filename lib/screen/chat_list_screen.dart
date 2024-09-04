import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zini_chat/widget/messages.dart';
import 'package:zini_chat/widget/send_message.dart';
import 'package:zini_chat/widget/zini_user_info.dart';

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
                      .collection('usersInfo')
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

                    final usersInfo = snapshot.data!.docs.first.data();

                    final user1 = ZiniUserInfo(
                        id: usersInfo['user1Id'],
                        image: usersInfo['user1Image'],
                        name: usersInfo['user1Name']);

                    final user2 = ZiniUserInfo(
                        id: usersInfo['user2Id'],
                        image: usersInfo['user2Image'],
                        name: usersInfo['user2Name']);

                    print('Time Check ${latestMessage['time'].toString()}');

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title: currentUserId == user1.id
                                      ? Text(user1.name)
                                      : Text(user2.name),
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
                                      type: "chatRoom",
                                    )),
                                    SendMessage(
                                      chatRoomId: chatRoom.id,
                                      user1: currentUserId == user1.id
                                          ? user1.id
                                          : user2.id,
                                      user2: currentUserId != user1.id
                                          ? user1.id
                                          : user2.id,
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
                                        currentUserId == user1.id
                                            ? user2.image
                                            : user1.image),
                                  ),
                                ),
                                Text(currentUserId == user1.id
                                    ? user2.name
                                    : user1.name),
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
