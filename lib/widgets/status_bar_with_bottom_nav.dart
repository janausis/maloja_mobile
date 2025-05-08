import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


import 'dart:math' as math;

import 'package:maloja_mobile/screens/chart_page.dart';
import 'package:material_symbols_icons/symbols.dart';



import '../screens/main_page.dart';

class BottomNav extends StatefulWidget {
  final Box box;

  const BottomNav({super.key, required this.box});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 10))..repeat();
    _pages = [
      ArtistPage(box: widget.box),
      TrackPage(box: widget.box),
      AlbumPage(box: widget.box),
      MainPage(box: widget.box),
    ];
  }

  // Track the selected index for the BottomNavigationBar
  int _selectedIndex = 0;


  // Function to update the selected tab and navigate to the corresponding page
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
      backgroundColor: theme.colorScheme.surface,
      body: _selectedIndex == 0 ? ScrobblePage(box: widget.box) : _pages[_selectedIndex - 1],
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
                icon: Icon(Symbols.artist, size: 30, fill: 1,), // Replace with your own icon
                onPressed: () {
                  _onItemTapped(1);
                },
              ),
              IconButton(
                iconSize: 30,
                icon: Icon(Icons.audiotrack, size: 30),
                onPressed: () {
                  _onItemTapped(2);
                },
              ),
              Expanded(child: SizedBox()), // Empty space for the floating button (centered)
              IconButton(
                iconSize: 30,
                icon: Icon(Icons.album, size: 30),
                onPressed: () {
                  _onItemTapped(3);
                },
              ),
              IconButton(
                iconSize: 30,
                icon: Icon(Icons.library_music, size: 30),
                onPressed: () {
                  _onItemTapped(4);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () => _onItemTapped(0),
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
                scale: 1.12, // Increase this value to make the image larger
                child: Image.asset(
                  'assets/favicon_large.png',
                  fit: BoxFit.cover, // Scale the image to cover the box
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // This makes the FAB centered
    );
  }
}
