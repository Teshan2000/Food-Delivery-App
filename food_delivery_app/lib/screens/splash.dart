import 'package:flutter/material.dart';
import 'package:food_delivery_app/screens/home.dart';
import 'package:food_delivery_app/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializePreferencesAndNavigate();
  }

  Future<void> _initializePreferencesAndNavigate() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isLoggedIn = preferences.getBool('isLoggedIn') ?? false;

    await Future.delayed(Duration(seconds: 3));

    if(mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => isLoggedIn ? Home() : LoginPage())
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(padding: EdgeInsets.all(38),
      child: Column(
        children: [
          const SizedBox(height: 170),
          Center(
            child: Image.asset(
              'Assets/icon.png',
              fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
            ),
          )
        ],
      ),),
    );
  }
}