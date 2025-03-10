import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_challenge_koesnadi/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:toastification/toastification.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  User? currentUser = FirebaseAuth.instance.currentUser;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    nameController.text = currentUser!.displayName ?? '';
    emailController.text = currentUser!.email ?? '';
  }

  Future<void> updateProfile() async {
    try {
      if (nameController.text.isNotEmpty) {
        currentUser!.updateDisplayName(nameController.text.trim());
      }

      if (emailController.text.isNotEmpty) {
        currentUser!.updateEmail(emailController.text.trim());
      }
      toastification.show(
        title: Text('Profile success updated'),
        autoCloseDuration: const Duration(seconds: 5),
        icon: const Icon(Icons.check),
        alignment: Alignment.bottomCenter,
      );
    } on FirebaseAuthException catch (e) {
      toastification.show(
        title: Text(e.message.toString()),
        icon: const Icon(Icons.warning),
        autoCloseDuration: const Duration(seconds: 5),
        alignment: Alignment.bottomCenter,
      );
    }
  }

  Future<void> deleteAccount() async {
    await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).delete();
    await currentUser?.delete();
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignIn()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FTheme(
      data: FThemes.zinc.light,
      child: FScaffold(
        header: FHeader(
          title: Text('FlutterApp'),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 30),
                FCard(
                  title: Row(
                    spacing: 10,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: FIcon(FAssets.icons.arrowLeft),
                      ),
                      Text(
                        'Edit profile',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ],
                  ),
                  subtitle: const Text(
                    'Change the detail of your own profile.',
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 25),
                      FTextField(
                        controller: nameController,
                        enabled: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name can\'t empty';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        maxLines: 1,
                        label: const Text('Name'),
                        hint: 'John Renalo',
                      ),
                      const SizedBox(height: 20),
                      FTextField(
                        controller: emailController,
                        enabled: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email can\'t empty';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        maxLines: 1,
                        label: Text('Email'),
                        hint: 'john@doe.com',
                      ),
                      const SizedBox(height: 25),
                      FButton(
                        label: const Text('Update'),
                        onPress: () => updateProfile(),
                      ),
                      const SizedBox(height: 15),
                      FButton(
                        label: const Text('Delete account'),
                        onPress: () {
                          showAdaptiveDialog(
                              context: context,
                              builder: (context) => FDialog(
                                    direction: Axis.horizontal,
                                    title:
                                        const Text('Are you absolutely sure?'),
                                    body: const Text(
                                        'This action cannot be undone. This will permanently delete your account and remove your data from our servers.'),
                                    actions: [
                                      FButton(
                                          label: const Text('Continue'),
                                          style: FButtonStyle.destructive,
                                          onPress: () => deleteAccount()),
                                      FButton(
                                          style: FButtonStyle.outline,
                                          label: const Text('Cancel'),
                                          onPress: () =>
                                              Navigator.of(context).pop()),
                                    ],
                                  ));
                        },
                        style: FButtonStyle.destructive,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
