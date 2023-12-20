import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/foodCard.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

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
                  children: List.generate(3, (index) {
                return const FoodCard();
              })),
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
                              'Total',
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
                              'Sub Total',
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
