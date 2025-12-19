import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/button.dart';
import 'package:food_delivery_app/main.dart';
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

  Future<List<Map<String, dynamic>>> fetchDeliveryAgents() async {
    List<Map<String, dynamic>> agents = [];

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('agents').get();
      agents = snapshot.docs.map((doc) {
        return {
          "agent_id": doc.id,
          "name": doc['name'],
          "image": doc['image'],
          "price": doc['price'],
          "rate": doc['rate'],
        };
      }).toList();
    } catch (e) {
      print("Error fetching agents: $e");
    }
    return agents;
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
        alertService.showToast(
            context: context,
            text: 'Food added to Favorites!',
            icon: Icons.info);
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
      alertService.showToast(
          context: context, text: 'Food added to Cart!', icon: Icons.info);
    } catch (e) {
      alertService.showToast(context: context, text: 'Adding to cart Failed!', icon: Icons.warning);
    }
  }

  void onQtyChanged(int newQuantity) {
    setState(() {
      quantity = newQuantity;
      totalPrice = widget.price * quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = ScreenSize.width(context);
    double height = ScreenSize.height(context);
    bool isLandscape = ScreenSize.orientation(context);

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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 10),
          child: SizedBox(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(width: 250, image: NetworkImage(widget.image))
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: isLandscape ? MainAxisAlignment.center : MainAxisAlignment.start,
                  children: <Widget>[
                  Text(
                    'Ingredients',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
              SizedBox(height: height * 0.01,),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      height: 140,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: constraints.maxWidth),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(ingredients.length, (index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 3),
                                  child: Container(
                                    width: 75,
                                    height: 120,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFFFC107),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
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
                                              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                  ),
                                );
                              })),
                        ),
                      ),
                    );}
                  ),
                ),
              SizedBox(height: height * 0.01,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  height: 220,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFFC107),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 15, bottom: 10, left: 15, right: 15),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.name,
                                style:
                                    TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Rs. ${widget.price}.00",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          height: 1,
                          decoration: ShapeDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(90),
                            ),
                          ),
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 140,
                              height: 30,
                              decoration: ShapeDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: InputQty.int(
                                qtyFormProps:
                                    const QtyFormProps(cursorColor: Colors.amber),
                                decoration: const QtyDecorationProps(
                                  contentPadding: EdgeInsets.symmetric(vertical: 3),
                                  width: 12,
                                  iconColor: Colors.black,
                                  minusBtn: Icon(Icons.remove_circle_outline_outlined),
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          height: 1,
                          decoration: ShapeDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(90),
                              ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 15, left: 15, right: 15),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                'Total',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                totalPrice == null
                                    ? 'Rs. ${widget.price}.00'
                                    : 'Rs. ${totalPrice}.00',
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: isLandscape ? height * 0.03 : height * 0.02,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Button(
                        title: 'Add to Cart',
                        onPressed: () {
                          addToCart();
                        },
                        disable: false,
                        width: isLandscape ? width * 0.46 : width * 0.44,
                        height: isLandscape ? width * 0.05 : height * 0.05,
                      ),
                      Button(
                        title: 'Buy Now',
                        onPressed: () {
                          showModalBottomSheet(
                            scrollControlDisabledMaxHeightRatio: isLandscape ? height * 0.0024 : height * 0.001,
                            backgroundColor: Colors.amber,
                            context: context,
                            builder: (_) => SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: height * 0.02,),
                                  Container(
                                    decoration: ShapeDecoration(
                                      color: Colors.amber,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ))),
                                    child: Text(
                                      'Select Delivery Method',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.02,),
                                    Container(
                                      color: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 10),
                                      height: 375,
                                      child: GestureDetector(
                                        child: FutureBuilder(
                                          future: fetchDeliveryAgents(),
                                          builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Center(child: CircularProgressIndicator());
                                            }
                                            if (snapshot.hasError) {
                                              return Center(
                                                child: Text('Error: ${snapshot.error}'));
                                            }
                                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                              return Center(
                                                child: Text('No delivery agents available'));
                                            }
                                            List<Map<String, dynamic>> agents = snapshot.data!;
                                            return ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              itemCount: agents.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                                    child: GestureDetector(
                                                      child: Card(
                                                        color: Colors.amber,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(
                                                            horizontal: 5, vertical: 15),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: <Widget>[
                                                                ClipRRect(
                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                  child: Image.network(
                                                                    agents[index]['image'] ?? 'Assets/Foods/Chicken Burger.png',
                                                                    width: 80,
                                                                    height: 80,
                                                                  ),
                                                                ),
                                                              SizedBox(height: width * 0.01,),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  Text(
                                                                    agents[index]['name'] ?? 'Unknown',
                                                                    style: const TextStyle(
                                                                      fontSize: 18,
                                                                      color: Colors.white, fontWeight: FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                    "Rs. ${agents[index]['price']}.00",
                                                                    style: const TextStyle(
                                                                      fontSize: 18,
                                                                      color: Colors.white, fontWeight: FontWeight.bold),
                                                                  )
                                                                ]),
                                                              SizedBox(height: width * 0.01,),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons.star,
                                                                        color: Colors.white,
                                                                      ),
                                                                      SizedBox(height: width * 0.02,),
                                                                      Text(
                                                                        agents[index]['rate'] ?? 'Unknown',
                                                                        style: const TextStyle(
                                                                          fontSize: 14,
                                                                          color: Colors.white, fontWeight: FontWeight.bold),
                                                                      )
                                                                    ]
                                                                  )
                                                                ],
                                                              )
                                                            ]
                                                          ),
                                                        ),                                                    
                                                      ),
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => Cart(delivery: agents[index]['price'], deliveryId: agents[index]['agent_id'],)),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                });
                                            },                                  
                                          ),
                                        ),
                                      ),
                                    ],
                              ),
                            ),
                          );
                        },
                        disable: false,
                        width: isLandscape ? width * 0.46 : width * 0.44,
                        height: isLandscape ? width * 0.05 : height * 0.05,
                      ),                    
                    ]),
              ),
              SizedBox(
                  height: height * 0.03,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
