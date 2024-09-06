import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({required this.showDialog, required this.user, super.key});

  final QueryDocumentSnapshot<Map<String, dynamic>> user;

  final Function showDialog;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: user['isConnecting'] ? 1 : 0.7,
      child: GestureDetector(
          onTap: () {
            showDialog(context, user['userId']);
          },
          child: Card(
            child: ListTile(
              leading: user['userImage'] == null
                  ? const CircleAvatar(
                      child: Icon(Icons.person),
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(
                        user['userImage'],
                      ),
                    ),
              title: Text(user['userName']),
              trailing: Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: user['isConnecting'] ? Colors.green : Colors.red,
                ),
              ),
            ),
          )),
    );
  }
}
