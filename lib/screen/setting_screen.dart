import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _formKey = GlobalKey<FormState>();

  List<String> _userNames = [];

  Future<void> _fetchUserNames() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();
    final List<String> userNames =
        snapshot.docs.map((doc) => doc['userName'] as String).toList();

    setState(() {
      _userNames = userNames;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserNames();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: TextFormField(
                  key: const ValueKey(1),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Change user name successful!'),
                    ),
                  );
                  _fetchUserNames();
                }
              },
              child: const Text('Submit'),
            ),
          ],
        )
      ],
    );
  }
}
