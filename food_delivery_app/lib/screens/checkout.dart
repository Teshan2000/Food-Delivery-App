import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/button.dart';
import 'package:food_delivery_app/components/paymentForm.dart';
import 'package:food_delivery_app/components/shippingForm.dart';
import 'package:food_delivery_app/providers/alert_service.dart';
import 'package:food_delivery_app/screens/cart.dart';
import 'package:food_delivery_app/screens/categories.dart';
import 'package:food_delivery_app/screens/home.dart';
import 'package:lottie/lottie.dart';

class Checkout extends StatefulWidget {
  final String total;
  const Checkout({super.key, required this.total});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AlertService alertService = AlertService();
  List<Map<String, dynamic>> cart = [];
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

  Future<void> createOrder() async {
    final User? user = auth.currentUser;
    final userId = user?.uid;
    if (userId != null) {
      try {
        CollectionReference cartRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .collection('cart');

        QuerySnapshot cartSnapshot = await cartRef.get();
        if (cartSnapshot.docs.isEmpty) {
          alertService.showToast(context: context, text: 'Cart is empty!', icon: Icons.warning);
          return;
        }

        DocumentReference orderRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('orders')
            .doc();

        List<Map<String, dynamic>> orders = cartSnapshot.docs.map((doc) {
          return {
            'food_id': doc['food_id'],
            'name': doc['name'],
            'image': doc['image'],
            'price': doc['price'],
            'quantity': doc['quantity'],
          };
        }).toList();

        await orderRef.set({
          'order_id': orderRef.id,
          'order_date': Timestamp.now(),
          'total_price': widget.total,
          'status': 'Pending',
          'items': orders,
        });

        for (var doc in cartSnapshot.docs) {
          await doc.reference.delete();
        }
        alertService.showToast(context: context, text: 'Order completed successfully!', icon: Icons.info);
      } catch (e) {
        alertService.showToast(context: context, text: 'Order Failed!', icon: Icons.warning);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    if (user == null) {
      alertService.showToast(context: context, text: 'You are not Logged in!', icon: Icons.warning);
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                  'Add Payment Details',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              PaymentForm(),
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
                                            data['cardHolder'],
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            data['cardNumber'],
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
                            builder: (context) => const Cart(),
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
                      'Total Price',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 40, width: 180),
                    Text(
                      'Rs. ${widget.total}.00',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ]),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Button(
                title: 'Place Order',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text("Checkout Confirmation"),
                      content: Text("Are you sure you want to proceed?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            createOrder();
                            WidgetsBinding.instance
                              .addPostFrameCallback((_) {
                                setState(() {
                                  cart.clear();
                                });
                              });
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (_) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                  child: Dialog(
                                      backgroundColor: Colors.transparent,
                                      insetPadding: EdgeInsets.all(10),
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          SingleChildScrollView(
                                            child: Container(
                                              width: double.infinity,
                                              height: 450,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                color: Colors.white),
                                              padding: EdgeInsets.fromLTRB(25, 30, 25, 25),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Lottie.asset(
                                                    'Assets/5lKST8Beoq.json',
                                                    fit: BoxFit.contain,
                                                    width: 120
                                                  ),
                                                  Text(
                                                    "Order Successful!",
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 23, fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "Your order #45gt5f4 is successfully placed!",
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                  const SizedBox(height: 35),
                                                  Button(
                                                    title: 'Track the Order',
                                                    onPressed: () {},
                                                    disable: false,
                                                    width: double.infinity,
                                                  ),                                                  
                                                  Button(
                                                    title: 'Back to Home',
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context, MaterialPageRoute(
                                                          builder: (context) => const Home()));
                                                    },
                                                    disable: false,
                                                    width: double.infinity,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ))),
                                    );                            
                          },
                          child: Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('No'),
                        ),
                      ],
                    ));                  
                },
                disable: false,
                width: double.infinity,
              ),
            ),
          ]))),
    );
  }
}