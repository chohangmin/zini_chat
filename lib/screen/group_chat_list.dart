import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class GroupChatList extends StatelessWidget {
  const GroupChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Positioned(
            bottom: 100,
            left: 10,
            child: FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            width: 200,
                            height: 400,
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('usrs')
                                  .orderBy('isConnecting', descending: true)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                final userDocs = snapshot.data!.docs;

                                
                              },
                            ),
                          ),
                        ));
              },
              label: const Text('Add Group'),
              icon: const Icon(Icons.person_add),
            ),
          ),
        ],
      ),
    );
  }
}
