import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zini_chat/widget/search_group_chat_room.dart';

class AddGroup extends StatelessWidget {
  const AddGroup({required this.selectedUsers, required this.currentUserId,super.key});

  final Set<String> selectedUsers;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
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
                        width: 400,
                        height: 400,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .orderBy('isConnecting', descending: true)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
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
                                  String userId = userDocs[index]['userId'];
                                  bool isChecked =
                                      selectedUsers.contains(userId);
                                  return Card(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          userDocs[index]['userImage'],
                                        ),
                                      ),
                                      title: Text(userDocs[index]['userName']),
                                      trailing: Checkbox(
                                        value: isChecked,
                                        onChanged: (bool? value) {
                                          if (value == true) {
                                            setState(() {
                                              selectedUsers.add(userId);
                                            });
                                          } else {
                                            setState(() {
                                              selectedUsers.remove(userId);
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
                          print('test $selectedUsers');
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
                                                icon: const Icon(
                                                    Icons.exit_to_app))
                                          ],
                                        ),
                                        body: SearchGroupChatRoom(
                                          invitedUsers: selectedUsers,
                                          currentUserId: currentUserId,

                                        ),
                                      )));
                        },
                        child: const Text('Submit'),
                      ),
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
    );
  }
}
