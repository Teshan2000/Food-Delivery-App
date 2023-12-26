import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/appDrawer.dart';
import 'package:food_delivery_app/screens/categories.dart';
import 'package:food_delivery_app/screens/favourites.dart';
import 'package:food_delivery_app/screens/foodDetails.dart';
import 'package:food_delivery_app/screens/orders.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> categories = [
    {"image": "🍕", "name": "Pizza"},
    {"image": "🍔", "name": "Burger"},
    {"image": "🌭", "name": "Hotdog"},
    {"image": "🥪", "name": "Sandwich"},
    {"image": "🌮", "name": "Taco"},
    {"image": "🥐", "name": "Bun"},
    {"image": "🍞", "name": "Bread"}
  ];

  List<Map<String, dynamic>> popular = [
    {
      "image": "Assets/Foods/pastry.png",
      "name": "Chicken Pastry",
      "price": "Rs.85.00"
    },
    {
      "image": "Assets/Foods/sandwich.png",
      "name": "Fish Sandwiches",
      "price": "Rs.35.00"
    },
    {
      "image": "Assets/Foods/taco.png",
      "name": "Veggi Taco",
      "price": "Rs.35.00"
    },
    {"image": "Assets/Foods/hotdog.png", 
     "name": "Hotdog", 
     "price": "Rs.65.00"
    },
    {
      "image": "Assets/Foods/crossiant.png",
      "name": "Crossiant",
      "price": "Rs.45.00"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Hello, Peter!'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppDrawer(
                      onProfilepressed: () {},
                      onCategoriesPressed: () {},
                      onFavoritesPressed: () {},
                      onCartPressed: () {},
                      onOrdersPressed: () {},
                      onLogoutPressed: () {},
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              )),
          // Form(
          //   child: Container(
          //     padding: const EdgeInsets.all(20),
          //     decoration: const BoxDecoration(color: Colors.white)
          //   )
          // ),
        ],
      ),
      endDrawer: AppDrawer(
        onProfilepressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Categories(),
              ));
        },
        onCategoriesPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Categories(),
              ));
        },
        onFavoritesPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Favourites(),
              ));
        },
        onCartPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Categories(),
              ));
        },
        onOrdersPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Orders(),
              ));
        },
        onLogoutPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Categories(),
              ));
        },
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
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      "Explore Foods",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Categories(),
                          ),
                        );
                      },
                      child: const Text(
                        "View All",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ]),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    height: 165,
                    width: double.infinity,
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(categories.length, (index) {
                          return Column(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: Container(
                                width: 90,
                                height: 145,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFFFC107),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(90),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 16),
                                      child: Container(
                                        width: 70,
                                        height: 70,
                                        decoration: ShapeDecoration(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(90),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            categories[index]['image'],
                                            style:
                                                const TextStyle(fontSize: 35),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      categories[index]['name'],
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ]);
                        })),
                  ),
                ],
              ),
              const Text(
                "Most Popular",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    child: GestureDetector(
                      child: ListView(
                          scrollDirection: Axis.vertical,
                          children: List.generate(popular.length, (index) {
                            return Row(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      popular[index]['imageAsset'],
                                      width: 80,
                                      height: 80,
                                    ),
                                    const SizedBox(width: 40),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          categories[index]['name'],
                                          style: const TextStyle(
                                              fontSize: 18, color: Colors.white),
                                        ),
                                        Text(
                                          categories[index]['price'],
                                          style: const TextStyle(
                                              fontSize: 18, color: Colors.white),
                                        )
                                      ]
                                    )
                                  ]
                                ),
                              ),
                            ]);
                          })),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const FoodDetails()),);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}
