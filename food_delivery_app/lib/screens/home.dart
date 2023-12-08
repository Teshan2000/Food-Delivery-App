import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/appDrawer.dart';
import 'package:food_delivery_app/components/foodCard.dart';
import 'package:food_delivery_app/screens/categories.dart';
import 'package:food_delivery_app/screens/favourites.dart';
import 'package:food_delivery_app/screens/orders.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Hello, Peter!'),
        actions: [
          IconButton(
              onPressed: () async {},
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
            )
          );
        },
        onFavoritesPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => const Favourites(),
            )
          );
        },
        onCartPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => const Categories(),
            )
          );
        },
        onOrdersPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => const Orders(),
            )
          );
        },
        onLogoutPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => const Categories(),
            )
          );
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
                      onPressed: () {},
                      child: const Text(
                        "View All",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ]
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10, 
                  vertical: 15
                ),
                 height: 180,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(6, (index) {
                      return const Card(
                        elevation: 5,
                        color: Colors.amber,
                        child: Column(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 45.0,
                              backgroundImage: AssetImage(
                                "Assets/burger.jpg",
                              ),
                              backgroundColor: Colors.white,
                            ),
                            // Image.asset(
                            //   "Assets/burger.jpg",
                            //   width: 90,
                            //   height: 100,
                            // ),
                            Text(
                              "Burger",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                  ),
              ),  
              const Text(
                "Most Popular",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Column(
                children: List.generate(10, (index) {
                  return const FoodCard();
                })
              ),
              // TextButton(
              //   onPressed: () { },
              //),
            ],
          ),
        )),
      ),
    );
  }
}
