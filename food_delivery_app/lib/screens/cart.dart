import 'package:cart_stepper/cart_stepper.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/screens/foodDetails.dart';
import 'package:input_quantity/input_quantity.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  int quantity = 1;
  double totalPrice = 95.00;

  int _counterInit = 0;
  int _counter = 1;
  int _counterLimit = 1;
  double _dCounter = 0.01;

  @override
  void initState() {
    super.initState();
  }

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

  void onQtyChanged(int newQuantity) {
    setState(() {
      quantity = newQuantity;
      totalPrice = 95.00 * quantity;
    });
  }

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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 15),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            const SizedBox(width: 20),
                                            Image.asset(
                                              cart[index]['image'],
                                              width: 80,
                                              height: 80,
                                            ),
                                            const SizedBox(width: 25),
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
                                                ]),
                                            // Container(
                                            //   width: 50,
                                            //   height: 80,
                                            //   decoration: ShapeDecoration(
                                            //     color: const Color.fromARGB(255, 255, 255, 255),
                                            //     shape: RoundedRectangleBorder(
                                            //       borderRadius: BorderRadius.circular(90),
                                            //     ),
                                            //   ),
                                            //   child: InputQty.int(
                                            //     qtyFormProps: const QtyFormProps(cursorColor: Colors.amber),
                                            //     decoration: const QtyDecorationProps(
                                            //       width: 12,
                                            //       orientation: ButtonOrientation.vertical,
                                            //       isBordered: false,
                                            //       borderShape: BorderShapeBtn.circle,
                                            //     ),
                                            //     onQtyChanged: (newQty) {
                                            //       onQtyChanged(newQty);
                                            //     },
                                            //   ),
                                            // ),
                                            //                         Row(
                                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            //   children: [
                                            //     InputQty.int(
                                            //       messageBuilder: (minVal, maxVal, value) => const Text(
                                            //           "Button on Left",
                                            //           textAlign: TextAlign.center),
                                            //       decoration: const QtyDecorationProps(
                                            //           // qtyStyle: QtyStyle.btnOnLeft,
                                            //           orientation: ButtonOrientation.vertical,
                                            //           width: 4,
                                            //           btnColor: Colors.white,
                                            //           fillColor: Colors.black12,
                                            //           isBordered: false,
                                            //           borderShape: BorderShapeBtn.circle
                                            //         ),
                                            //     ),
                                            //   ],
                                            // ),
                                            const SizedBox(width: 25),
                                            CartStepperInt(
                                              style: const CartStepperStyle(
                                                  iconTheme: IconThemeData(
                                                      color: Colors.black),
                                                  foregroundColor: Colors.black,
                                                  activeForegroundColor:
                                                      Colors.black,
                                                  backgroundColor: Colors.white,
                                                  activeBackgroundColor:
                                                      Colors.white),
                                              value: _counter,
                                              axis: Axis.vertical,
                                              didChangeCount: (count) {
                                                setState(() {
                                                  _counter = count;
                                                });
                                              },
                                            ),
                                            const SizedBox(width: 15),
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
                              // 'Rs. 255.00',
                              'Rs. $totalPrice''0',
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
                            Text(
                              'Total',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            SizedBox(height: 40, width: 180),
                            Text(
                              // 'Rs. 305.00',
                              'Rs. $totalPrice''0',
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
