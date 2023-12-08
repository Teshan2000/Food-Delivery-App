import 'package:flutter/material.dart';
import 'package:food_delivery_app/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,      
      initialRoute: '/',
      routes: {
        '/':(context) => const Home(),
      },
    );
  }
}

