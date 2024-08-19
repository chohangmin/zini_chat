import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zini_chat/widget/search_chat_room.dart';

class FriendListScreen extends StatelessWidget {
  const FriendListScreen({super.key});

  Future<void> _fetchUserName() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();
  }

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

          return ListView.builder(
              itemCount: userDocs.length,
              itemBuilder: (context, index) {
                print('User Image URL: ${userDocs[index]['userImage']}');
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
                                  onTap: () {
                                    SearchChatRoom(
                                        user1: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        user2: userDocs[index]['userId']);
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
