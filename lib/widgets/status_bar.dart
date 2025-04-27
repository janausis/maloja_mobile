import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatusBar extends StatelessWidget {
  final Widget child;


  const StatusBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Apply the status bar style when this widget is built
    final theme = Theme.of(context);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark, // Adjust based on light/dark theme
      ),
    );

    return child;
  }
}