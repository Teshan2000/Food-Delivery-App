import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/providers/auth_service.dart';
import 'package:food_delivery_app/screens/home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SocialButton extends StatelessWidget {
  final String social;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  SocialButton({super.key, required this.social});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        if (social.toLowerCase() == "google") {
          User? user = await _authService.signInWithGoogle();
          if (user != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Google sign-in failed")),
            );
          }
        }
        if (social.toLowerCase() == "facebook") {
          User? user = await _authService.signInWithFacebook();
          if (user != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
            print('Signed in as ${user.displayName}');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Facebook sign-in failed")),
            );
            print('Sign-in failed');
          }          
        }
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: const RoundedRectangleBorder(
          side: BorderSide(width: 5, color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: SizedBox(
        width: 160,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'Assets/$social.jpg',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 15),
            Text(
              social.toUpperCase(),
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
