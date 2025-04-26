// lib/widgets/loading_button.dart

import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const LoadingButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: isLoading
          ? SizedBox(
        height: 24.0,
        width: 24.0,
        child: const CircularProgressIndicator(
          color: Colors.white,
        ),
      )
          : const Icon(Icons.arrow_forward),
      label: isLoading ? const SizedBox() : const Text('Next'),
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
    );
  }
}
