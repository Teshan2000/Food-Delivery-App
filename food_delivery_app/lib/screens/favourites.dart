import 'package:flutter/material.dart';
import 'package:food_delivery_app/screens/foodDetails.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  List<Map<String, dynamic>> favourites = [
    {
      "image": "Assets/Foods/Ham Burger.png",
      "name": "Ham Burger",
      "price": "Rs.135.00"
    },
    {
      "image": "Assets/Foods/Hotdog.png",
      "name": "Hotdog",
      "price": "Rs.65.00"
    },
    {
      "image": "Assets/Foods/Pizza.png",
      "name": "Pepperoni Pizza",
      "price": "Rs.125.00"
    },
    {
      "image": "Assets/Foods/Taco.png",
      "name": "Veggi Taco",
      "price": "Rs.35.00"
    },
    {
      "image": "Assets/Foods/Sandwich.png",
      "name": "Fish Sandwiches",
      "price": "Rs.35.00"
    },
    {
      "image": "Assets/Foods/Cheese Burger.png",
      "name": "Cheese Burger",
      "price": "Rs.115.00"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Center(
          child: Text(
            'Favourites'
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.favorite)
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
                          children: List.generate(favourites.length, (index) {
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
                                          favourites[index]['image'],
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
                                                favourites[index]['name'],
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                favourites[index]['price'],
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
