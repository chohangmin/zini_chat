import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zini_chat/widget/search_chat_room.dart';

class FriendScreen extends StatelessWidget {
  const FriendScreen({required this.currentUserId, super.key});

  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy('isConnecting', descending: true)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final userDocs = snapshot.data!.docs;

          QueryDocumentSnapshot<Map<String, dynamic>>? currentUserDoc;

          try {
            currentUserDoc = userDocs.firstWhere(
              (doc) => doc['userId'] == currentUserId,
            );
          } catch (e) {
            currentUserDoc = null;
          }

          if (currentUserDoc != null) {
            userDocs.remove(currentUserDoc);
            userDocs.insert(0, currentUserDoc);
          }

          return ListView.builder(
              itemCount: userDocs.length,
              itemBuilder: (context, index) {
                return Opacity(
                  opacity: userDocs[index]['isConnecting'] ? 1 : 0.7,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            width: 150,
                            height: 300,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.chat_bubble),
                                  title: const Text('1 : 1 chat'),
                                  onTap: () async {
                                    print('click');
                                    final result = await Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return SearchChatRoom(
                                        user1: currentUserId,
                                        user2: userDocs[index]['userId'],
                                        currentUserId: currentUserId,
                                      );
                                    }));
                                    if (result == true) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text("Id is same")));
                                    }
                                    
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        leading: userDocs[index]['userImage'] == null
                            ? const CircleAvatar(
                                child: Icon(Icons.person),
                              )
                            : CircleAvatar(
                                backgroundImage: NetworkImage(
                                  userDocs[index]['userImage'],
                                ),
                              ),
                        title: Text(userDocs[index]['userName']),
                        trailing: Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: userDocs[index]['isConnecting']
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
