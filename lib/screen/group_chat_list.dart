import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class GroupChatList extends StatefulWidget {
  const GroupChatList({super.key});

  @override
  State<GroupChatList> createState() => _GroupChatListState();
}

class _GroupChatListState extends State<GroupChatList> {
  final Set<String> _selectedUsers = {};
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
                  builder: (context) => StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Dialog(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              width: 200,
                              height: 400,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .orderBy('isConnecting', descending: true)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<
                                            QuerySnapshot<Map<String, dynamic>>>
                                        snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  final userDocs = snapshot.data!.docs;

                                  return ListView.builder(
                                      itemCount: userDocs.length,
                                      itemBuilder: (context, index) {
                                        String userId =
                                            userDocs[index]['userId'];
                                        bool isChecked =
                                            _selectedUsers.contains(userId);
                                        return Card(
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                userDocs[index]['userImage'],
                                              ),
                                            ),
                                            title: Text(
                                                userDocs[index]['userName']),
                                            trailing: Checkbox(
                                              value: isChecked,
                                              onChanged: (bool? value) {
                                                if (value == true) {
                                                  setState(() {
                                                    _selectedUsers.add(userId);
                                                  });
                                                } else {
                                                  setState(() {
                                                    _selectedUsers
                                                        .remove(userId);
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        );
                                      });
                                },
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  print('test $_selectedUsers');
                                },
                                child: const Text('Submit')),
                          ],
                        ),
                      );
                    },
                  ),
                );
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
