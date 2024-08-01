import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;

  String userName = '';
  String? userUid;
  String? userImage;

  final TextEditingController _userNameController = TextEditingController();

  List<String> _userNames = [];

  Future<void> _fetchUserNames() async {
    final QuerySnapshot userNamesSnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    final List<String> userNames =
        userNamesSnapshot.docs.map((doc) => doc['userName'] as String).toList();

    setState(() {
      _userNames = userNames;
    });
  }

  Future<void> _fetchUserImage() async {
    final DocumentSnapshot userImageSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userUid).get();
    final String? image = userImageSnapshot['userImage'] as String?;

    setState(() {
      userImage = image;
    });
  }

  @override
  void initState() {
    super.initState();
    userUid = _authentication.currentUser!.uid;
    _fetchUserNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Focus.of(context).unfocus();
        },
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      key: const ValueKey(1),
                      controller: _userNameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter user name';
                        }
                        if (_userNames.contains(value)) {
                          return 'Entered user name is existing... Change user name';
                        }

                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final userName = _userNameController.text;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Change user name successful!'),
                        ),
                      );
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(userUid)
                          .update({'userName': userName});
                      _fetchUserNames();
                      _userNameController.clear();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      userImage == null ? Colors.pink : Colors.black,
                  child: userImage == null
                      ? const Icon(Icons.person)
                      : const Icon(Icons.person_2_outlined),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
