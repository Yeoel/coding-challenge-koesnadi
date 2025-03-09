import 'package:coding_challenge_koesnadi/dashboard.dart';
import 'package:coding_challenge_koesnadi/signin.dart';
import 'package:coding_challenge_koesnadi/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:forui/forui.dart';
import 'package:toastification/toastification.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();
  runApp(const MyApp());
}

Future<void> _initializeFirebase() async {
  try {
    // Check if a Firebase app named '[DEFAULT]' already exists
    FirebaseApp app = Firebase.app();
    // If it doesn't exist, initialize it
    if (app == null) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } on FirebaseException catch (e) {
    if (e.code == 'no-app') {
      // If no Firebase app exists, initialize a new one
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      // Re-throw other exceptions
      rethrow;
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      config: ToastificationConfig(maxToastLimit: 1),
      child: MaterialApp(
        title: 'Flutter App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: FirebaseAuth.instance.currentUser != null
            ? const Dashboard()
            : const SignIn(),
      ),
    );
  }
}
