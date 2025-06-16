import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/paymentDetails.dart';
import 'package:food_delivery_app/components/shippingDetails.dart';
import 'package:intl/intl.dart';

class OrderDetails extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderDetails({super.key, required this.order});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool isPaymentExpanded = false;
  bool isShippingExpanded = false;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final items = widget.order['items'] as List<dynamic>;
    num totalQuantity =
        items.fold(0, (sum, item) => sum + (item['quantity'] ?? 0));

    final User? user = auth.currentUser;
    if (user == null) {
      return Center(child: Text("Please log in."));
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Center(
            child: Text(
              "Order #${(widget.order['order_id']).substring(0, 5) + ''}",
            ),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_bag))
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
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                    children: <Widget>[
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "${totalQuantity} items",
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                      const SizedBox(
                                        width: 210,
                                      ),
                                      Text(
                                        "${DateFormat('yyyy-MM-dd').format(widget.order['order_date'].toDate())}",
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                    ]),
                              ),
                        Container(
                            height: 260,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                num totalQuantity = items.fold(
                                  0, (sum, item) => sum + (item['quantity'] ?? 0));
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.amber,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Image.network(
                                                item['image'],
                                                width: 80,
                                                height: 80,
                                              ),
                                              // const SizedBox(width: 5),
                                              Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      item['name'],
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      "Rs. ${item['price']}.00",
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white),
                                                    )
                                                  ]),
                                              const SizedBox(width: 10),
                                              Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: <Widget>[
                                                    Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration:
                                                          ShapeDecoration(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 255, 255, 255),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(90),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "${item['quantity']}",
                                                          style: const TextStyle(
                                                            fontSize: 24,
                                                            color: Colors.black),
                                                        ),
                                                      ),
                                                    ), //
                                                  ]),
                                            ]),
                                      ),                                    
                                  ),
                                );
                              },
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0),
                          child: Container(
                            width: double.infinity,
                            height: 1,
                            decoration: ShapeDecoration(
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(90),
                              ),
                            ),
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
                                      fontSize: 18, color: Colors.black),
                                ),
                              ]),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Delivery",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                Text(
                                  "Rs. ${widget.order['delivery']}.00",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Total Price",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                Text(
                                  "Rs. ${widget.order['total_price']}.00",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ]),
                        ),                        
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0),
                          child: Container(
                            width: double.infinity,
                            height: 1,
                            decoration: ShapeDecoration(
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(90),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Column(
                          children: [
                            ExpansionTile(
                              key: UniqueKey(),
                              leading: Icon(Icons.payment),
                              title: Text("Payment Details"),
                              iconColor: Colors.white,
                              textColor: Colors.white,
                              backgroundColor: Colors.amber,
                              collapsedBackgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              visualDensity: VisualDensity.compact,
                              initiallyExpanded: isPaymentExpanded,
                              onExpansionChanged: (expanded) {
                                setState(() {
                                  isPaymentExpanded = expanded;
                                  if (expanded) isShippingExpanded = false;
                                });
                              },
                              children: [
                                StreamBuilder<QuerySnapshot>(
                                    stream: _firestore
                                        .collection('users')
                                        .doc(user?.uid)
                                        .collection('paymentDetails')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Text(
                                            "No Payment Details added!");
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
                                    })
                              ],
                            ),
                            const SizedBox(height: 10),
                            ExpansionTile(
                              key: UniqueKey(),
                              leading: Icon(Icons.location_city),
                              title: Text("Shipping Address"),
                              iconColor: Colors.white,
                              textColor: Colors.white,
                              backgroundColor: Colors.amber,
                              collapsedBackgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              visualDensity: VisualDensity.compact,
                              initiallyExpanded: isShippingExpanded,
                              onExpansionChanged: (expanded) {
                                setState(() {
                                  isShippingExpanded = expanded;
                                  if (expanded) isPaymentExpanded = false;
                                });
                              },
                              children: [
                                StreamBuilder<QuerySnapshot>(
                                    stream: _firestore
                                        .collection('users')
                                        .doc(user?.uid)
                                        .collection('shippingDetails')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Text(
                                            "No Shipping Details added!");
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
                              ],
                            )
                          ],
                        )
                      ])
                    ]),
              ),
            )));
  }
}
