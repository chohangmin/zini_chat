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
              onPressed: () {},
              label: const Text('Add Group'),
              icon: const Icon(Icons.person_add),
            ),
          ),
        ],
      ),
    );
  }
}
