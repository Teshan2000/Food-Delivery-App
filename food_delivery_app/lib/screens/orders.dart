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
      "image": "Assets/Foods/Pizza.png",
      "name": "Pepperoni Pizza",
      "price": "Rs.125.00",
      "quantity": "1",
      "total": "Rs.125.00"
    },
    {
      "image": "Assets/Foods/Taco.png",
      "name": "Veggi Taco",
      "price": "Rs.35.00",
      "quantity": "3",
      "total": "Rs.105.00"
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
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                height: 250,
                                width: 350,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFFFC107),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 15),
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
                                                    width: 120,
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
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 15),
                                            height: 35,
                                            width: 135,
                                            decoration: ShapeDecoration(
                                              color: const Color.fromARGB(255, 255, 255, 255),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(40),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Image.asset(
                                                    Orders[index]['image'],
                                                    width: 80,
                                                    height: 80,
                                                  ),
                                                const SizedBox(width: 28),
                                                const Text(
                                                  '2',
                                                  style: TextStyle(
                                                      fontSize: 26, color: Colors.black),
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
                                              horizontal: 15, vertical: 15
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
                                                  const SizedBox(width: 180),
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
