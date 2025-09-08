import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/button.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/providers/alert_service.dart';

class PasswordForm extends StatefulWidget {
  const PasswordForm({super.key});

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _formKey = GlobalKey<FormState>();
  AlertService alertService = AlertService();
  final _emailController = TextEditingController();

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text);
      alertService.showToast(context: context, text: 'Email sent successfully!', icon: Icons.info);
    } catch (e) {
      print('An error occurred: $e');
      alertService.showToast(context: context, text: 'Email sending Failed!', icon: Icons.warning);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.width(context);
    double height = ScreenSize.height(context);
    
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            'Reset Your Password',
            style: TextStyle(fontSize: width * 0.04, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: height * 0.02,),
          Center(
            child: Text(
              'Please enter your registered email',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width * 0.03,
              ),
            ),
          ),
          SizedBox(height: height * 0.02,),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.amber,
            decoration: InputDecoration(
              hintText: "Email Address",
              labelText: "Email Address",
              alignLabelWithHint: true,
              hintStyle: TextStyle(fontSize: width * 0.04,),
              labelStyle: TextStyle(fontSize: width * 0.04,),
              prefixIcon: Icon(Icons.email_outlined),
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your registered email';
              }
              return null;
            },
          ),
         SizedBox(height: height * 0.03,),
          Button(            
            title: 'Reset Password',
            disable: false,
            onPressed: () {
              resetPassword();
            },
            width: width * 0.9, 
            height: height * 0.05,
          ),
        ],
      ),
    );
  }
}
