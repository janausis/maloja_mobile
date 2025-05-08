import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../screens/settings_page.dart';
import '../utils/page_router.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String input;
  final Box box;

  const MainAppBar({super.key, required this.input, required this.box});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(input),
      actions: [
        IconButton(
          icon: Icon(Icons.dns), // Your settings icon
          onPressed: () {
            // Navigate to SettingsPage when icon is pressed
            NavigationUtil.pushPage(
              context,
              SettingsPage(
                box: box,
              ), // The page you want to navigate to
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
