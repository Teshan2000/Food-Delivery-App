import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/paymentDetails.dart';
import 'package:food_delivery_app/components/shippingDetails.dart';
import 'package:food_delivery_app/components/shippingForm.dart';
import 'package:food_delivery_app/providers/alert_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  AlertService alertService = AlertService();
  final TextEditingController nameController = TextEditingController();
  String userId = "";
  String name = "";
  String image = "";
  String email = "";
  late User? user;
  bool isPaymentExpanded = false;
  bool isShippingExpanded = false;

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
    email = user?.email ?? "";
    _fetchProfile();
  }

  Future<void> getUserId() async {
    final User? user = auth.currentUser;
    email = user?.email ?? "";
    if (user != null) {
      userId = user.uid;
    }
  }

  Future<void> _fetchProfile() async {
    DocumentSnapshot profileSnap = await _firestore
        .collection('users')
        .doc(user?.uid)
        .collection('profile')
        .doc('details')
        .get();

    if (profileSnap.exists) {
      setState(() {
        nameController.text = profileSnap['name'] ?? '';
        image = profileSnap['profileImage'] ?? '';
      });
    }
  }

  Future<void> _updateProfile(String newName, String imageUrl) async {
    try {
      await _firestore
        .collection('users')
        .doc(user?.uid)
        .collection('profile')
        .doc('details')
        .set({'name': newName, 'profileImage': imageUrl, 'email': user?.email});
      setState(() {
        name = newName;
        image = imageUrl;
      });
      alertService.showToast(context: context, text: 'Profile Updated successfully!', icon: Icons.info);
    } catch (e) {
      alertService.showToast(context: context, text: 'Profile Updating Failed!', icon: Icons.warning);
    }
    
  }

  Future<void> _uploadProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      try {
        String filePath = 'profiles/${user?.uid}.jpg';
        UploadTask uploadTask =
            _storage.ref().child(filePath).putFile(imageFile);

        TaskSnapshot snapshot = await uploadTask;
        String imageUrl = await snapshot.ref.getDownloadURL();

        await _updateProfile(name, imageUrl);
      } catch (e) {
        alertService.showToast(context: context, text: 'Profile Image Updating Failed!', icon: Icons.warning);
        print("Error uploading image: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Center(
            child: Text(
              'Profile',
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.person_outline))
          ],
          bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 10), child: SizedBox(),
        ),
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SingleChildScrollView(
                child: Column(children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(children: [
                    GestureDetector(
                      onTap: _uploadProfileImage,
                      child: CircleAvatar(
                        backgroundImage: image.isEmpty
                            ? AssetImage('Assets/peter.jpg') as ImageProvider
                            : NetworkImage(image),
                        radius: 60,
                      ),
                    ),
                    Positioned(
                      right: 6,
                      bottom: 1,
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 1),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: _uploadProfileImage,
                        ),
                      ),
                    )
                  ]),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Text(name),
              Column(children: [
                Row(children: [
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        labelText: 'Name',
                        alignLabelWithHint: true,
                        prefixIcon: const Icon(
                          Icons.person,
                        ),
                        suffixIcon: const Icon(Icons.edit),
                        prefixIconColor: Colors.amber,
                        suffixIconColor: Colors.amber,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 1),
                        // enabledBorder: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.amber,
                            )),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            )),
                      ),
                      onFieldSubmitted: (value) {
                        _updateProfile(value, image);
                      },
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 30,
                ),
                Row(children: [
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      // controller: emailController,
                      initialValue: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        labelText: 'Email',
                        alignLabelWithHint: true,
                        prefixIcon: const Icon(Icons.email),
                        suffixIcon: const Icon(Icons.edit),
                        prefixIconColor: Colors.amber,
                        suffixIconColor: Colors.amber,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 1),
                        // enabledBorder: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.amber,
                            )),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            )),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 30,
                ),
                Row(children: [
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      // controller: phoneController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Phone',
                        labelText: 'Phone',
                        alignLabelWithHint: true,
                        suffixIcon: Icon(Icons.edit),
                        prefixIcon: const Icon(Icons.phone),
                        // suffixIcon: const Icon(Icons.edit),
                        prefixIconColor: Colors.amber,
                        suffixIconColor: Colors.amber,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 1),
                        // enabledBorder: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.amber,
                            )),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            )),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 30,
                ),
              ]),
              Column(
                children: [
                  ExpansionTile(
                    key: UniqueKey(),
                    leading: Icon(Icons.payment, color: Colors.amber,),
                    title: Text("Payment Details"),
                    onExpansionChanged: (expanded) {
                      setState(() {
                        isPaymentExpanded = expanded;
                        if (expanded) isShippingExpanded = false;
                      });
                    },
                    initiallyExpanded: isPaymentExpanded,
                    children: [
                      Container(
                        decoration: ShapeDecoration(
                          color: Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StreamBuilder<QuerySnapshot>(
                                stream: _firestore
                                    .collection('users')
                                    .doc(user?.uid)
                                    .collection('paymentDetails')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Text("No Payment Details added!");
                                  }
                                  var paymentData = snapshot.data!.docs;
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: paymentData.length,
                                      itemBuilder: (context, index) {
                                        var data = paymentData[index];
                                        return PaymentDetails(
                                          cardHolder: data['cardHolder'],
                                          cardNumber: data['cardNumber'],
                                        );
                                      });
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ExpansionTile(
                    key: UniqueKey(),
                    leading: Icon(Icons.location_city, color: Colors.amber,),
                    title: Text("Shipping Address"),
                    onExpansionChanged: (expanded) {
                      setState(() {
                        isShippingExpanded = expanded;
                        if (expanded) isPaymentExpanded = false;
                      });
                    },
                    initiallyExpanded: isShippingExpanded,
                    children: [
                      Container(
                        decoration: ShapeDecoration(
                          color: Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StreamBuilder<QuerySnapshot>(
                                stream: _firestore
                                    .collection('users')
                                    .doc(user?.uid)
                                    .collection('shippingDetails')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Text("No Shipping Details added!");
                                  }
                                  var addressData = snapshot.data!.docs;
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: addressData.length,
                                      itemBuilder: (context, index) {
                                        var data = addressData[index];
                                        return ShippingDetails(
                                          address1: "${data['address']}, ${data['city']}", 
                                          address2: "${data['state']}, ${data['country']}, ${data['zipCode']}",
                                        );
                                      });
                                }),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              )
            ]))));
  }
}
