import 'package:flutter/material.dart';

class GroupChatList extends StatelessWidget {
  const GroupChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FloatingActionButton.extended(
            onPressed: () {},
            label: const Text('Add Group'),
            icon: const Icon(Icons.person_search_sharp),
          ),
        ],
      ),
    );
  }
}
