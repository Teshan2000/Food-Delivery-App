import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

class AlertService {
  void showToast(
      {required BuildContext context,
      required String text,
      IconData icon = Icons.info}) {
    try {
      DelightToastBar(
        autoDismiss: true,
        position: DelightSnackbarPosition.top,
        builder: (context) {
          return ToastCard(
            leading: Icon(icon, size: 28),
            title: Text(
              text,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            )
          );
        },
      ).show(context);
    } catch (e) {
      print('Error showing toast $e');
    }
  }
}
