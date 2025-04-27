import 'package:flutter/material.dart';

class ArtistPage extends StatefulWidget {
  const ArtistPage({super.key});

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artist Page'),
      ),
      body: Center(
        child: Text('Welcome to the Artist Page!'),
      ),
    );
  }
}