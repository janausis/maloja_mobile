
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:maloja_mobile/screens/settings_page.dart';


import '../utils/page_router.dart';

class MainPage extends StatefulWidget {
  final Box box;
  const MainPage({super.key, required this.box});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {

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
                SettingsPage(box: widget.box), // The page you want to navigate to
              );
            },
          ),
        ],
      ),
      body: SafeArea(child: SizedBox())
    );
  }
}
