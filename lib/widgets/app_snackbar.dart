import 'package:flutter/material.dart';

class AppSnackBar extends StatelessWidget {
  final String message;

  const AppSnackBar({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    // Trigger the snackbar when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
      );
    });

    return Container(); // Since this is just to show a snack bar, we don't need to render anything.
  }
}
