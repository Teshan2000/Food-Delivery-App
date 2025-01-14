import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/providers/alert_service.dart';

class Favourites extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  AlertService alertService = AlertService();
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    if (user == null) {
      alertService.showToast(context: context, text: 'You are not Logged in!', icon: Icons.warning);
    }
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      height: 675,
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(user?.uid)
                              .collection('favorites')
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
                              scrollDirection: Axis.vertical,
                              itemCount: favoriteItems.length,
                              itemBuilder: (context, index) {
                                var favourites = favoriteItems[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.amber,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 10),
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
                                              const SizedBox(width: 30),
                                              Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      favourites['name'],
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      "Rs. ${favourites['price']}.00",
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white),
                                                    )
                                                  ]),
                                              const SizedBox(width: 25),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                      onPressed: () async {
                                                        await FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(user?.uid)
                                                          .collection('favorites')
                                                          .doc(favourites['food_id']).delete();
                                                        alertService.showToast(context: context, text: 'Food removed from Favorites!', icon: Icons.info);
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
                                  ),
                                );
                              },                              
                            );
                          }
                        ),
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
