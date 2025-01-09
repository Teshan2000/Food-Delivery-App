import 'package:flutter/material.dart';
import 'package:food_delivery_app/screens/foodDetails.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({Key? key}) : super(key: key);

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  List<Map<String, dynamic>> foods = [
    {
      "image": "Assets/Foods/Chicken Burger.png",
      "name": "Chicken Burger",
      "price": "Rs.85.00"
    },
    {"image": "Assets/Foods/Ham Burger.png", "name": "Ham Burger", "price": "Rs.35.00"},
    {
      "image": "Assets/Foods/Veggie Burger.png",
      "name": "Veggie Burger",
      "price": "Rs.35.00"
    },
    {"image": "Assets/Foods/Cheese Burger.png", "name": "Cheese Burger", "price": "Rs.45.00"}
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 10, left: 10, right: 10
      ),      
      child: SingleChildScrollView(
        child: GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: List.generate(
            foods.length,
            (index) => GestureDetector(
              child: Card(
                elevation: 5,
                color: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        foods[index]['image'],
                        width: 90,
                        height: 90,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        foods[index]['name'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        foods[index]['price'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // onTap: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => const FoodDetails()),
              //   );
              // },
            ),
          ),
        ),
      ),
    );
  }
}
