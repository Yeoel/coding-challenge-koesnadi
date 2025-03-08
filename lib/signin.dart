import 'package:coding_challenge_koesnadi/signup.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return FTheme(
      data: FThemes.zinc.light,
      child: FScaffold(
        header: FHeader(title: Text('FlutterApp')),
        content: SingleChildScrollView(
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
                      const FTextField(
                        label: Text('Email'),
                        hint: 'john@doe.com',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FTextField.password(
                        label: Text('Password'),
                        hint: '******',
                      ),
                      const SizedBox(height: 25),
                      FButton(
                        label: const Text('Login'),
                        onPress: () {},
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
    );
  }
}
