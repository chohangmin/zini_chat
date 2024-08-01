import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                return Opacity(
                  opacity: userDocs[index]['isConnecting'] ? 1 : 0.7,
                  child: Card(
                    child: ListTile(
                      leading: userDocs[index]['userImage'] == null
                          ? const CircleAvatar(
                              child: Icon(Icons.person),
                            )
                          : const CircleAvatar(),
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
                );
              });
        });
  }
}
