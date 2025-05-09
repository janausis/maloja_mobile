import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class NavigationUtil {
  // Push a page with an appropriate route based on the platform
  static void pushPage(BuildContext context, Widget page) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      // Use MaterialPageRoute with a custom page transition on Android
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );
    } else {
      // Use CupertinoPageRoute for iOS
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => page,
        ),
      );
    }
  }

  static void pushReplacementPage(BuildContext context, Widget page) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // Use CupertinoPageRoute for iOS
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            maintainState: true,
            builder: (context) => page,
          ),
              (route) => false,
        );
      });
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      // Use MaterialPageRoute with a custom page transition on Android
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            maintainState: true,
            builder: (context) => page,
          ),
              (route) => false,
        );
      });
    }
  }

  static void pushPageBottomNav(BuildContext context, Widget page) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      // Use MaterialPageRoute with a custom page transition on Android
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );
    } else {
      // Use CupertinoPageRoute for iOS
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => page,
        ),
      );
    }
  }

  // Pop the current page
  static void popPage(BuildContext context) {
    Navigator.pop(context);
  }
}

