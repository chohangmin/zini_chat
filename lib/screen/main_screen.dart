import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zini_chat/screen/chat_list_screen.dart';
import 'package:zini_chat/screen/friend_screen.dart';
import 'package:zini_chat/screen/group_chat_screen.dart';
import 'package:zini_chat/screen/setting_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _authentication = FirebaseAuth.instance;
  late final String _currentUserId;

  int _selectedIndex = 0;

  late List<Widget> _widgetOptions;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _currentUserId = FirebaseAuth.instance.currentUser!.uid;
    _widgetOptions = [
      FriendScreen(currentUserId: _currentUserId),
       ChatListScreen(currentUserId: _currentUserId),
       GroupChatScreen(currentUserId: _currentUserId),
       SettingScreen(currentUserId: _currentUserId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zini Chat'),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(_currentUserId)
                    .update({'isConnecting': false});
                _authentication.signOut();
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            label: 'Group Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blue.shade300,
        onTap: _onItemTapped,
      ),
    );
  }
}
