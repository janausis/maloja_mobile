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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.dns), // Your settings icon
            onPressed: () {
              // Navigate to SettingsPage when icon is pressed
              NavigationUtil.pushPage(
                context,
                SettingsPage(), // The page you want to navigate to
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Main Page Content'),
      ),
    );
  }
}
