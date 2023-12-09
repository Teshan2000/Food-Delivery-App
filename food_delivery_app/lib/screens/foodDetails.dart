import 'package:flutter/material.dart';

class FoodDetails extends StatelessWidget {
  const FoodDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: const Icon(Icons.arrow_back),
        title: const Center(
          child: Text('Chicken Burger')
        ),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.favorite_border_outlined),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: Column(
          children: <Widget>[
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  width: 250,
                  image: AssetImage(
                    'Assets/burger.jpg',
                  )
                )
              ],
            ),
            const Row(
              children: <Widget>[
                Text(
                  'Ingredients',
                  style: TextStyle(
                    fontSize: 18
                  ),
                )
              ]
            ),
            const Row(
              children: <Widget>[
                Card(
                  elevation: 5,
                  color: Colors.amber,
                )
              ]
            ),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () {}, 
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18
                    ),
                  )
                ),
                TextButton(
                  onPressed: () {}, 
                  child: const Text(
                    'Buy Now',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18
                    ),
                  )
                ),
              ]
            )
          ],
        ),
      ),
    );
  }
}
