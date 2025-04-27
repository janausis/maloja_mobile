import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'dart:math' as math;
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  final Widget body;
  const BottomNav({super.key, required this.body});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 5))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: widget.body,
      bottomNavigationBar: BottomAppBar(
        height: 70,
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        // Controls the space between the floating button and the bottom bar
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            spacing: 15,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                enableFeedback: true,
                iconSize: 30,
                icon: Icon(Icons.person, size: 30), // Replace with your own icon
                onPressed: () {
                  // Handle home press
                },
              ),
              IconButton(
                iconSize: 30,
                icon: Icon(Icons.audiotrack, size: 30),
                onPressed: () {
                  // Handle search press
                },
              ),
              Expanded(child: SizedBox()), // Empty space for the floating button (centered)
              IconButton(
                iconSize: 30,
                icon: Icon(Icons.album, size: 30),
                onPressed: () {
                  // Handle notifications press
                },
              ),
              IconButton(
                iconSize: 30,
                icon: Icon(Icons.library_music, size: 30),
                onPressed: () {
                  // Handle account press
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedBuilder(
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
            color: theme.colorScheme.secondaryContainer.withAlpha(100),
            // Background color of the circle
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.onSurface.withAlpha(0),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // This makes the FAB centered
    );
  }
}
