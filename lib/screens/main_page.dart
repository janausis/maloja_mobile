import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maloja_mobile/screens/settings_page.dart';
import 'package:maloja_mobile/widgets/status_bar.dart';
import 'package:maloja_mobile/widgets/status_bar_with_bottom_nav.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../utils/page_router.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(seconds: 5),
  )..repeat();

  @override
  void dispose() {
    _controller
        .dispose(); // Clean up the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StatusBar(
      child: BottomNav(
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 10,
                  children: [
                    IconButton(
                      icon: Icon(Icons.dns), // Your settings icon
                      onPressed: () {
                        NavigationUtil.pushPage(
                          context,
                          SettingsPage(), // The page you want to navigate to
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
