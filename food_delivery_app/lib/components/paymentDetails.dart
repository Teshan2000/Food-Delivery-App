import 'package:flutter/material.dart';

class PaymentDetails extends StatefulWidget {
  final String cardHolder;
  final String cardNumber;
  const PaymentDetails({super.key, required this.cardHolder, required this.cardNumber});

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.cardHolder}",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "${widget.cardNumber}",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
