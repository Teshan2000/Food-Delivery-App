import 'package:cart_stepper/cart_stepper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/button.dart';
import 'package:food_delivery_app/components/shippingForm.dart';
import 'package:food_delivery_app/screens/categories.dart';
import 'package:food_delivery_app/screens/home.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int? total, subTotal;
  int delivery = 50;
  String userId = "";
  late User? user;

  Future<void> getUserId() async {
    final User? user = auth.currentUser;
    if (user != null) {
      userId = user.uid;
    }
  }

  @override
  void initState() {
    super.initState();
    getUserId();
  }

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
          IconButton(onPressed: () {}, icon: const Icon(Icons.payment))
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
                        // AnimationController _controller = AnimationController(
                        //   vsync: this,
                        //   duration: Duration(milliseconds: 300),
                        // );
                        showModalBottomSheet(
                          backgroundColor: Colors.amber,
                          context: context,
                          builder: (_) => Column(
                            children: [
                              const SizedBox(height: 20),
                              Container(
                                decoration: ShapeDecoration(
                                    color: Colors.amber,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ))),
                                child: Text(
                                  'Add Shipping Details',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              ShippingForm(),
                            ],
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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Expanded(
                child: Container(
                  decoration: ShapeDecoration(
                    color: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 15),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${data['address']}, ${data['city']}",
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                           "${data['state']}, ${data['country']}, ${data['zipCode']}",
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),                                          
                                        ],
                                      ),
                                    );
                                  });
                            })
                      ]),
                ),
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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Expanded(
                child: Container(
                  decoration: ShapeDecoration(
                    color: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 15),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['cardNumber'],
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            data['cardHolderName'],
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    );
                                  });
                            })
                      ]),
                ),
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
