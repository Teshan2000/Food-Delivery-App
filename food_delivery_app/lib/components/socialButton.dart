import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/providers/alert_service.dart';
import 'package:food_delivery_app/providers/auth_service.dart';
import 'package:food_delivery_app/screens/home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SocialButton extends StatelessWidget {
  final String social;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();
  AlertService alertService = AlertService();

  SocialButton({super.key, required this.social});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        if (social.toLowerCase() == "google") {
          User? user = await _authService.signInWithGoogle();
          if (user != null) {
            alertService.showToast(context: context, text: 'Logged successfully!', icon: Icons.info);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          } else {
            alertService.showToast(context: context, text: 'Google Login Failed!', icon: Icons.warning);
          }
        }
        if (social.toLowerCase() == "facebook") {
          User? user = await _authService.signInWithFacebook();
          if (user != null) {
            alertService.showToast(context: context, text: 'Logged successfully!', icon: Icons.info);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
            print('Signed in as ${user.displayName}');
          } else {
            alertService.showToast(context: context, text: 'Facebook Login Failed!', icon: Icons.warning);
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
