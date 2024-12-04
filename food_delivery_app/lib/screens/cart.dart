import 'package:cart_stepper/cart_stepper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/screens/checkout.dart';
import 'package:food_delivery_app/screens/foodDetails.dart';
import 'package:food_delivery_app/screens/home.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userId = "";
  int? total, subTotal;
  int delivery = 50;

  // List<Map<String, dynamic>> cart = [
  //   {
  //     "image": "Assets/Foods/Chicken Burger.png",
  //     "name": "Chicken Burger",
  //     "price": "Rs.95.00"
  //   },
  //   {
  //     "image": "Assets/Foods/Sandwich.png",
  //     "name": "Fish Sandwiches",
  //     "price": "Rs.35.00"
  //   },
  //   {
  //     "image": "Assets/Foods/Taco.png",
  //     "name": "Veggi Taco",
  //     "price": "Rs.35.00"
  //   }
  // ];

  void didChangeCount(int newQuantity, int index) {
    setState(() {
      // cart[index]["quantity"] = newQuantity;
      // subTotal = calculatesubTotal();
      // total = calculateTotal();
    });
  }

  // double calculatesubTotal() {
  //   double subTotal = cartItems.fold(0, (total, item) {
  //     return total +
  //         (double.parse(item['price'].replaceAll("Rs.", "").trim()) *
  //             (item['quantity'] ?? 1));
  //   });

  //   // for (var item in cart) {
  //   //   subTotal += double.parse(item["price"].replaceAll("Rs.", "").trim()) *
  //   //       (item["quantity"] ?? 0);
  //   // }
  //   return subTotal;
  // }

  // double calculateTotal() {
  //   double total = 0;
  //   total = subTotal + delivery;
  //   return total;
  // }

  Future<void> getUserId() async {
    final User? user = auth.currentUser;
    if (user != null) {
      userId = user.uid;
    }
  }

  // Future<void> createOrder() async {
  //   try {
  //     DocumentReference orderRef = FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userId)
  //         .collection('orders')
  //         .doc(widget.name);

  //     await orderRef.set({
  //       'food_id': widget.id,
  //       'name': widget.name,
  //       'image': widget.image,
  //       'price': widget.price,
  //       'quantity': quantity,
  //       'date': Timestamp.now(),
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to place order: $e')),
  //     );
  //   }
  // }

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
              Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    height: 375,
                    child: StreamBuilder<QuerySnapshot>(
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
                          return Center(child: Text("No cart items."));
                        }
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            var cart = cartItems[index];
                            double subTotal = cartItems.fold(0, (total, item) {
                              return total +
                                  ((item['price'] is String)
                                      ? double.parse(item['price']
                                          .replaceAll("Rs.", "")
                                          .trim())
                                      : item['price'].toDouble() *
                                          (item['quantity'] ?? 1));
                            });
                            // total = subTotal + delivery;
                            return Card(
                              elevation: 5,
                              color: Colors.amber,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 15),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                                                  alignment:
                                                      Alignment.centerLeft,
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
                                                ]),
                                            const SizedBox(width: 25),
                                            // SizedBox(width: 15,),
                                            // IconButton(
                                            //   icon: const Icon(Icons.cancel),
                                            //   color: Colors.red,
                                            //   onPressed: () {
                                            //     // _removeFood(index);
                                            //   },
                                            // ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                CartStepperInt(
                                                  style: const CartStepperStyle(
                                                      iconTheme: IconThemeData(
                                                          color: Colors.black),
                                                      foregroundColor:
                                                          Colors.black,
                                                      activeForegroundColor:
                                                          Colors.black,
                                                      backgroundColor:
                                                          Colors.white,
                                                      activeBackgroundColor:
                                                          Colors.white),
                                                  value: cart['quantity'] ?? 1,
                                                  axis: Axis.vertical,
                                                  didChangeCount: (count) {
                                                    didChangeCount(
                                                        count, index);
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 15),
                                          ]),
                                    ),
                                  ]),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
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
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            const SizedBox(height: 40, width: 170),
                            Text(
                              'Rs. ${subTotal}.00',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ]),
                      const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Delivery',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            SizedBox(height: 40, width: 180),
                            Text(
                              'Rs. 50.00',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ]),
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
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            const SizedBox(height: 40, width: 180),
                            Text(
                              'Rs. ${total}.00',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ]),
                      const SizedBox(height: 30, width: 50),
                      ElevatedButton.icon(
                        icon: Icon(Icons.check_circle_outline_sharp),
                        label: Text('Proceed To Checkout'),
                        style: style,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text("Checkout Confirmation"),
                                    content: Text(
                                        "Are you sure you want to proceed?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Checkout()),
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
                      ),
                    ]),
              )
            ]))),
      ),
    );
  }
}
