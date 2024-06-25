import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/socialButton.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Center(
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Text(
                    'Please login into your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    'Forgot Your Password?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 16,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Center(
                  child: Text(
                    'or sign in with',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 25),
                const SocialButton(),
                const SizedBox(height: 30),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "  Sign Up",
                              style: const TextStyle(
                                color: Colors.purple,
                                fontSize: 17,
                                decorationStyle: TextDecorationStyle.solid,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                },
                            ),
                          ],
                        ),
                      ),
                    ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
