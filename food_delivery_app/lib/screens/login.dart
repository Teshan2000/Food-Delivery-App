import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/loginForm.dart';
import 'package:food_delivery_app/components/socialButton.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/screens/register.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.width(context);
    double height = ScreenSize.height(context);

    return Scaffold(
      backgroundColor: Colors.amberAccent,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05, 
            vertical: height * 0.03
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: height * 0.03,),
                Center(
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: width * 0.09,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02,),
                Center(
                  child: Text(
                    'Please login into your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * 0.045,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.04,),
                const LoginForm(),
                SizedBox(height: height * 0.05,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: width * 0.3,
                      child: Divider(thickness: 1.5, color: Colors.black)),
                    Text(
                      'or sign in with',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: width * 0.04,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.3,
                      child: Divider(thickness: 1.5, color: Colors.black)),
                  ],
                ),
                SizedBox(height: height * 0.03,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SocialButton(
                      social: 'Google',
                    ),
                    SocialButton(
                      social: 'Facebook',
                    ),
                  ],
                ),
                SizedBox(height: height * 0.04,),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: width * 0.045,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "  Sign Up",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.045,
                                decorationStyle: TextDecorationStyle.solid,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterPage(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
