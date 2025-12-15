import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/button.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/providers/alert_service.dart';
import 'package:food_delivery_app/providers/auth_service.dart';
import 'package:food_delivery_app/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {
  final AuthService _auth = AuthService();
  AlertService alertService = AlertService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool obsecurePass = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void registerUser() async {
    String username = _nameController.text;
    String email = _emailController.text;
    String password = _passController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if (user != null) {
      alertService.showToast(context: context, text: 'Registered successfully!', icon: Icons.info);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } else {
      alertService.showToast(context: context, text: 'Registration Failed!', icon: Icons.warning);
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
            controller: _nameController,
            keyboardType: TextInputType.text,
            cursorColor: Colors.amber,
            decoration: InputDecoration(
              hintText: 'Username',
              labelText: 'Username',
              alignLabelWithHint: true,
              hintStyle: TextStyle(fontSize: width * 0.04,),
              labelStyle: TextStyle(fontSize: width * 0.04,),
              fillColor: Colors.white,
              filled: true,
              prefixIcon: const Icon(Icons.person_outlined),
              prefixIconColor: Colors.amber,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.amber,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (val) {
              setState(() {
                _nameController.text = val;
              });
            },
            validator: (val) {
              if (val!.isNotEmpty) {
                return null;
              } else {
                return "Name cannot be empty";
              }
            },
          ),
          SizedBox(height: height * 0.02,),
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
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2,
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
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 2,
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
          SizedBox(height: height * 0.03,),
          Button(
            title: 'Sign Up',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                registerUser();
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
