import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:maloja_mobile/services/artist_service.dart';
import 'package:maloja_mobile/services/image_service.dart';

class ArtistPage extends StatefulWidget {
  const ArtistPage({super.key});

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  late List<Artist> artists = [];

  @override
  void initState() {
    super.initState();
    _loadArtists();
  }

  Future<void> _loadArtists() async {
    // Get the current list or an empty list if null

    List<Artist> arts = await ArtistService().fetchArtists();
    setState(() {
      artists = arts;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Top Artists')),
      body: SafeArea(
        child:
            artists.isEmpty
                ? Center(
                  child: CircularProgressIndicator(),
                ) // Show loading indicator while fetching
                : ListView.builder(
                  itemCount: artists.length,
                  itemBuilder: (innerContext, index) {
                    bool isLastItem = index == artists.length;

                    if (index == 0) {
                      return BigArtistItem(artist: artists[index]);
                    } else if (index == 1 && artists.length == 2) {
                      return BigArtistItem(artist: artists[index]);
                    } else if (index == 1) {
                      return MediumArtistItem(
                        artistLeft: artists[index],
                        artistRight: artists[index + 1],
                      );
                    } else if (index == 2) {
                      return SizedBox();
                    } else {
                      return Column(
                        children: [
                          SmallArtistItem(artist: artists[index], theme: theme),
                          if (!isLastItem)
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              height: 0.5,
                              color:
                                  CupertinoColors
                                      .systemGrey4, // Nice soft grey line
                            ),
                        ],
                      );
                    }
                  },
                ),
      ),
    );
  }
}

class BigArtistItem extends StatelessWidget {
  final Artist artist;

  const BigArtistItem({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(150,0,0,0),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  children: [
                    ImageService.buildArtistImage(artist.id),

                    // Farbverlauf (Gradient Overlay)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withAlpha(200),
                                // Schwarz mit 50% Alpha
                                Colors.black.withAlpha(0),
                                // Schwarz mit 0% Alpha
                              ],
                              begin: Alignment.bottomCenter,
                              // Startpunkt: Unten Mitte
                              end:
                                  Alignment
                                      .center, // Endpunkt: Mitte des Containers
                            ),
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: null,
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: Text(
                          artist.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MediumArtistItem extends StatelessWidget {
  final Artist artistLeft;
  final Artist artistRight;

  const MediumArtistItem({
    super.key,
    required this.artistLeft,
    required this.artistRight,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(150,0,0,0),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  children: [
                    ImageService.buildArtistImage(artistLeft.id),

                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withAlpha(200),
                                Colors.black.withAlpha(0),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: null,
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: Text(
                          artistLeft.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(150,0,0,0),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  children: [
                    ImageService.buildArtistImage(artistRight.id),

                    // Farbverlauf (Gradient Overlay)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withAlpha(200),
                                Colors.black.withAlpha(0),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: null,
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: Text(
                          artistRight.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SmallArtistItem extends StatelessWidget {
  final Artist artist;
  final ThemeData theme;

  const SmallArtistItem({super.key, required this.artist, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: CupertinoButton(
                sizeStyle: CupertinoButtonSize.large,
                padding: EdgeInsets.zero,
                borderRadius: BorderRadius.circular(10),
                onPressed: () => {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 20,
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(100),
                              spreadRadius: 0.1,
                              blurRadius: 10,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: ImageService.buildArtistImage(artist.id),
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: Text(
                          "  #${artist.rank}",
                          style: TextStyle(
                            color: Color.fromARGB(255, 150, 150, 150),
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          artist.name,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
