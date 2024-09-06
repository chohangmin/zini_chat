import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({required this.currentUserId, super.key});

  final String currentUserId;

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _formKey = GlobalKey<FormState>();

  String userName = '';
  String? userImage;

  String userUrl = '';

  final TextEditingController _userNameController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedImageFile = await _picker.pickImage(
      source: source,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImageFile != null) {
      setState(() {
        userImage = pickedImageFile.path;
      });

      final pickedImage = File(pickedImageFile.path);

      final refImage = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child('${widget.currentUserId}.jpg');

      await refImage.putFile(pickedImage);

      final url = await refImage.getDownloadURL();

      setState(() {
        userUrl = url;
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentUserId)
          .update({'userImage': url});
    }
  }

  void changeUserImage() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 150,
          height: 300,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Default image'),
                onTap: () async {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.currentUserId)
                      .update({'userImage': null});

                  FirebaseStorage.instance
                      .ref()
                      .child('user_image')
                      .child('${widget.currentUserId}.jpg')
                      .delete();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // _fetchUserNames();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final userIdDocs = snapshot.data.docs;

        final List<dynamic> userNames =
            userIdDocs.map((doc) => doc['userName']).toList();

        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.currentUserId)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData) {
              return const Text('No data found');
            }

            final userDocs = snapshot.data!.data();

            return Scaffold(
              body: GestureDetector(
                onTap: () {
                  Focus.of(context).unfocus();
                },
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: changeUserImage,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(userDocs!['userImage']),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(7),
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                key: const ValueKey(1),
                                controller: _userNameController,
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.person),
                                    hintText: userDocs['userName'],
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    focusedErrorBorder:
                                        const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    errorMaxLines: 2),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter user name';
                                  }
                                  if (userNames.contains(value)) {
                                    return 'Entered user name is existing...\nChange user name';
                                  }

                                  return null;
                                },
                              ),
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
                                  .doc(widget.currentUserId)
                                  .update({'userName': userName});

                              _userNameController.clear();
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
