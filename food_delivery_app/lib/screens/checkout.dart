import 'package:cart_stepper/cart_stepper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/button.dart';
import 'package:food_delivery_app/screens/categories.dart';
import 'package:food_delivery_app/screens/home.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  int? total, subTotal;
  int delivery = 50;

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    if (user == null) {
      return Center(child: Text("Please log in."));
    }
    final ButtonStyle style = ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.amber,
        textStyle: const TextStyle(fontSize: 16, color: Colors.white));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Center(
          child: Text(
            'Checkout',
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.payment))
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      "Delivery Address",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Categories(),
                          ),
                        );
                      },
                      child: const Text(
                        "Add New",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ]),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  TextFormField(
                    // controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.amber,
                    decoration: InputDecoration(
                      hintText: 'Address',
                      labelText: 'Address',
                      alignLabelWithHint: true,
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: const Icon(Icons.email_outlined),
                      prefixIconColor: Colors.amber,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.amber,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
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
                        // _emailController.text = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      "Payment Details",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Categories(),
                          ),
                        );
                      },
                      child: const Text(
                        "Add New",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ]),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  TextFormField(
                    // controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.amber,
                    decoration: InputDecoration(
                      hintText: 'Card Number',
                      labelText: 'Card Number',
                      alignLabelWithHint: true,
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: const Icon(Icons.email_outlined),
                      prefixIconColor: Colors.amber,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.amber,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
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
                        // _emailController.text = val;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 170,
                        child: TextFormField(
                          // controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.amber,
                          decoration: InputDecoration(
                            hintText: 'Exp Date',
                            labelText: 'Exp Date',
                            alignLabelWithHint: true,
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: const Icon(Icons.email_outlined),
                            prefixIconColor: Colors.amber,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.amber,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
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
                              // _emailController.text = val;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 170,
                        child: TextFormField(
                          // controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.amber,
                          decoration: InputDecoration(
                            hintText: 'Cvv',
                            labelText: 'Cvv',
                            alignLabelWithHint: true,
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: const Icon(Icons.email_outlined),
                            prefixIconColor: Colors.amber,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.amber,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
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
                              // _emailController.text = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    // controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.amber,
                    decoration: InputDecoration(
                      hintText: 'Card Holder',
                      labelText: 'Card Holder',
                      alignLabelWithHint: true,
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: const Icon(Icons.email_outlined),
                      prefixIconColor: Colors.amber,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.amber,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
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
                        // _emailController.text = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: const Divider(
                color: Colors.black,
                thickness: 1,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      "Order Summary",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Categories(),
                          ),
                        );
                      },
                      child: const Text(
                        "View Order",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ]),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 40, width: 180),
                    Text(
                      'Rs. ${total}.00',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ]),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Button(
                title: 'Make Payment',
                onPressed: () {},
                disable: false,
                width: double.infinity,
              ),
            ),
          ]))),
    );
  }
}
