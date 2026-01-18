import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/screens/orderDetails.dart';
import 'package:intl/intl.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

enum FilterStatus { Delivered, Pending, Completed }

class _OrdersState extends State<Orders> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> Orders = [];
  FilterStatus status = FilterStatus.Delivered;
  Alignment _alignment = Alignment.centerLeft;

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
    double height = ScreenSize.height(context);
    bool isLandscape = ScreenSize.orientation(context);
    
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
          ),
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 10), child: SizedBox(),
          ),
        ),
        body: SafeArea(            
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: isLandscape ? 5 : 7),
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 35,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    for (FilterStatus filterStatus
                                        in FilterStatus.values)
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (filterStatus == FilterStatus.Delivered) {
                                              status = FilterStatus.Delivered;
                                              _alignment = Alignment.centerLeft;
                                            } else if (filterStatus == FilterStatus.Pending) {
                                              status = FilterStatus.Pending;
                                              _alignment = Alignment.center;
                                            } else if (filterStatus == FilterStatus.Completed ) {
                                              status = FilterStatus.Completed ;
                                              _alignment = Alignment.centerRight;
                                            }
                                          });
                                        },
                                        child: Center(child: Text(filterStatus.name)),
                                      ))
                                  ],
                                ),
                              ),
                              AnimatedAlign(
                                alignment: _alignment,
                                duration: Duration(milliseconds: 200),
                                child: Container(
                                  width: isLandscape ? 180 : 100,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                      child: Text(
                                    status.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          height: height,                          
                          child: StreamBuilder<List<Map<String, dynamic>>>(
                            stream: fetchOrders(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Center(child: Text("No orders yet."));
                                }
                                String orderStatus = status == FilterStatus.Delivered
                                  ? 'Delivered' : status == FilterStatus.Pending
                                  ? 'Pending' : 'Completed';
                                var filteredOrders = snapshot.data!.where((order){
                                  return order['status']  == orderStatus;
                                }).toList();
                                if (filteredOrders.isEmpty) {
                                  return Center(child: Text("No orders yet."));
                                }
                                return ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: filteredOrders.length,
                                  itemBuilder: (context, index) {
                                    var order = filteredOrders[index];
                                    final items = order['items'] as List<dynamic>;
                                    num totalQuantity = items.fold(
                                      0, (sum, item) => sum + (item['quantity'] ?? 0));
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 3),
                                      child: Card(
                                        color: Colors.amber,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[                                            
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 12),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "Order #${(order['order_id']).substring(0, 5) + ''}",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,),
                                                  ),
                                                  GestureDetector(
                                                    child: Text(
                                                      "View Details",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ), 
                                                    onTap: () {
                                                      Navigator.push(
                                                        context, MaterialPageRoute(
                                                          builder: (context) => OrderDetails(
                                                            order: order,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ]),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 15, vertical: 0),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 1,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(90),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 20, vertical: 12),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        Container(
                                                          width: 30,
                                                          height: 30,
                                                          decoration: ShapeDecoration(
                                                            color: const Color.fromARGB(255, 255, 255, 255),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(90),
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "${totalQuantity}",
                                                              style: const TextStyle(
                                                                fontSize: 24,
                                                                color: Colors.black),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          "Rs. ${order['total_price']}.00",
                                                          style: const TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,),
                                                        ),
                                                      ]
                                                    ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 15, vertical: 0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 1,
                                                    decoration: ShapeDecoration(
                                                      color: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(90),
                                                      ),
                                                    ),
                                                  ),
                                                ),                                                  
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 20, vertical: 12),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      order['status'] == 'Delivered' ?
                                                      TextButton(
                                                        onPressed: () async{
                                                          final User? user = auth.currentUser;
                                                          if (user == null) return;

                                                          try {
                                                            await FirebaseFirestore.instance
                                                                .collection('users')
                                                                .doc(user.uid)
                                                                .collection('orders')
                                                                .doc(order['order_id'])
                                                                .update({'status': 'Completed'});

                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(content: Text("Order marked as completed")),
                                                            );
                                                          } catch (e) {
                                                            print("Error updating order status: $e");
                                                          }
                                                        }, 
                                                        child: Text(
                                                        "Complete",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.white, fontWeight: FontWeight.bold,),
                                                        ),
                                                      ) :
                                                      Text(
                                                        "${order['status']}",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white, fontWeight: FontWeight.bold,),
                                                      ),
                                                      Text(
                                                        "${DateFormat('yyyy-MM-dd').format(order['order_date'].toDate())}",
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white, fontWeight: FontWeight.bold,),
                                                      ),
                                                    ]
                                                  ),
                                                ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                          )
                        )                        
                      ])
                    ]),
              ),
            )));
  }
}
