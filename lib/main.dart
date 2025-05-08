// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:maloja_mobile/screens/main_page.dart';
import 'package:maloja_mobile/widgets/status_bar_with_bottom_nav.dart';
import 'screens/setup_page.dart'; // Import the setup page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final settingsBox = await Hive.openBox('settings');

  List<String> urls = (settingsBox.get('serverUrls') as List?)?.cast<String>() ?? [];



  runApp(MyApp(urls: urls, box: settingsBox,));
}

class MyApp extends StatelessWidget {
  final List<String> urls;
  final Box box;

  const MyApp({super.key, required this.urls, required this.box});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Maloja',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent, brightness: Brightness.light),
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            // Set the predictive back transitions for Android.
            TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          },
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent, brightness: Brightness.dark),
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            // Set the predictive back transitions for Android.
            TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          },
        ),
      ),
      home: urls.isEmpty ? SetupPage(box: box) : BottomNav(box: box),

      debugShowCheckedModeBanner: false,
    );
  }
}


