import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/appDrawer.dart';
import 'package:food_delivery_app/components/categoryCard.dart';
import 'package:food_delivery_app/components/foodCard.dart';
import 'package:food_delivery_app/components/searchBar.dart';
import 'package:food_delivery_app/screens/cart.dart';
import 'package:food_delivery_app/screens/categories.dart';
import 'package:food_delivery_app/screens/favourites.dart';
import 'package:food_delivery_app/screens/foodDetails.dart';
import 'package:food_delivery_app/screens/login.dart';
import 'package:food_delivery_app/screens/orders.dart';
import 'package:food_delivery_app/providers/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final AuthService _auth = AuthService();
  SharedPreferences? preferences;
  String? userId;

  Future<String?> _getUserId() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('userId');
  }

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
    {"image": "🍞", "name": "Bread"},
    {"image": "🥮", "name": "Cake"}
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

  Future<List<Map<String, dynamic>>> fetchFoodData() async {
    List<Map<String, dynamic>> foods = [];

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('foods').get();
      foods = snapshot.docs.map((doc) {
        return {
          "food_id": doc.id,
          "name": doc['name'],
          "image": doc['image'],
          "price": doc['price'],
        };
      }).toList();
    } catch (e) {
      print("Error fetching foods: $e");
    }
    return foods;
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
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const Cart(),
          //     ));
        },
        onOrdersPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Orders(),
              ));
        },
        onLogoutPressed: () async {
          preferences?.clear();
          await _auth.signOut();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
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
                AnimatedSearchBar(
                  label: 'Search Foods',
                  labelStyle: const TextStyle(fontSize: 16),
                  cursorColor: Colors.amber,
                  controller: _searchController,
                  onChanged: onSearchTextChanged,
                  searchDecoration: const InputDecoration(
                    labelText: 'Search Foods',
                    labelStyle: TextStyle(color: Colors.amber),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(35))),
                  ),
                  textInputAction: TextInputAction.done,
                  searchIcon: const Icon(Icons.search),
                  closeIcon: const Icon(Icons.close),
                ),
                const SizedBox(height: 6),
                // Container(
                //   child: ListView.builder(
                //     itemCount: _searchResults.length,
                //     itemBuilder: (context, index) {
                //       return ListTile(
                //         title: Text(_searchResults[index]),
                //         contentPadding: const EdgeInsets.symmetric(vertical: 0),
                //       );
                //     },
                //   ),
                // ),

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
                          horizontal: 5, vertical: 10),
                      height: 165,
                      width: double.infinity,
                      child: GestureDetector(
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
                                                style: const TextStyle(
                                                    fontSize: 35),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          categories[index]['name'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ]);
                            })),
                        onTap: () {
                          AnimationController _controller = AnimationController(
                            vsync: this,
                            duration: Duration(milliseconds: 300),
                          );

                          showModalBottomSheet(
                            context: context,
                            builder: (_) => BottomSheet(
                              animationController: _controller,
                              onClosing: () {
                                TextButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(Icons.close),
                                    label: Text('Close'));
                              },
                              builder: (BuildContext context) {
                                return CategoryCard();
                              },
                            ),
                          );
                        },
                      ),
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
                      height: 800,
                      child: GestureDetector(
                        child: FutureBuilder(
                          future: fetchFoodData(),
                          builder: (context,
                              AsyncSnapshot<List<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                  child: Text('No food data available'));
                            }
                            List<Map<String, dynamic>> foods = snapshot.data!;
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: foods.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  child: Card(
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
                                              Image.network(
                                                foods[index]['image'] ??
                                                    'Assets/Foods/Chicken Burger.png',
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
                                                      foods[index]['name'] ??
                                                          'Name',
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      "Rs. ${foods[index]['price'].toString()}.00",
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white),
                                                    )
                                                  ])
                                            ]),
                                      ),
                                    ]),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FoodDetails(
                                            id: foods[index]['food_id'],
                                            name: foods[index]['name'],
                                            image: foods[index]['image'],
                                            price: foods[index]['price'].toInt(),
                                          )),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
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
