import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String social;

  const SocialButton({super.key, required this.social});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
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
