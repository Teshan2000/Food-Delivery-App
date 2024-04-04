import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Map<String, dynamic>> Orders = [
    {
      "image": "Assets/Foods/Ham Burger.png",
      "name": "Ham Burger",
      "price": "Rs.95.00",
      "quantity": "2",
      "total": "Rs.190.00"
    },
    {
      "image": "Assets/Foods/Pastry.png",
      "name": "Fish Pastry",
      "price": "Rs.35.00",
      "quantity": "1",
      "total": "Rs.35.00"
    },
    {
      "image": "Assets/Foods/Taco.png",
      "name": "Veggi Taco",
      "price": "Rs.35.00",
      "quantity": "3",
      "total": "Rs.105.00"
    },  
    {
      "image": "Assets/Foods/Pizza.png",
      "name": "Pepperoni Pizza",
      "price": "Rs.125.00",
      "quantity": "1",
      "total": "Rs.125.00"
    },  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Center(
          child: Text(
            'Orders'
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.shopping_bag)
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      height: 675,
                      child: GestureDetector(
                        child: ListView(
                            scrollDirection: Axis.vertical,
                            children: List.generate(Orders.length, (index) {
                              return Card(
                              elevation: 5,
                              color: Colors.amber,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
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
                                                    Orders[index]['name'],
                                                    style: const TextStyle(
                                                        fontSize: 16, color: Colors.white),
                                                  ),
                                                  const SizedBox(
                                                    width: 150,
                                                  ),
                                                  Text(
                                                    Orders[index]['price'],
                                                    style: const TextStyle(
                                                        fontSize: 16, color: Colors.white),
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
                                                horizontal: 18, vertical: 5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Image.asset(
                                                    Orders[index]['image'],
                                                    width: 80,
                                                    height: 80,
                                                  ),
                                                const SizedBox(width: 195),
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
                                                      Orders[index]['quantity'],
                                                      style: const TextStyle(
                                                          fontSize: 24, color: Colors.black),
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
                                              horizontal: 20, vertical: 18
                                            ),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  const Text(
                                                    'Total',
                                                    style: TextStyle(
                                                        fontSize: 16, color: Colors.white),
                                                  ),
                                                  const SizedBox(width: 190),
                                                  Text(
                                                    Orders[index]['total'],
                                                    style: const TextStyle(
                                                        fontSize: 16, color: Colors.white),
                                                  ),
                                                ]
                                            ),
                                          ),
                                        ]),
                                  ],
                                ),
                              );
                            })
                        )
                      )
                    )
                  ]
                )
              ]
            ),
          ),
        )
      )
    );
  }
}
