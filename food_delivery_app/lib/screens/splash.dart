import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
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
    double width = ScreenSize.width(context);
    double height = ScreenSize.height(context);
    bool isLandscape = ScreenSize.orientation(context);

    return Scaffold(
      backgroundColor: Colors.amberAccent,
      body: Padding(
        padding: isLandscape ? EdgeInsets.all(0) : EdgeInsets.all(38),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'Assets/icon.png',
                fit: BoxFit.cover,
                width: isLandscape ? width * 0.3 : width,
              ),
            ),
            SizedBox(
              height: isLandscape ? height * 0 : height * 0.01,
            ),
            Container(
              width: isLandscape ? 300 : 230,
              child: Center(
                child: Text(
                  "Online Food Delivery Service",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: isLandscape ? 35 : 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              height: isLandscape ? height * 0.01 : height * 0.01,
            ),
          ],
        ),
      ),
    );
  }
}
