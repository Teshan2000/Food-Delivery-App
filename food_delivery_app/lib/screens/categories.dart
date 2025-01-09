import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/screens/foodDetails.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  String? category = 'Pizza';

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

  Future<List<Map<String, dynamic>>> fetchFoodData(String? category) async {
    List<Map<String, dynamic>> foods = [];

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('foods')
          .where('category', isEqualTo: category)
          .get();
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
        title: const Center(child: Text('Categories')),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.fastfood),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 10),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    height: 165,
                    width: double.infinity,
                    child: GestureDetector(
                        child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      scrollDirection: Axis.horizontal,
                      children: List.generate(categories.length, (index) {
                        return GestureDetector(
                            onTap: () {
                              setState(() {
                                category = categories[index]['name'];
                              });
                            },
                            child: Column(children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: Container(
                                  width: 90,
                                  height: 145,
                                  decoration: ShapeDecoration(
                                    color: Colors.amber,
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
                            ]));
                      }),
                    )),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  category! ?? 'Foods',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 800,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: FutureBuilder(
                  future: fetchFoodData(category),
                  builder: (context,
                      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          category == null
                              ? 'Select a category to view foods'
                              : 'No food items available in this category',
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }
                    List<Map<String, dynamic>> foods = snapshot.data!;
                    return GridView.count(
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
                                  Image.network(
                                    foods[index]['image'] ??
                                        'Assets/Foods/Chicken Burger.png',
                                    width: 90,
                                    height: 90,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    foods[index]['name'] ?? 'Name',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    "Rs. ${foods[index]['price'].toString()}.00",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  )
                                ],
                              ),
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
                                        price: foods[index]['price'].toInt(),
                                      )),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
