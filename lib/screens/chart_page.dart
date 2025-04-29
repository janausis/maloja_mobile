import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:maloja_mobile/services/artist_service.dart';
import 'package:maloja_mobile/services/image_service.dart';
import 'package:maloja_mobile/widgets/app_snackbar.dart';
import 'package:maloja_mobile/widgets/chart_widgets.dart';

import '../services/album_service.dart';
import '../services/scrobble_service.dart';
import '../services/track_service.dart';

class ChartPage extends StatefulWidget {
  final String chartType; // 'artist', 'album', 'track'

  const ChartPage({super.key, required this.chartType});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class ArtistPage extends ChartPage {
  const ArtistPage({super.key, super.chartType = "artist"});
}

class AlbumPage extends ChartPage {
  const AlbumPage({super.key, super.chartType = "album"});
}

class TrackPage extends ChartPage {
  const TrackPage({super.key, super.chartType = "track"});
}

class ScrobblePage extends ChartPage {
  const ScrobblePage({super.key, super.chartType = "scrobbles"});
}

class _ChartPageState extends State<ChartPage> {
  late List<ChartDisplayData> charts = [];
  late Box box;
  bool loaded = false;

  final List<String> _pages = ["today", "week", "month", "year", "total"];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCharts();
  }

  Future<void> _loadCharts() async {
    try {
      box = await Hive.openBox('settings');
      List<ChartDisplayData> data = [];
      var url = box.get("selectedUrl", defaultValue: "");

      switch (widget.chartType) {
        case 'artist':
          var artists = await ArtistService().fetchArtists(
            _pages[_selectedIndex],
            url,
          );
          data =
              artists
                  .map(
                    (a) => ChartDisplayData(
                      id: a.id,
                      name: a.name,
                      rank: a.rank,
                      image: ImageService.buildArtistImage(a.id, url),
                      scrobbles: a.scrobbles,
                      artists: [a.name]
                    ),
                  )
                  .toList();
          break;
        case 'album':
          var albums = await AlbumService().fetchAlbums(
            _pages[_selectedIndex],
            url,
          );
          data =
              albums
                  .map(
                    (a) => ChartDisplayData(
                      id: a.id,
                      name: a.albumTitle,
                      rank: a.rank,
                      image: ImageService.buildAlbumImage(a.id, url),
                      scrobbles: a.scrobbles,
                      artists: a.artists
                    ),
                  )
                  .toList();
          break;
        case 'track':
          var tracks = await TrackService().fetchTracks(
            _pages[_selectedIndex],
            url,
          );
          data =
              tracks
                  .map(
                    (t) => ChartDisplayData(
                      id: t.id,
                      name: t.title,
                      rank: t.rank,
                      image: ImageService.buildTrackImage(t.id, url),
                      scrobbles: t.scrobbles,
                      artists: t.artists
                    ),
                  )
                  .toList();
          break;
        case 'scrobbles':
          var scrobbles = await ScrobbleService().fetchScrobbles(
            _pages[_selectedIndex],
            url,
          );
          data =
              scrobbles
                  .map(
                    (t) => ChartDisplayData(
                      id: t.id,
                      name: t.title,
                      rank: t.rank,
                      image: ImageService.buildTrackImage(t.id, url),
                      scrobbles: t.rank,
                      artists: t.artists
                    ),
                  )
                  .toList();
          break;
        default:
          throw Exception("Unknown chart type: ${widget.chartType}");
      }

      setState(() {
        charts = data;
        loaded = true;
      });
    } catch (e) {
      if (mounted) {
        AppSnackBar(message: e.toString()).build(context);
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      loaded = false;
    });
    _loadCharts();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar:
          widget.chartType != "scrobbles"
              ? AppBar(title: Text('Top ${widget.chartType.capitalize()}s'))
              : AppBar(title: Text('Scrobbles')),
      // you can add a small extension for capitalize
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadCharts, // This is where the refresh action happens
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildTimeframeSelector(theme)),
              if (!loaded)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: charts.length,
                    (sliverContext, index) {
                      bool isLastItem = index == charts.length - 1;
                      if (index == 0) {
                        return BigChartItem(
                          chartData: charts[index],
                          theme: theme,
                          showRanking: widget.chartType != "scrobbles",
                          showScrobbles: widget.chartType != "scrobbles",
                          showArtist: widget.chartType != "artist",);
                      } else {
                        return Column(
                          children: [
                            SmallChartData(
                              chartData: charts[index],
                              theme: theme,
                              showRanking: widget.chartType != "scrobbles",
                              showScrobbles: widget.chartType != "scrobbles",
                              showArtist: widget.chartType != "artist",
                            ),
                            if (!isLastItem)
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                height: 0.5,
                                color: CupertinoColors.systemGrey4,
                              ),
                            if (isLastItem) SizedBox(height: 50),
                          ],
                        );
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeframeSelector(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: Center(
        child: Container(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 10,
                ),
                child: ElevatedButton(
                  onPressed: () => _onItemTapped(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _selectedIndex == index
                            ? theme.colorScheme.primary
                            : theme.colorScheme.secondaryContainer,
                  ),
                  child: Text(
                    _pages[index].toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color:
                          _selectedIndex == index
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
