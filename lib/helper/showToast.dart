import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';

void showToast(BuildContext context, String message, {IconData? icon}) {
  DelightToastBar(
    snackbarDuration: const Duration(seconds: 5),
    autoDismiss: true,
    builder: (context) => ToastCard(
      leading: Icon(icon ?? Icons.error, size: 28),
      title: Text(
        message,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    ),
  ).show(context);
}
