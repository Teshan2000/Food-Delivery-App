import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/button.dart';
import 'package:food_delivery_app/components/passwordForm.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/providers/alert_service.dart';
import 'package:food_delivery_app/providers/auth_service.dart';
import 'package:food_delivery_app/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final AuthService _auth = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AlertService alertService = AlertService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool obsecurePass = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void loginUser() async {
    String email = _emailController.text;
    String password = _passController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if (user != null) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setBool('isLoggedIn', true);
      await preferences.setString('userId', user.uid);
      await preferences.setString('email', user.email ?? '');
      await preferences.setString('name', user.displayName ?? '');
      createUserInFirestore();
      alertService.showToast(context: context, text: 'Logged successfully!', icon: Icons.info);
      print("User successfully logged");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Home()));
    } else {
      alertService.showToast(context: context, text: 'Login Failed!', icon: Icons.warning);
    }
  }

  void createUserInFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {        
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'name': user.displayName ?? '',
          'favorites': [],
        });
        print("User added to Firestore with uid: ${user.uid}");
      } else {
        print("User already exists in Firestore.");
      }      
    } else {
      print("No user is currently signed in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.width(context);
    double height = ScreenSize.height(context);
    
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.amber,
            decoration: InputDecoration(
              hintText: 'Email Address',
              labelText: 'Email Address',
              alignLabelWithHint: true,
              hintStyle: TextStyle(fontSize: width * 0.04,),
              labelStyle: TextStyle(fontSize: width * 0.04,),
              fillColor: Colors.white,
              filled: true,
              prefixIcon: const Icon(Icons.email_outlined),
              prefixIconColor: Colors.amber,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.amber,
                  width: width * 0.05,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: width * 0.05,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (val) {
              return RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(val!)
                  ? null
                  : "Please enter a valid email";
            },
            onChanged: (val) {
              setState(() {
                _emailController.text = val;
              });
            },
          ),
          SizedBox(height: height * 0.02,),
          TextFormField(
            controller: _passController,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Colors.amber,
            obscureText: obsecurePass,
            decoration: InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
                alignLabelWithHint: true,
                hintStyle: TextStyle(fontSize: width * 0.04,),
                labelStyle: TextStyle(fontSize: width * 0.04,),
                fillColor: Colors.white,
                filled: true,
                prefixIcon: const Icon(Icons.lock_outline),
                prefixIconColor: Colors.amber,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.amber,
                    width: width * 0.05,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: width * 0.05,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obsecurePass = !obsecurePass;
                      });
                    },
                    icon: obsecurePass
                        ? const Icon(
                            Icons.visibility_off_outlined,
                            color: Colors.black38,
                          )
                        : const Icon(
                            Icons.visibility_outlined,
                            color: Colors.amber,
                          ))),
            validator: (val) {
              if (val!.length < 6) {
                return "Password must be at least 6 characters";
              } else {
                return null;
              }
            },
            onChanged: (val) {
              setState(() {
                _passController.text = val;
              });
            },
          ),
          SizedBox(height: height * 0.02,),
          Center(
            child: TextButton(
              child: Text(
                'Forgot Your Password?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.04,
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.06, vertical: width * 0.06,),
                      child: Dialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: EdgeInsets.all(width * 0.05,),
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: <Widget>[
                              SingleChildScrollView(
                                child: Container(
                                  width: double.infinity,
                                  height: height * 0.45,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white),
                                  padding: EdgeInsets.fromLTRB(25, 50, 25, 25),
                                  child: PasswordForm(),
                                ),
                              ),
                            ],
                          ))),
                );
              },
            ),
          ),
          SizedBox(height: height * 0.03,),
          Button(
            title: 'Sign In',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                loginUser();
              }
            },
            disable: false,
            width: width * 0.9, height: height * 0.05,
          ),
        ],
      ),
    );
  }
}
