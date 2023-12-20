import 'package:flutter/material.dart';
import 'package:food_delivery_app/screens/cart.dart';

class FoodDetails extends StatefulWidget {
  const FoodDetails({super.key});

  @override
  State<FoodDetails> createState() => FoodDetailsState();
}

class FoodDetailsState extends State<FoodDetails> {
  List<Map<String, dynamic>> ingredients = [
    {"image": "🥪", "name": "Bread"},
    {"image": "🥩", "name": "Chicken"},
    {"image": "🧀", "name": "Cheese"},
    {"image": "🍅", "name": "Tomato"},
    {"image": "🥬", "name": "Salad"}
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
        leading: const Icon(Icons.arrow_back),
        title: const Center(child: Text('Chicken Burger')),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border_outlined),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: Column(
          children: <Widget>[
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                    width: 250,
                    image: AssetImage(
                      'Assets/burger.jpg',
                    ))
              ],
            ),
            const Row(children: <Widget>[
              Text(
                'Ingredients',
                style: TextStyle(fontSize: 18),
              ),
            ]),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: 140,
              width: double.infinity,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(ingredients.length, (index) {
                    return Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          width: 75,
                          height: 100,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFFFC107),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(90),
                            ),
                          ),
                          child: Column(children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 3, vertical: 2),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    // Image.asset(
                                    //   ingredients[index]['image'],
                                    //   width: 60,
                                    //   height: 60,
                                    // ),
                                    Text(
                                      ingredients[index]['image'],
                                      style: const TextStyle(fontSize: 26),
                                    ),
                                    // Icon(
                                    //   ingredients[index]['icon'],
                                    //   color: Colors.white,
                                    // ),
                                    const SizedBox(height: 8),
                                    Text(
                                      ingredients[index]['name'],
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    );
                  })),
            ),
            const SizedBox(height: 8),
            Container(
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
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Chicken Burger',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                SizedBox(
                                  width: 120,
                                ),
                                Text(
                                  'Rs.95.00',
                                  style: TextStyle(
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
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '-',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              SizedBox(width: 28),
                              Text(
                                '2',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              SizedBox(width: 28),
                              Text(
                                '+',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              )
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
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Total',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                SizedBox(width: 180),
                                Text(
                                  'Rs. 190.00',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ]
                          ),
                        ),
                      ]),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              ElevatedButton(
                style: style,
                // style: ButtonStyle(
                //   backgroundColor: Colors.amber,
                //   textStyle: TextStyle(
                //     color: Colors.white,
                //     fontSize: 18
                //   )
                // ),
                //style: style,
                // style: ButtonStyle(
                //   textStyle: TextStyle(
                //     color: Colors.amber,
                //     fontSize: 18,
                //   )
                // ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Cart(),
                    ),
                  );
                },
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 50),
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
                  'Buy Now',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
