import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/providers/alert_service.dart';
import 'package:food_delivery_app/screens/cart.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodDetails extends StatefulWidget {
  final String id;
  final String name;
  final String image;
  final int price;

  const FoodDetails(
      {super.key,
      required this.id,
      required this.name,
      required this.image,
      required this.price});

  @override
  State<FoodDetails> createState() => FoodDetailsState();
}

class FoodDetailsState extends State<FoodDetails>
    with TickerProviderStateMixin {
  bool isFav = false;
  int quantity = 1;
  int? totalPrice;
  SharedPreferences? preferences;
  String userId = '';
  final FirebaseAuth auth = FirebaseAuth.instance;
  AlertService alertService = AlertService();
  List<Map<String, dynamic>> ingredients = [];
  late final Map<String, dynamic> foodData;

  @override
  void initState() {
    super.initState();
    getUserId();
    fetchIngredients();
    checkIfFavorite();
  }

  // Future<String?> _getUserId() async {
  //   final preferences = await SharedPreferences.getInstance();
  //   return userId = preferences.getString('userId');
  // }

  Future<void> fetchIngredients() async {
    try {
      CollectionReference ingredientsRef = FirebaseFirestore.instance
          .collection('foods')
          .doc(widget.id)
          .collection('ingredients');

      QuerySnapshot ingredientsData = await ingredientsRef.get();
      setState(() {
        ingredients = ingredientsData.docs
            .map((doc) => {"image": doc['image'], "name": doc['name']})
            .toList();
      });
    } catch (e) {
      print("Failed to fetch ingredients: $e");
    }
  }

  Future<void> getUserId() async {
    final User? user = auth.currentUser;
    if (user != null) {
      userId = user.uid;
    }
  }

  Future<void> checkIfFavorite() async {
    try {
      DocumentSnapshot favSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(widget.name)
          .get();

      if (favSnapshot.exists) {
        setState(() {
          isFav = true;
        });
      }
    } catch (e) {
      print('Error checking favorite: $e');
    }
  }

  Future<void> toggleFavorite() async {
    try {
      DocumentReference favRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(widget.name);

      if (isFav) {
        await favRef.delete();
        setState(() {
          isFav = false;
        });
      } else {
        await favRef.set({
          'food_id': widget.id,
          'name': widget.name,
          'image': widget.image,
          'price': widget.price,
        });
        setState(() {
          isFav = true;
        });
        alertService.showToast(context: context, text: 'Food added to Favorites!', icon: Icons.info);
      }
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  Future<void> addToCart() async {
    try {
      DocumentReference cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(widget.name);

      await cartRef.set({
        'food_id': widget.id,
        'name': widget.name,
        'image': widget.image,
        'price': widget.price,
        'quantity': quantity,
      });
      alertService.showToast(context: context, text: 'Food added to Cart!', icon: Icons.info);
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  List<Map<String, dynamic>> delivery = [
    {
      "image": "Assets/pick me foods.jpg",
      "name": "Pick Me Foods",
      "price": "Rs. 50.00",
      "rate": "⭐ 4.5"
    },
    {
      "image": "Assets/uber eats.jpg",
      "name": "Uber Eats",
      "price": "Free Delivery",
      "rate": "⭐ 4.8"
    }
  ];

  void onQtyChanged(int newQuantity) {
    setState(() {
      quantity = newQuantity;
      totalPrice = widget.price * quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.amber,
        textStyle: const TextStyle(fontSize: 16, color: Colors.white));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Center(child: Text(widget.name)),
        actions: [
          IconButton(
            onPressed: toggleFavorite,
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
            ),
            color: Colors.red,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(width: 250, image: NetworkImage(widget.image))
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Row(children: <Widget>[
                Text(
                  'Ingredients',
                  style: TextStyle(fontSize: 18),
                ),
              ]),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              height: 140,
              width: double.infinity,
              child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  scrollDirection: Axis.horizontal,
                  children: List.generate(ingredients.length, (index) {
                    return Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Container(
                          width: 75,
                          height: 100,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFFFC107),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(90),
                            ),
                          ),
                          child: Column(children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 3, vertical: 2),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      ingredients[index]['image'],
                                      style: const TextStyle(fontSize: 26),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      ingredients[index]['name'],
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    );
                  })),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: 240,
              width: 355,
              decoration: ShapeDecoration(
                color: const Color(0xFFFFC107),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  widget.name,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                SizedBox(
                                  width: 110,
                                ),
                                Text(
                                  "Rs. ${widget.price}.00",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ]),
                        ),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 300,
                          height: 3,
                          decoration: ShapeDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(90),
                            ),
                          ),
                        ),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 140,
                          height: 25,
                          decoration: ShapeDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(90),
                            ),
                          ),
                          child: InputQty.int(
                            qtyFormProps:
                                const QtyFormProps(cursorColor: Colors.amber),
                            decoration: const QtyDecorationProps(
                              width: 12,
                              iconColor: Colors.black,
                              minusBtn:
                                  Icon(Icons.remove_circle_outline_outlined),
                              plusBtn: Icon(Icons.add_circle_outline_outlined),
                              orientation: ButtonOrientation.horizontal,
                              isBordered: false,
                            ),
                            onQtyChanged: (newQty) {
                              onQtyChanged(newQty);
                            },
                          ),
                        ),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 300,
                          height: 3,
                          decoration: ShapeDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(90),
                            ),
                          ),
                        ),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  'Total',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                const SizedBox(width: 185),
                                Text(
                                  totalPrice == null
                                      ? 'Rs. ${widget.price}.00'
                                      : 'Rs. ${totalPrice}.00',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ]),
                        ),
                      ]),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              ElevatedButton.icon(
                icon: Icon(Icons.shopping_cart),
                label: Text('Add to Cart'),
                style: style,
                onPressed: () {
                  addToCart();                  
                },
              ),
              const SizedBox(width: 50),
              ElevatedButton.icon(
                icon: Icon(Icons.shopping_bag),
                label: Text('Buy Now'),
                style: style,
                onPressed: () {
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
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              height: 275,
                              child: GestureDetector(
                                child: ListView(
                                    scrollDirection: Axis.vertical,
                                    children:
                                        List.generate(delivery.length, (index) {
                                      return Card(
                                        elevation: 5,
                                        color: Colors.amber,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
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
                                                    delivery[index]['image'],
                                                    width: 80,
                                                    height: 80,
                                                  ),
                                                  const SizedBox(width: 40),
                                                  Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          delivery[index]
                                                              ['name'],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        Text(
                                                          delivery[index]
                                                              ['price'],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .white),
                                                        )
                                                      ]),
                                                  const SizedBox(width: 8),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              isFav = !isFav;
                                                            });
                                                          },
                                                          icon: Icon(
                                                            isFav
                                                              ? Icons.favorite_border
                                                              : Icons.favorite,
                                                            color: Colors.red,
                                                          ))
                                                    ],
                                                  )
                                                ]),
                                          ),
                                        ]),
                                      );
                                    })),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Cart()),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ])
          ],
        ),
      ),
    );
  }
}
