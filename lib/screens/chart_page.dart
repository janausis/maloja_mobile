import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:maloja_mobile/services/artist_service.dart';
import 'package:maloja_mobile/services/image_service.dart';
import 'package:maloja_mobile/widgets/app_snackbar.dart';
import 'package:maloja_mobile/widgets/chart_widgets.dart';
import 'package:maloja_mobile/widgets/main_app_bar.dart';

import '../services/album_service.dart';
import '../services/scrobble_service.dart';
import '../services/track_service.dart';

class ChartPage extends StatefulWidget {
  final String chartType; // 'artist', 'album', 'track'
  final Box box;

  const ChartPage({super.key, required this.chartType, required this.box});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class ArtistPage extends ChartPage {
  const ArtistPage({super.key, super.chartType = "artist", required super.box});
}

class AlbumPage extends ChartPage {
  const AlbumPage({super.key, super.chartType = "album", required super.box});
}

class TrackPage extends ChartPage {
  const TrackPage({super.key, super.chartType = "track", required super.box});
}

class ScrobblePage extends ChartPage {
  const ScrobblePage({
    super.key,
    super.chartType = "scrobbles",
    required super.box,
  });
}

class _ChartPageState extends State<ChartPage> {
  late List<ChartDisplayData> charts = [];
  late String url;

  bool loaded = false;
  bool isLoadingMore = false; // Flag to prevent multiple loads
  int currentPage = 1; // For pagination in scrobbles
  final List<String> _pages = ["today", "week", "month", "year", "total"];
  int _selectedIndex = 2;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.chartType == "scrobbles") {
      _selectedIndex = 3;
    }

    url = widget.box.get("selectedUrl", defaultValue: "");
    _loadCharts();

    if (widget.chartType == "scrobbles") {
      _scrollController.addListener(_scrollListener);
    }
  }

  Future<void> _loadCharts({bool loadMore = false}) async {
    if (isLoadingMore) return; // Prevent multiple loads at the same time
    setState(() {
      if (!loadMore) {
        loaded = false;
        currentPage = 0; // Reset to page 1 when fetching new data
      }
      isLoadingMore = true;
    });

    try {
      List<ChartDisplayData> data = [];
      print(currentPage);
      switch (widget.chartType) {
        case 'artist':
          var artists = await ArtistService().fetchArtists(
            _pages[_selectedIndex],
            url,
          );
          data = artists.map((a) => ChartDisplayData(
            id: a.id,
            name: a.name,
            type: ChartType.ARTIST,
            rank: a.rank,
            scrobbles: a.scrobbles,
            artists: [a.name],
          )).toList();
          break;
        case 'album':
          var albums = await AlbumService().fetchAlbums(
            _pages[_selectedIndex],
            url,
          );
          data = albums.map((a) => ChartDisplayData(
            id: a.id,
            name: a.albumTitle,
            type: ChartType.ALBUM,
            rank: a.rank,
            scrobbles: a.scrobbles,
            artists: a.artists,
          )).toList();
          break;
        case 'track':
          var tracks = await TrackService().fetchTracks(
            _pages[_selectedIndex],
            url,
          );
          data = tracks.map((t) => ChartDisplayData(
            id: t.id,
            name: t.title,
            type: ChartType.TRACK,
            rank: t.rank,
            scrobbles: t.scrobbles,
            artists: t.artists,
          )).toList();
          break;
        case 'scrobbles':
          var scrobbles = await ScrobbleService().fetchScrobbles(
            _pages[_selectedIndex],
            url,
            page: currentPage,
          );
          data = scrobbles.map((t) => ChartDisplayData(
            id: t.id,
            name: t.title,
            type: ChartType.TRACK,
            rank: t.rank,
            scrobbles: t.rank,
            artists: t.artists,
            timeCreated: t.timeCreated,
          )).toList();
          break;
        default:
          throw Exception("Unknown chart type: ${widget.chartType}");
      }

      setState(() {
        if (!loadMore) {
          print("reload");
          charts = data; // If it's a fresh load, reset the list
          currentPage = 1;
        } else {
          print("append");
          charts.addAll(data); // Append new data if it's a "load more"
          currentPage++; // Move to the next page for next load
        }
        loaded = true;
      });
    } catch (e) {
      if (mounted) {
        AppSnackBar(message: e.toString()).build(context);
      }
    } finally {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      loaded = false;
    });
    _loadCharts();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      // Trigger loading more data if user scrolls to the bottom
      if (!isLoadingMore) {
        _loadCharts(loadMore: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: widget.chartType != "scrobbles"
          ? MainAppBar(input: 'Top ${widget.chartType.capitalize()}s', box: widget.box,)
          : MainAppBar(input: 'Recently Played', box: widget.box,),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _loadCharts(); // Trigger a full refresh
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              if (widget.chartType != "scrobbles")
                SliverToBoxAdapter(
                  child: TimeframeSelector(
                    pages: _pages,
                    selectedIndex: _selectedIndex,
                    onTap: _onItemTapped,
                  ),
                ),
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
                      return buildChartItem(
                        data: charts[index],
                        isFirst: index == 0,
                        url: url,
                        isLast: index == charts.length - 1,
                        theme: theme,
                        showRanking: widget.chartType != "scrobbles",
                        showTimeCreated: widget.chartType == "scrobbles",
                        showScrobbles: widget.chartType != "scrobbles",
                        showArtist: widget.chartType != "artist",
                      );
                    },
                  ),
                ),
              if (isLoadingMore)
                SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChartItem({
    required ChartDisplayData data,
    required bool isFirst,
    required bool isLast,
    required ThemeData theme,
    required bool showRanking,
    required bool showTimeCreated,
    required bool showScrobbles,
    required bool showArtist,
    required String url,
  }) {
    final content =
        isFirst
            ? BigChartItem(
              chartData: data,
              theme: theme,
              url: url,
              showRanking: showRanking,
              showScrobbles: showScrobbles,
              showArtist: showArtist,
              showTimeCreated: showTimeCreated,
            )
            : SmallChartData(
              chartData: data,
              theme: theme,
              url: url,
              showRanking: showRanking,
              showScrobbles: showScrobbles,
              showArtist: showArtist,
              showTimeCreated: showTimeCreated,
            );

    return Column(
      key: ValueKey(data.id),
      children: [
        content,
        if (!isLast)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 0.5, thickness: 0.5),
          ),
        if (isLast) const SizedBox(height: 50),
      ],
    );
  }
}

class TimeframeSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final List<String> pages;

  TimeframeSelector({required this.selectedIndex, required this.onTap, required this.pages});



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RepaintBoundary(
      child: SizedBox(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: pages.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
              child: ElevatedButton(
                onPressed: () => onTap(index),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedIndex == index
                          ? theme.colorScheme.primary
                          : theme.colorScheme.secondaryContainer,
                ),
                child: Text(
                  pages[index].toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color:
                        selectedIndex == index
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
            );
          },
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
