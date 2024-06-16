import 'package:flutter/material.dart';

// Fehlermeldung für User

void displayMessageToUser(String message, BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
    title: Text(message),
      ),
  );
}
