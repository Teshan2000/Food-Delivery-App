import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/button.dart';
import 'package:food_delivery_app/providers/alert_service.dart';

class PaymentForm extends StatefulWidget {
  const PaymentForm({super.key});

  @override
  State<PaymentForm> createState() => PaymentFormState();
}

class PaymentFormState extends State<PaymentForm> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  AlertService alertService = AlertService();
  final _cardNumberController = TextEditingController();
  final _expDateController = TextEditingController();
  final _cvvNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  bool obsecurePass = true;
  String userId = "";
  late User? user;

  void addPaymentDetails() async {
    user = auth.currentUser;
    if (user == null) {
      alertService.showToast(context: context, text: 'You are not Logged in!', icon: Icons.warning);
      return;
    }
    try {
      await _firestore
          .collection('users')
          .doc(user?.uid)
          .collection('paymentDetails')
          .add({
        'cardNumber': _cardNumberController.text,
        'expDate': _expDateController.text,
        'cvvNumber': _cvvNumberController.text,
        'cardHolder': _cardHolderController.text
      });
      Navigator.pop(context);      
      alertService.showToast(context: context, text: 'Details uploaded successfully!', icon: Icons.info);
    } catch (e) {
      alertService.showToast(context: context, text: 'Uploading Failed!', icon: Icons.warning);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BottomSheet(
            onClosing: () {
              TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close),
                  label: Text('Close'));
            },
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            )),
            builder: (BuildContext context) {
              return Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _cardNumberController,
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.amber,
                        decoration: InputDecoration(
                          hintText: 'Card Number',
                          labelText: 'Card Number',
                          alignLabelWithHint: true,
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: const Icon(Icons.payment_outlined),
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
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 170,
                            child: TextFormField(
                              controller: _expDateController,
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.amber,
                              decoration: InputDecoration(
                                hintText: 'Exp Date',
                                labelText: 'Exp Date',
                                alignLabelWithHint: true,
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon: const Icon(Icons.calendar_month_outlined),
                                prefixIconColor: Colors.amber,
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black),
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
                            ),
                          ),
                          Container(
                            width: 170,
                            child: TextFormField(
                              controller: _cvvNumberController,
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.amber,
                              decoration: InputDecoration(
                                hintText: 'Cvv',
                                labelText: 'Cvv',
                                alignLabelWithHint: true,
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon: const Icon(Icons.dialpad),
                                prefixIconColor: Colors.amber,
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black),
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
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _cardHolderController,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.amber,
                        decoration: InputDecoration(
                          hintText: 'Card Holder',
                          labelText: 'Card Holder',
                          alignLabelWithHint: true,
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: const Icon(Icons.person_outline_outlined),
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
                      ),
                      const SizedBox(height: 20),
                      Button(
                        title: 'Add Details',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            addPaymentDetails();
                          }
                        },
                        disable: false,
                        width: double.infinity,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }
}
