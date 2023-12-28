import 'package:flutter/material.dart';
import 'package:food_delivery_app/screens/foodDetails.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<Map<String, dynamic>> cart = [
    {
      "image": "Assets/Foods/Chicken Burger.png",
      "name": "Chicken Burger",
      "price": "Rs.95.00"
    },
    {
      "image": "Assets/Foods/Sandwich.png",
      "name": "Fish Sandwiches",
      "price": "Rs.35.00"
    },
    {
      "image": "Assets/Foods/Taco.png",
      "name": "Veggi Taco",
      "price": "Rs.35.00"
    }
  ];

  @override
  Widget build(BuildContext context) {

    final ButtonStyle style = ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        elevation: 5,
        textStyle: const TextStyle(fontSize: 16, color: Colors.amber));

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
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    height: 375,
                    child: GestureDetector(
                      child: ListView(
                          scrollDirection: Axis.vertical,
                          children: List.generate(cart.length, (index) {
                            return Card(
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
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        const SizedBox(width: 20),
                                        Image.asset(
                                          cart[index]['image'],
                                          width: 80,
                                          height: 80,
                                        ),
                                        const SizedBox(width: 40),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                cart[index]['name'],
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                cart[index]['price'],
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              )
                                            ])
                                      ]),
                                ),
                              ]),
                            );
                          })),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FoodDetails()),
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
                      const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Sub Total',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            SizedBox(height: 40, width: 180),
                            Text(
                              'Rs. 255.00',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
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
                      Row(children: <Widget>[
                        const SizedBox(height: 20),
                        Container(
                          width: 330,
                          height: 3,
                          decoration: ShapeDecoration(
                            color: const Color.fromARGB(0, 0, 0, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(90),
                              side: const BorderSide(),
                            ),
                          ),
                        ),
                      ]),
                      const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Total',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            SizedBox(height: 40, width: 180),
                            Text(
                              'Rs. 305.00',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ]),
                      const SizedBox(height: 30, width: 50),
                      ElevatedButton(
                        style: style,
                        // style: ButtonStyle(
                        //   textStyle: TextStyle(
                        //     color: Colors.amber,
                        //     fontSize: 18,
                        //   )
                        // ),
                        onPressed: () {},
                        child: const Text(
                          'Proceed To Checkout',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ]),
              )
            ]))),
      ),
    );
  }
}
