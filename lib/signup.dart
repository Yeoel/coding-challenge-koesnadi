import 'package:coding_challenge_koesnadi/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:toastification/toastification.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController retypePasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> createUserWithEmailAndPassword() async {
    if (passwordController.text.trim() ==
        retypePasswordController.text.trim()) {
      try {
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim());

        if (!_formKey.currentState!.validate()) {
          // If the form is invalid, stop further execution.
          return;
        }

        toastification.show(
          title: Text('Registration successful! Your account is ready.'),
          autoCloseDuration: const Duration(seconds: 5),
          icon: const Icon(Icons.check),
          alignment: Alignment.bottomCenter,
        );
        if (mounted){
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        toastification.show(
          title: Text(e.message.toString()),
          icon: const Icon(Icons.warning),
          autoCloseDuration: const Duration(seconds: 5),
          alignment: Alignment.bottomCenter,
        );
      }
    } else {
      toastification.show(
        title: Text('Password not same'),
        icon: const Icon(Icons.warning),
        autoCloseDuration: const Duration(seconds: 5),
        alignment: Alignment.bottomCenter,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FTheme(
      data: FThemes.zinc.light,
      child: FScaffold(
        header: FHeader(title: Text('FlutterApp')),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 30),
                FCard(
                  title: const Text(
                    'Sign Up',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  subtitle: const Text(
                    'Sign up to create an account and continue using the Flutter app seamlessly.',
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 25),
                      FTextField(
                        controller: nameController,
                        enabled: true,
                        keyboardType: TextInputType.name,
                        maxLines: 1,
                        label: const Text('Name'),
                        hint: 'John Renalo',
                      ),
                      const SizedBox(height: 20),
                      FTextField(
                        controller: emailController,
                        enabled: true,
                        keyboardType: TextInputType.emailAddress,
                        maxLines: 1,
                        label: Text('Email'),
                        hint: 'john@doe.com',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FTextField.password(
                        controller: passwordController,
                        enabled: true,
                        keyboardType: TextInputType.visiblePassword,
                        maxLines: 1,
                        label: Text('Password'),
                        hint: '******',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FTextField.password(
                        controller: retypePasswordController,
                        enabled: true,
                        keyboardType: TextInputType.visiblePassword,
                        maxLines: 1,
                        label: Text('Re-type Password'),
                        hint: '******',
                      ),
                      const SizedBox(height: 25),
                      FButton(
                        label: const Text('Register'),
                        onPress: () {
                          createUserWithEmailAndPassword();
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 4,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(fontSize: 12),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              ' Log in now!',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
