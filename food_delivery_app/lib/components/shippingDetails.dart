import 'package:flutter/material.dart';

class ShippingDetails extends StatefulWidget {
  final String address1;
  final String address2;
  const ShippingDetails({super.key, required this.address1, required this.address2});

  @override
  State<ShippingDetails> createState() => _ShippingDetailsState();
}

class _ShippingDetailsState extends State<ShippingDetails> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.address1}",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "${widget.address2}",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
