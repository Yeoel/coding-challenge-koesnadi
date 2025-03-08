import 'package:coding_challenge_koesnadi/dashboard.dart';
import 'package:coding_challenge_koesnadi/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:toastification/toastification.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> loginUserWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
      }
    } on FirebaseAuthException catch (e) {
      toastification.show(
        title: Text(e.message.toString()),
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
                    'Sign In',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  subtitle: const Text(
                    'Log in to your account to continue using the Flutter app seamlessly.',
                  ),
                  child: Form(
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        FTextField(
                          controller: emailController,
                          label: Text('Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email can\'t empty';
                            }
                            return null;
                          },
                          hint: 'john@doe.com',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FTextField.password(
                          controller: passwordController,
                          label: Text('Password'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password can\'t empty';
                            }
                            return null;
                          },
                          hint: '******',
                        ),
                        const SizedBox(height: 25),
                        FButton(
                          label: const Text('Login'),
                          onPress: () => loginUserWithEmailAndPassword(),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 4,
                          children: [
                            Text(
                              "Don't have an account yet?",
                              style: TextStyle(fontSize: 12),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));
                              },
                              child: Text(
                                'Register!',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
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
