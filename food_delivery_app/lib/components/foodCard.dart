import 'package:flutter/material.dart';
import 'package:food_delivery_app/screens/foodDetails.dart';

class FoodCard extends StatefulWidget {
  const FoodCard({super.key});

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  List<Map<String, dynamic>> popular = [
    {
      "image": "Assets/Foods/Pastry.png",
      "name": "Chicken Pastry",
      "price": "Rs.85.00"
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
    },
    {"image": "Assets/Foods/Hotdog.png", "name": "Hotdog", "price": "Rs.65.00"},
    {
      "image": "Assets/Foods/Crossiant.png",
      "name": "Crossiant",
      "price": "Rs.45.00"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          height: 475,
          child: GestureDetector(
            child: ListView(
                scrollDirection: Axis.vertical,
                children: List.generate(popular.length, (index) {
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
                                popular[index]['image'],
                                width: 80,
                                height: 80,
                              ),
                              const SizedBox(width: 40),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      popular[index]['name'],
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                    Text(
                                      popular[index]['price'],
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.white),
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
                MaterialPageRoute(builder: (context) => const FoodDetails()),
              );
            },
          ),
        ),
      ],
    );
  }
}
