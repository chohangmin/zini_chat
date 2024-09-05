import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zini_chat/widget/group_chat_screen/group_chat_room_card.dart';
import 'package:zini_chat/widget/message/messages.dart';
import 'package:zini_chat/widget/message/send_group_message.dart';

class GroupChatList extends StatelessWidget {
  const GroupChatList({super.key, required this.currentUserId});

  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('groupChatRoom').snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final groupChatRoomDocs = snapshot.data!.docs;

        if (groupChatRoomDocs.isEmpty) {
          return const Center(
            child: Text('No Group chat rooms found.'),
          );
        }

        List<QueryDocumentSnapshot<Map<String, dynamic>>> userGroupChatRooms =
            groupChatRoomDocs.where((chatRoom) {
          return chatRoom.id.contains(currentUserId);
        }).toList();

        if (userGroupChatRooms.isEmpty) {
          return const Center(
            child: Text('No group chat rooms found for the current user.'),
          );
        }

        return ListView.builder(
          itemCount: userGroupChatRooms.length,
          itemBuilder: (context, index) {
            var chatRoom = userGroupChatRooms[index];

            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('groupChatRoom')
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

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(
                            actions: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.exit_to_app),
                              ),
                            ],
                          ),
                          body: Column(
                            children: [
                              Expanded(
                                child: Messages(
                                  chatRoomId: chatRoom.id,
                                  currentUserId: currentUserId,
                                  type: "groupChatRoom",
                                ),
                              ),
                              SendGroupMessage(
                                chatRoomId: chatRoom.id,
                                currentUserId: currentUserId,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: GroupChatRoomCard(
                      latestMessage: latestMessage, chatRoomName: "TBD"),
                );
              },
            );
          },
        );
      },
    );
  }
}
