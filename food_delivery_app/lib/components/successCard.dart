import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/button.dart';
import 'package:food_delivery_app/screens/deliveryPage.dart';
import 'package:food_delivery_app/screens/splash.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart';

class SuccessCard extends StatefulWidget {
  final String deliveryId;
  final String orderId;
  const SuccessCard({super.key, required this.deliveryId, required this.orderId});

  @override
  State<SuccessCard> createState() => _SuccessCardState();
}

class _SuccessCardState extends State<SuccessCard> {
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
                  "Your order #${(widget.orderId).substring(0, 5) + ''} is successfully placed!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 35),
                Button(
                  title: 'Track the Order',
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context) => DeliveryPage(
                          // agentLocation: LatLng(6.9271, 79.8612),
                          userLocation: LatLng(6.839310338386326, 79.97242417007477),
                          agentId: widget.deliveryId, orderId: widget.orderId,
                    )));
                  },
                  disable: false,
                  width: double.infinity,
                ),
                Button(
                  title: 'Back to Home',
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const SplashScreen()));
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
