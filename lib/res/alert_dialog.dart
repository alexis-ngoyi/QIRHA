import 'package:flutter/material.dart';
import 'package:qirha/res/colors.dart';

class CustomAlertDialog {
  static void showCustomAlert({
    required BuildContext context,
    required String title,
    required String message,
    IconData icon = Icons.info,
    Color iconColor = Colors.blue,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: Row(
            children: [
              Icon(icon, color: iconColor),
              SizedBox(width: 8),
              Text(title, style: TextStyle(fontSize: 16)),
            ],
          ),
          content: Text(message, style: TextStyle(fontSize: 12)),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
