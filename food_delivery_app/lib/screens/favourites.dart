import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/screens/foodDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  bool isFav = false;
  SharedPreferences? preferences;
  String? userId;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> _getUserId() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('userId');
  }

  List<Map<String, dynamic>> favourites = [
    {
      "image": "Assets/Foods/Ham Burger.png",
      "name": "Ham Burger",
      "price": "Rs.135.00"
    },
    {"image": "Assets/Foods/Hotdog.png", "name": "Hotdog", "price": "Rs.65.00"},
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
          child: Text('Favourites'),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      height: 675,
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .collection('favourites')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }
                            var favoriteItems = snapshot.data!.docs;
                            if (favoriteItems.isEmpty) {
                              return Center(child: Text("No favorite items."));
                            }
                            return ListView.builder(
                              itemCount: favoriteItems.length,
                              itemBuilder: (context, index) {
                                var favourites = favoriteItems[index];
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
                                            Image.network(
                                              favourites['image'],
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
                                                    favourites['name'],
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    favourites['price'],
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                  )
                                                ]),
                                            const SizedBox(width: 8),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                    onPressed: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(userId)
                                                          .collection('favourites')
                                                          .doc(favourites['food_id'])
                                                          .delete();
                                                      // setState(() {
                                                      //   isFav = !isFav;
                                                      // });
                                                    },
                                                    icon: Icon(
                                                      isFav
                                                          ? Icons
                                                              .favorite_border
                                                          : Icons.favorite,
                                                      color: Colors.red,
                                                    ))
                                              ],
                                            )
                                          ]),
                                    ),
                                  ]),
                                );
                              },
                              // scrollDirection: Axis.vertical,
                            );
                          }),

                      // onTap: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const FoodDetails()),
                      //   );
                      // },
                    )
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
