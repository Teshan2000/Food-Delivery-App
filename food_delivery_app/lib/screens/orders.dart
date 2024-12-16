import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> Orders = [];

  Stream<List<Map<String, dynamic>>> fetchOrders() {
    final User? user = auth.currentUser;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('orders')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    if (user == null) {
      return Center(child: Text("Please log in."));
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Center(
            child: Text('Orders'),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_bag))
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          height: 675,
                          child: StreamBuilder<List<Map<String, dynamic>>>(
                              stream: fetchOrders(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Center(child: Text("No orders yet."));
                                }
                                var orders = snapshot.data!;
                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: orders.length,
                                  itemBuilder: (context, index) {
                                    var order = orders[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Card(
                                        elevation: 5,
                                        color: Colors.amber,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      "Order ${order['order_id']}",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        // order['order_id']
                                                        // Navigator.push(
                                                        //   context,
                                                        //   MaterialPageRoute(
                                                        //     builder: (context) => const Categories(),
                                                        //   ),
                                                        // );
                                                      },
                                                      child: const Text(
                                                        "View All",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.amber,
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                            ),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 20, vertical: 18),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          Text(
                                                            "Order #001",
                                                            style: const TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.white),
                                                          ),
                                                          const SizedBox(
                                                            width: 150,
                                                          ),
                                                          Text(
                                                            "${DateFormat('yyyy-MM-dd').format(order['order_date'].toDate())}",
                                                            style: const TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.white),
                                                          ),
                                                        ]),
                                                  ),
                                                ]),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    width: 300,
                                                    height: 3,
                                                    decoration: ShapeDecoration(
                                                      color: const Color.fromARGB(255,255, 255, 255),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(90),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 18, vertical: 5),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: <Widget>[
                                                        // Image.asset(
                                                        //     order['image'],
                                                        //     width: 80,
                                                        //     height: 80,
                                                        //   ),
                                                        const SizedBox(
                                                            width: 195),
                                                        Container(
                                                          width: 30,
                                                          height: 30,
                                                          decoration: ShapeDecoration(
                                                            color: const Color.fromARGB(255, 255, 255, 255),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(
                                                                          90),
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "${order['quantity']}",
                                                              style: const TextStyle(
                                                                  fontSize: 24,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    width: 300,
                                                    height: 3,
                                                    decoration: ShapeDecoration(
                                                      color: const Color.fromARGB(255, 255, 255, 255),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(90),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                                Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 20, vertical: 18),
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          const Text(
                                                            'Quantity',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.white),
                                                          ),
                                                          const SizedBox(width: 190),
                                                          Text(
                                                            "${order['quantity']}",
                                                            style: const TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.white),
                                                          ),
                                                        ]),
                                                  ),
                                                ]),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 20, vertical: 18),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          const Text(
                                                            'Total',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.white),
                                                          ),
                                                          const SizedBox(width: 190),
                                                          Text(
                                                            "Rs. ${order['total_price']}.00",
                                                            style:const TextStyle(
                                                              fontSize:16,
                                                              color: Colors.white),
                                                          ),
                                                        ]),
                                                  ),
                                                ]),
                                                Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 20, vertical: 18),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          Text(
                                                            "${order['status']}",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.white),
                                                          ),
                                                          const SizedBox(width: 190),
                                                          Text(
                                                            "View Details",
                                                            style: const TextStyle(
                                                              fontSize: 16,
                                                               color: Colors.white),
                                                          ),
                                                        ]),
                                                  ),
                                                ]),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                        )
                      ])
                    ]),
              ),
            )));
  }
}
