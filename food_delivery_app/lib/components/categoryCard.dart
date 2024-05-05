import 'package:flutter/material.dart';
import 'package:food_delivery_app/screens/foodDetails.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: GestureDetector(
        child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: <Widget>[
              Card(
                elevation: 5,
                color: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            "Assets/burger.jpg",
                            width: 90,
                            height: 90,
                          ),
                          const SizedBox(width: 40),
                          const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Chicken Burger",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "Rs. 125.00",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                )
                              ])
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FoodDetails()),
          );
        },
      ),
    );
  }
}
