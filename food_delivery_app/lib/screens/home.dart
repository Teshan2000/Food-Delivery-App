import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/appDrawer.dart';
import 'package:food_delivery_app/components/searchBar.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/screens/cart.dart';
import 'package:food_delivery_app/screens/categories.dart';
import 'package:food_delivery_app/screens/favourites.dart';
import 'package:food_delivery_app/screens/foodDetails.dart';
import 'package:food_delivery_app/screens/login.dart';
import 'package:food_delivery_app/screens/orders.dart';
import 'package:food_delivery_app/providers/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery_app/screens/profilePage.dart';
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
  String? userId;

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
    bool isLandscape = ScreenSize.orientation(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Hello, Peter'),
        automaticallyImplyLeading: false,
        actions: const [
          EndDrawerButton(),
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 70),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3,),
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
                builder: (context) => ProfilePage(),
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
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Cart(
                  delivery: 50,
                  deliveryId: '',
                ),
              ));
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (_isSearching)
                Center(child: const CircularProgressIndicator())
              else if (_searchResults.isNotEmpty)
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final food = _searchResults[index];
                        return GestureDetector(
                          child: Card(
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
                                                color: Colors.white, fontWeight: FontWeight.bold,),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "Rs. ${food['price'].toString()}.00",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white, fontWeight: FontWeight.bold,),
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
                                        id: food['food_id'],
                                        name: food['name'],
                                        image: food['image'],
                                        price: food['price'].toInt(),
                                      )),
                            );
                          },
                        );
                      },
                    ),
                  ),
                )
              else Container(),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        "Explore Foods",
                        style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold
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
                            fontSize: 16, fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ]),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    height: 162,
                    width: double.infinity,
                    child: ListView(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          scrollDirection: Axis.horizontal,
                          children: List.generate(categories.length, (index) {
                            return Column(children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: isLandscape ? 4 : 2),
                                child: Container(
                                  width: 90,
                                  height: 135,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFFFC107),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 14),
                                        child: Container(
                                          width: 65,
                                          height: 65,
                                          decoration: ShapeDecoration(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              categories[index]['image'],
                                              style: const TextStyle(fontSize: 35,),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        categories[index]['name'],
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]
                          );
                        }
                      )
                    ),                      
                  ),                  
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  "Popular Foods",
                  style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
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
                                    color: Colors.amber,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 15),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Image.network(
                                                foods[index]['image'] ??
                                                    'Assets/Foods/Chicken Burger.png',
                                                width: 80,
                                                height: 80,
                                              ),
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
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      "Rs. ${foods[index]['price'].toString()}.00",
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold),
                                                    )
                                                  ]),      
                                                  Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Icon(
                                                      Icons.favorite,
                                                      color: Colors.amber,
                                                    )
                                                  ],
                                                )                                           
                                            ]),
                                      ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
