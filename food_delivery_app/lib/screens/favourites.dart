import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/foodCard.dart';

class Favourites extends StatelessWidget {
  const Favourites({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          'Favourites'
        ),
        actions: const [
          Icon(
            Icons.favorite
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: List.generate(5, (index){
                    return const FoodCard();
                  })
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
