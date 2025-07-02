import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/button.dart';
import 'package:food_delivery_app/components/paymentDetails.dart';
import 'package:food_delivery_app/components/paymentForm.dart';
import 'package:food_delivery_app/components/shippingDetails.dart';
import 'package:food_delivery_app/components/shippingForm.dart';
import 'package:food_delivery_app/components/successCard.dart';
import 'package:food_delivery_app/providers/alert_service.dart';
import 'package:food_delivery_app/screens/cart.dart';

class Checkout extends StatefulWidget {
  final String total;
  final String deliveryId;
  final num delivery;
  const Checkout(
      {super.key,
      required this.total,
      required this.deliveryId,
      required this.delivery});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AlertService alertService = AlertService();
  List<Map<String, dynamic>> cart = [];
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

  Future<String?> createOrder() async {
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
          alertService.showToast(
              context: context, text: 'Cart is empty!', icon: Icons.warning);
          return null;
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

        String orderId = orderRef.id;

        await orderRef.set({
          'order_id': orderId,
          'order_date': Timestamp.now(),
          'total_price': widget.total,
          'status': 'Pending',
          'delivery': widget.delivery,
          'delivery_id': widget.deliveryId,
          'items': orders,
        });

        for (var doc in cartSnapshot.docs) {
          await doc.reference.delete();
        }
        alertService.showToast(
            context: context,
            text: 'Order completed successfully!',
            icon: Icons.info);

        return orderId;
      } catch (e) {
        alertService.showToast(
            context: context, text: 'Order Failed!', icon: Icons.warning);
      }
    }
    return null;
  }

  String maskCardNumber(String cardNumber) {
    if (cardNumber.length < 8) return cardNumber;
    return '${cardNumber.substring(0, 4)} **** **** ${cardNumber.substring(cardNumber.length - 4)}';
  }


  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    final ButtonStyle style = TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.amber,
        textStyle: const TextStyle(fontSize: 16, color: Colors.white));

    if (user == null) {
      alertService.showToast(
          context: context,
          text: 'You are not Logged in!',
          icon: Icons.warning);
    }
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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 10),
          child: SizedBox(),
        ),
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
                                    fontSize: 20, fontWeight: FontWeight.bold
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
                          color: Colors.amber, fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ]),
            ),
            // const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                  width: double.infinity,
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
                                    return ShippingDetails(
                                      address1:
                                          "${data['address']}, ${data['city']}",
                                      address2:
                                          "${data['state']}, ${data['country']}, ${data['zipCode']}",
                                    );
                                  });
                            })
                      ]),
                
              ),
            ),
            const SizedBox(height: 20),
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
                                    fontSize: 20, fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                  height: 385,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: PaymentForm()),
                            ],
                          ),
                        );
                      },
                      child: const Text(
                        "Add New",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.amber, fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ]),
            ),
            // const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                  width: double.infinity,
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
                                    return PaymentDetails(
                                      cardHolder: data['cardHolder'],
                                      cardNumber: maskCardNumber(data['cardNumber']),
                                    );
                                  });
                            })
                      ]),                
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: const Divider(
                color: Colors.black,
                thickness: 1,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      " Order Summary",
                      style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Cart(
                              delivery: widget.delivery,
                              deliveryId: widget.deliveryId,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "View Order",
                        style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ]),
            ),
            // const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                color: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // const SizedBox(width: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'Assets/pick me foods.jpg',
                            width: 80,
                            height: 80,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Pick me Foods',
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Rs. ${widget.delivery}.00",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                              )
                            ]),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(children: [
                              Icon(
                                Icons.star,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '4.8',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                              )
                            ])
                          ],
                        )
                      ]),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      ' Total Price',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Text(
                      'Rs. ${widget.total}.00 ',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ]),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Button(
                title: 'Place Order',
                onPressed: () async {
                  final confirmed = await showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text("Checkout Confirmation"),
                      content: Text("Are you sure you want to proceed?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Yes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('No', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    String? orderId = await createOrder();

                    if (orderId != null) {
                      cart.clear();

                      // ✅ Use Navigator.push instead of showDialog
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => SuccessCard(
                      //       deliveryId: widget.deliveryId,
                      //       orderId: "orderId",
                      //     ),
                      //   ),
                      // );
                      showDialog(
                                    context: context,
                                    builder: (_) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Dialog(
                                            backgroundColor: Colors.transparent,
                                            insetPadding: EdgeInsets.all(10),
                                            child: SuccessCard(deliveryId: widget.deliveryId, orderId: orderId,))),
                                  );
                    }
                  }
                },
                disable: false,
                width: double.infinity,
              ),
            ),
          ]))),
    );
  }
}
