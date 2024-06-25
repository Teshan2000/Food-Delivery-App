import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},      
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: const RoundedRectangleBorder(
            side: BorderSide(width: 5, color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(10))
          )        
        ),
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'Assets/google.jpg',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 15),
            const Text(
              'Google',
              style: TextStyle(
                color: Colors.black
              ),
            )
          ],
        ),
      ),
    );
  }
}
