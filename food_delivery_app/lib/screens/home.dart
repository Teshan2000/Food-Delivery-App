import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/appDrawer.dart';
import 'package:food_delivery_app/components/foodCard.dart';
import 'package:food_delivery_app/components/searchBar.dart';
import 'package:food_delivery_app/screens/cart.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final List<String> _foodList = [
    "Pizza",
    "Burger",
    "Hotdog",
    "Sandwich",
    "Taco",
    "Bun",
    "Bread",
  ];

  final List<String> _searchResults = [];

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

  Widget _buildSearchResults() {
    return Container(
      height: 5,
      child: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_searchResults[index]),
            contentPadding: EdgeInsets.symmetric(vertical: 4),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Hello, Peter!'),
        actions: const [
          EndDrawerButton(),
        ],
      ),
      endDrawer: AppDrawer(
        onProfilepressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FoodDeliveryApp(),
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
                builder: (context) => const Cart(),
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
                builder: (context) => const FoodCard(),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: onSearchTextChanged,
                    decoration: const InputDecoration(
                      labelText: 'Search Foods',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.search),
                    ),                  
                  ),
                ),
                const SizedBox(height: 6),
                _buildSearchResults(),
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
                      padding:
                          const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
                      padding:
                          const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          const SizedBox(width: 20),
                                          Image.asset(
                                            popular[index]['image'],
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
                                                  popular[index]['name'],
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  popular[index]['price'],
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

  void onSearchTextChanged(String query) {
    _searchResults.clear();
    if (query.isEmpty) {
      setState(() {});
      return;
    }

    for (var food in _foodList) {
      if (food.toLowerCase().contains(query.toLowerCase())) {
        _searchResults.add(food);
      }
    }

    setState(() {});
  }  
}
