import 'package:cart_stepper/cart_stepper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/screens/checkout.dart';

class Cart extends StatefulWidget {
  final String deliveryId;
  final num delivery;
  const Cart({super.key, required this.delivery, required this.deliveryId});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userId = "";
  num? total, subTotal = 0;
  List<Map<String, dynamic>> cart = [];

  @override
  void initState() {
    super.initState();
    getUserId();
    // fetchCartData();
  }

  void didChangeCount(int newQuantity, String cartItemId) {
    final User? user = auth.currentUser;
    if (user == null) return;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(cartItemId)
        .update({'quantity': newQuantity}).then((_) {
      print("Quantity updated!");
    }).catchError((error) {
      print("Error occured! $error");
    });
  }

  // Future<void> fetchCartData() async {
  //   final User? user = auth.currentUser;
  //   try {
  //     final userId = user?.uid;
  //     if (userId != null) {
  //       // Fetch cart items
  //       QuerySnapshot snapshot = await _firestore
  //           .collection('users')
  //           .doc(userId)
  //           .collection('cart')
  //           .get();

  //       // Map data
  //       final items = snapshot.docs
  //           .map((doc) => doc.data() as Map<String, dynamic>)
  //           .toList();
  //       setState(() {
  //         cart = items;
  //         subTotal = cart.fold(0, (total, item) {
  //           return total! +
  //               (int.parse(item['price'].replaceAll("Rs.", "").trim()) *
  //                   (item['quantity'] ?? 1));
  //         });
  //         total = (subTotal! + delivery);
  //       });
  //     }
  //   } catch (e) {
  //     print("Error fetching cart data: $e");
  //   }
  // }

  Future<void> getUserId() async {
    final User? user = auth.currentUser;
    if (user != null) {
      userId = user.uid;
    }
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
      textStyle: const TextStyle(fontSize: 16, color: Colors.white),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Center(
          child: Text(
            'My Cart',
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.shopping_cart_outlined))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .collection('cart')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    var cartItems = snapshot.data!.docs;

                    if (cartItems.isEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          subTotal = 0;
                          total = widget.delivery ?? 0;  
                        });
                      });
                      return Center(child: Text("No cart items"));
                    }

                    num newSubTotal = cartItems.fold(0, (sum, cart) {
                      return sum +
                          (cart['price'] ?? 250) * (cart['quantity'] ?? 1);
                    });

                    num newTotal = newSubTotal + widget.delivery;

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        subTotal = newSubTotal;
                        total = newTotal;
                      });
                    });

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        var cart = cartItems[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Card(
                            elevation: 5,
                            color: Colors.amber,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    const SizedBox(width: 20),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          cart['image'],
                                          width: 80,
                                          height: 80,
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 25),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          cart['name'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          'Rs. ${cart['price']}.00',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                    const SizedBox(width: 25),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CartStepperInt(
                                          style: const CartStepperStyle(
                                            iconTheme: IconThemeData(
                                                color: Colors.black),
                                            foregroundColor: Colors.black,
                                            activeForegroundColor: Colors.black,
                                            backgroundColor: Colors.white,
                                            activeBackgroundColor: Colors.white,
                                          ),
                                          value: cart['quantity'] ?? 1,
                                          axis: Axis.vertical,
                                          didChangeCount: (count) {
                                            didChangeCount(count, cart.id);
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 15),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        );
                      },
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'Sub Total',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          const SizedBox(height: 40, width: 170),
                          Text(
                            'Rs. ${subTotal?.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Delivery',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          SizedBox(height: 40, width: 180),
                          Text(
                            'Rs. ${widget.delivery.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3, width: 180),
                      const Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'Total',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          const SizedBox(height: 40, width: 180),
                          Text(
                            'Rs. ${total?.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30, width: 50),
                      ElevatedButton.icon(
                        icon: Icon(Icons.check_circle_outline_sharp),
                        label: Text('Proceed To Checkout'),
                        style: style,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Checkout(
                                      total: total.toString(), delivery: widget.delivery, deliveryId: widget.deliveryId,
                                    )),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
