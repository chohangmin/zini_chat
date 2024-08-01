import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

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

  String userUrl = '';

  final TextEditingController _userNameController = TextEditingController();

  List<String> _userNames = [];

  final ImagePicker _picker = ImagePicker();
  // File? _pickedImage;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImageFile = await _picker.pickImage(
      source: source,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImageFile != null) {
      // setState(() {
      //   _pickedImage = File(pickedImageFile.path);
      setState(() {
        userImage = pickedImageFile.path;
      });

      // });

      final pickedImage = File(pickedImageFile.path);

      final refImage = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child('$userUid.jpg');

      await refImage.putFile(pickedImage);

      final url = await refImage.getDownloadURL();

      setState(() {
        userUrl = url;
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .update({'userImage': url});
    }
  }

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
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                GestureDetector(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        userImage == null ? null : NetworkImage(userUrl),
                  ),
                  onTap: () {
                    print('[test circle avartar] $userUrl');
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
                                      .doc(userUid)
                                      .update({'userImage': null});

                                  FirebaseStorage.instance
                                      .ref()
                                      .child('user_image')
                                      .child('$userUid.jpg')
                                      .delete();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );

                    // _fetchUserImage();
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
