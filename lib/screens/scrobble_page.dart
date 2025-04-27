import 'package:flutter/material.dart';

class ScrobblePage extends StatefulWidget {
  const ScrobblePage({super.key});

  @override
  State<ScrobblePage> createState() => _ScrobblePageState();
}

class _ScrobblePageState extends State<ScrobblePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scrobble Page'),
      ),
      body: Center(
        child: Text('Welcome to the Scrobble Page!'),
      ),
    );
  }
}