import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/providers/auth_service.dart';
import 'package:food_delivery_app/screens/home.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialButton extends StatelessWidget {
  final String social;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SocialButton({super.key, required this.social});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
       final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        await _auth.signInWithCredential(credential);
      }
    } catch (e) {
      print("Some error occured! ${e}");
    }
      },
      style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: const RoundedRectangleBorder(
              side: BorderSide(width: 5, color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(10)))),
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
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
