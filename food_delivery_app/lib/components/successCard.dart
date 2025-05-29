import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/button.dart';
import 'package:food_delivery_app/screens/deliveryPage.dart';
import 'package:food_delivery_app/screens/home.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart';

class SuccessCard extends StatelessWidget {
  const SuccessCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: 450,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            padding: EdgeInsets.fromLTRB(25, 30, 25, 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Lottie.asset('Assets/5lKST8Beoq.json',
                    fit: BoxFit.contain, width: 120),
                Text(
                  "Order Successful!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 23, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Your order #45gt5f4 is successfully placed!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 35),
                Button(
                  title: 'Track the Order',
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const DeliveryPage(agentLocation: LatLng(6.9271, 79.8612),
  userLocation: LatLng(6.9279, 79.8651),)));
                  },
                  disable: false,
                  width: double.infinity,
                ),
                Button(
                  title: 'Back to Home',
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Home()));
                  },
                  disable: false,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
