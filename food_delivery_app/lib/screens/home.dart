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
  final AuthService _auth = AuthService();
  SharedPreferences? preferences;
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  // String? userId;

  // Future<String?> _getUserId() async {
  //   final preferences = await SharedPreferences.getInstance();
  //   return preferences.getString('userId');
  // }

  Future<void> _fetchSearchResults(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
        _isSearching = false;
      });
      return;
    }
    setState(() {
      _isSearching = true;
    });
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('foods')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      List<Map<String, dynamic>> results = snapshot.docs.map((doc) {
        return {
          "food_id": doc.id,
          "name": doc['name'],
          "image": doc['image'],
          "price": doc['price'],
        };
      }).toList();

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      print('Error fetching search results: $e');
      setState(() {
        _isSearching = false;
      });
    }
  }

  Future<void> updateSearchResults(
      List<Map<String, dynamic>> results, bool searchingStatus) async {
    setState(() {
      _searchResults = results;
      _isSearching = searchingStatus;
    });
  }

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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Searchbar(
              onSearchResultsUpdated: updateSearchResults,
            ),
          ),
        ),
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
                builder: (context) => Favourites(),
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
                if (_isSearching)
                  Center(child: const CircularProgressIndicator())
                else if (_searchResults.isNotEmpty)
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final food = _searchResults[index];
                        return GestureDetector(
                          child: Card(
                            elevation: 5,
                            color: Colors.amber,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 15),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    const SizedBox(width: 20),
                                    Image.network(
                                      food['image'] ??
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
                                            food['name'] ?? 'Name',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            "Rs. ${food['price'].toString()}.00",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          )
                                        ])
                                  ]),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FoodDetails(
                                        id: food[index]['food_id'],
                                        name: food[index]['name'],
                                        image: food[index]['image'],
                                        price: food[index]['price'].toInt(),
                                      )),
                            );
                          },
                        );
                      },
                    ),
                  )
                //               else if (_searchTriggered) // If search has been triggered but no results found
                // const Center(child: Text('No results found'))
                else
                  Container(),
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
                                                price: foods[index]['price']
                                                    .toInt(),
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
}
