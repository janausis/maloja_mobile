import 'package:flutter/material.dart';

class TrackPage extends StatefulWidget {
  const TrackPage({super.key});

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Page'),
      ),
      body: Center(
        child: Text('Welcome to the Track Page!'),
      ),
    );
  }
}