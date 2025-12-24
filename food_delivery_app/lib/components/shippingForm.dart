import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/providers/alert_service.dart';

class ShippingForm extends StatefulWidget {
  const ShippingForm({super.key});

  @override
  State<ShippingForm> createState() => ShippingFormState();
}

class ShippingFormState extends State<ShippingForm> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  AlertService alertService = AlertService();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController();
  bool obsecurePass = true;
  String userId = "";
  late User? user;

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void addShippingDetails() async {
    user = auth.currentUser;
    if (user == null) {
      alertService.showToast(context: context, text: 'You are not Logged in!', icon: Icons.warning);
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
      alertService.showToast(context: context, text: 'Details uploaded successfully!', icon: Icons.info);
    } catch (e) {
      alertService.showToast(context: context, text: 'Uploading Failed!', icon: Icons.warning);
    }
  }

  @override
  Widget build(BuildContext context) {    
    double width = ScreenSize.width(context);
    double height = ScreenSize.height(context);
    bool isLandscape = ScreenSize.orientation(context);
    
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
                    SizedBox(height: isLandscape ? width * 0.02 : height * 0.02,),
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
                    SizedBox(height: isLandscape ? width * 0.02 : height * 0.02,),
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
                    SizedBox(height: isLandscape ? width * 0.02 : height * 0.02,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: isLandscape ? width * 0.37 : width * 0.44,
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
                          width: isLandscape ? width * 0.37 : width * 0.44,
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
                    SizedBox(height: isLandscape ? width * 0.02 : height * 0.02,),
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
                    SizedBox(height: isLandscape ? width * 0.02 : height * 0.02,),
                    Button(
                      title: 'Add Details',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          addShippingDetails();                          
                        }                        
                      },
                      disable: false,
                      width: isLandscape ? width * 0.95 : width * 0.9, 
                      height: isLandscape ? width * 0.05 : height * 0.05,
                    ),
                    SizedBox(height: isLandscape ? width * 0.02 : height * 0.02,),
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
