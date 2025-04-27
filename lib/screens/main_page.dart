import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:maloja_mobile/widgets/status_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: Duration(seconds: 5))..repeat();

  @override
  void dispose() {
    _controller.dispose(); // Clean up the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StatusBar(
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 10,
                  children: [
                    Text(
                      'maloja',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.settings), // Your settings icon
                      onPressed: () {
                      // Handle settings icon tap
                      },
                    ),
                  ],
                )
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10), // Adjust the bottom padding
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (_, child) {
                      return Transform.rotate(
                        angle: _controller.value * 2 * math.pi,
                        child: child,
                      );
                    },
                    child: Container(
                      width: 60, // Adjust the size of the circle
                      height: 60, // Adjust the size of the circle
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black, // Background color of the circle
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(100),
                            blurRadius: 6,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Transform.scale(
                          scale: 1.1, // Increase this value to make the image larger
                          child: Image.asset(
                            'assets/favicon_large.png',
                            fit: BoxFit.cover, // Scale the image to cover the box
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        )
      )
    );
  }

}