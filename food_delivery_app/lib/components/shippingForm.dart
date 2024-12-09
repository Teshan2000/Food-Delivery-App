import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShippingForm extends StatefulWidget {
  const ShippingForm({super.key});

  @override
  State<ShippingForm> createState() => ShippingFormState();
}

class ShippingFormState extends State<ShippingForm> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController();
  bool obsecurePass = true;
  String userId = "";
  late User? user;

  // @override
  // void dispose() {
  //   _addressController.dispose();
  //   _cityController.dispose();
  //   _stateController.dispose();
  //   _zipController.dispose();
  //   _countryController.dispose();
  //   super.dispose();
  // }

  void addShippingDetails() async {
    user = auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User not logged in!'))
    );
      return;
    }
    try {
      await _firestore
          .collection('users')
          .doc(user?.uid)
          .collection('shippingDetails')
          .add({
        'address': _addressController.text,
        'city': _cityController.text,
        'state': _stateController.text,
        'zipCode': _zipController.text,
        'country': _countryController.text
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Uploaded details successfully!')));
    } catch (e) {
      ScaffoldMessenger(
          child: SnackBar(content: Text('Error uploading details: $e')));
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
                      controller: _addressController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.amber,
                      decoration: InputDecoration(
                        hintText: 'Address',
                        labelText: 'Address',
                        alignLabelWithHint: true,
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: const Icon(Icons.home_outlined),
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
                    TextFormField(
                      controller: _cityController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.amber,
                      decoration: InputDecoration(
                        hintText: 'City',
                        labelText: 'City',
                        alignLabelWithHint: true,
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: const Icon(Icons.home_work_outlined),
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
                            controller: _stateController,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Colors.amber,
                            decoration: InputDecoration(
                              hintText: 'State',
                              labelText: 'State',
                              alignLabelWithHint: true,
                              fillColor: Colors.white,
                              filled: true,
                              prefixIcon: const Icon(Icons.location_city_outlined),
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
                            controller: _zipController,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.amber,
                            decoration: InputDecoration(
                              hintText: 'Zip Code',
                              labelText: 'Zip Code',
                              alignLabelWithHint: true,
                              fillColor: Colors.white,
                              filled: true,
                              prefixIcon: const Icon(Icons.corporate_fare_outlined),
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
                      controller: _countryController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.amber,
                      decoration: InputDecoration(
                        hintText: 'Country',
                        labelText: 'Country',
                        alignLabelWithHint: true,
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: const Icon(Icons.apartment_outlined),
                        // emoji_transportation_outlined
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
                          addShippingDetails();                          
                        }                        
                      },
                      disable: false,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 9),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
