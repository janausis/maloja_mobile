import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maloja_mobile/services/image_service.dart';

import '../services/pulse_service.dart';
import 'package:intl/intl.dart';

enum ChartType { ARTIST, TRACK, ALBUM }

class ChartDisplayData {
  int id;
  String name;
  int rank;
  int scrobbles;
  ChartType type;
  List<String> artists;
  int timeCreated;

  ChartDisplayData({
    required this.id,
    required this.name,
    required this.rank,
    required this.scrobbles,
    required this.type,
    required this.artists,
    this.timeCreated = 0,
  });

  String getArtist() {
    return artists.join(", ");
  }
}

// --------------------- BigChartItem ---------------------
class BigChartItem extends StatelessWidget {
  final ChartDisplayData chartData;
  final bool showRanking;
  final bool showArtist;
  final bool showScrobbles;
  final bool showTimeCreated;
  final String url;
  final ThemeData theme;

  const BigChartItem({
    super.key,
    required this.chartData,
    this.showRanking = true,
    this.showScrobbles = true,
    this.showArtist = true,
    this.showTimeCreated = false,
    required this.url,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Define a dynamic size based on available width
          final double size = constraints.maxWidth * 0.6; // 60% of parent width
          final double clampedSize = size.clamp(
            150.0,
            300.0,
          ); // clamp to a min/max

          return Center(
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 15, bottom: 30)),
                Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(150, 0, 0, 0),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: clampedSize,
                    height: clampedSize,
                    child: Stack(
                      children: [
                        ImageService.buildImageWithResolution(
                          chartData.id,
                          2000,
                          url,
                          chartData.type,
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withAlpha(250),
                                  Colors.black.withAlpha(0),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.center,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  chartData.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                Wrap(
                                  alignment: WrapAlignment.center,
                                  children: [
                                    if (showArtist)
                                      Text(
                                        showScrobbles
                                            ? "${chartData.getArtist()} • "
                                            : chartData.getArtist(),
                                        style: TextStyle(
                                          color: Colors.white.withAlpha(200),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    if (showScrobbles)
                                      Text(
                                        "${chartData.scrobbles} scrobbles",
                                        style: TextStyle(
                                          color: Colors.white.withAlpha(200),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                  ],
                                ),
                                if (showTimeCreated) const SizedBox(height: 1),
                                if (showTimeCreated)
                                  Text(
                                    "Played at: ${DateFormat('yyyy/MM/dd HH:mm').format(DateTime.fromMillisecondsSinceEpoch(chartData.timeCreated * 1000))}",
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(200),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                if (showTimeCreated) const SizedBox(height: 1),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 30)),
              ],
            ),
          );
        },
      ),
    );
  }
}

// --------------------- SmallChartData ---------------------
class SmallChartData extends StatelessWidget {
  final ChartDisplayData chartData;
  final bool showRanking;
  final bool showArtist;
  final bool showScrobbles;
  final bool showTimeCreated;
  final String url;
  final ThemeData theme;

  const SmallChartData({
    super.key,
    required this.chartData,
    this.showRanking = true,
    this.showScrobbles = true,
    this.showArtist = true,
    this.showTimeCreated = false,
    required this.url,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 1.0,
                horizontal: 5.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CupertinoButton(
                  sizeStyle: CupertinoButtonSize.large,
                  padding: EdgeInsets.zero,
                  borderRadius: BorderRadius.circular(10),
                  onPressed: () {},
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
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: ImageService.buildImage(
                              chartData.id,
                              url,
                              chartData.type,
                            ),
                          ),
                        ),
                        showRanking
                            ? SizedBox(
                              width: 60,
                              child: Text(
                                "  #${chartData.rank}",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 150, 150, 150),
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                            : const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chartData.name,
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              Wrap(
                                children: [
                                  showArtist
                                      ? Text(
                                        showScrobbles
                                            ? "${chartData.getArtist()} • "
                                            : chartData.getArtist(),
                                        style: TextStyle(
                                          color: theme.colorScheme.onSurface
                                              .withAlpha(150),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                      : const SizedBox(),
                                  const SizedBox(width: 0),
                                  showScrobbles
                                      ? Text(
                                        "${chartData.scrobbles} scrobbles",
                                        style: TextStyle(
                                          color: theme.colorScheme.onSurface
                                              .withAlpha(150),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                      : const SizedBox(),
                                ],
                              ),
                              if (showTimeCreated) const SizedBox(height: 1),
                              if (showTimeCreated)
                                Text(
                                  DateFormat('yyyy/MM/dd HH:mm').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      chartData.timeCreated * 1000,
                                    ),
                                  ),
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface.withAlpha(130),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              if (showTimeCreated) const SizedBox(height: 1),
                            ],
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
      ),
    );
  }
}

// --------------------- SmallPulseData ---------------------
class SmallPulseData extends StatelessWidget {
  final Pulse pulse;
  final ThemeData theme;

  const SmallPulseData({super.key, required this.pulse, required this.theme});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 1.0,
                horizontal: 5.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CupertinoButton(
                  sizeStyle: CupertinoButtonSize.large,
                  padding: EdgeInsets.zero,
                  borderRadius: BorderRadius.circular(10),
                  onPressed: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pulse.description,
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Wrap(
                                children: [
                                  Text(
                                    "${pulse.scrobbles} scrobbles",
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface
                                          .withAlpha(200),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              LinearProgressIndicator(
                                minHeight: 10,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                value: pulse.percentage,
                                // Set the percentage value here
                                backgroundColor: theme.colorScheme.onSurface
                                    .withAlpha(50),
                                // Light background color
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme
                                      .colorScheme
                                      .primary, // Use the primary color for progress
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

// --------------------- MediumChartItem ---------------------
class MediumChartItem extends StatelessWidget {
  final ChartDisplayData chartDataLeft;
  final ChartDisplayData chartDataRight;
  final String url;

  const MediumChartItem({
    super.key,
    required this.chartDataLeft,
    required this.chartDataRight,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(150, 0, 0, 0),
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
                    ImageService.buildImage(
                      chartDataLeft.id,
                      url,
                      chartDataLeft.type,
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
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
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: Text(
                          chartDataLeft.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
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
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(150, 0, 0, 0),
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
                    ImageService.buildImage(
                      chartDataRight.id,
                      url,
                      chartDataRight.type,
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
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
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: Text(
                          chartDataRight.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
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
