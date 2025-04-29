
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maloja_mobile/services/album_service.dart';
import 'package:maloja_mobile/services/artist_service.dart';

class ChartDisplayData {
  int id;
  String name;
  int rank;
  Widget image;
  int scrobbles;
  List<String> artists;

  ChartDisplayData({required this.id, required this.name, required this.rank, required this.image, required this.scrobbles, required this.artists});

  String getArtist() {
    return artists.join(", ");
  }
}

class BigChartItem extends StatelessWidget {
  final ChartDisplayData chartData;
  final bool showRanking;
  final bool showArtist;
  final bool showScrobbles;
  final ThemeData theme;

  const BigChartItem({super.key, required this.chartData, this.showRanking = true, this.showScrobbles = true, this.showArtist = true, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15, bottom: 30),
            child: Container(
              decoration: BoxDecoration(
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
                width: 250,
                height: 250,
                child: Stack(
                  children: [
                    chartData.image,

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
                        color: null,
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                chartData.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Wrap(
                                children: [
                                  showArtist ? Text(
                                    showScrobbles ? "${chartData.getArtist()} • " : chartData.getArtist(),
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(200), // fainter
                                      fontSize: 14, // slightly smaller
                                      fontWeight: FontWeight.w400, // lighter weight
                                    ),
                                  ) : SizedBox(),
                                  SizedBox(width: 0,),
                                  showScrobbles ? Text(
                                    "${chartData.scrobbles} scrobbles",
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(200), // fainter
                                      fontSize: 14, // slightly smaller
                                      fontWeight: FontWeight.w400, // lighter weight
                                    ),
                                  ) : SizedBox(),
                                ],
                              )
                            ],
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

class MediumChartItem extends StatelessWidget {
  final ChartDisplayData chartDataLeft;
  final ChartDisplayData chartDataRight;

  const MediumChartItem({
    super.key,
    required this.chartDataLeft,
    required this.chartDataRight,
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
                    chartDataLeft.image,

                    // Farbverlauf (Gradient Overlay)
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
                        color: null,
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: Text(
                          chartDataLeft.name,
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
                    chartDataRight.image,

                    // Farbverlauf (Gradient Overlay)
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
                        color: null,
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: Text(
                          chartDataRight.name,
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

class SmallChartData extends StatelessWidget {
  final ChartDisplayData chartData;
  final bool showRanking;
  final bool showArtist;
  final bool showScrobbles;
  final ThemeData theme;

  const SmallChartData({super.key, required this.chartData, this.showRanking = true, this.showScrobbles = true, this.showArtist = true, required this.theme});

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
                          child: chartData.image,
                        ),
                      ),
                      showRanking ? SizedBox(
                        width: 60,
                        child: Text(
                          "  #${chartData.rank}",
                          style: TextStyle(
                            color: Color.fromARGB(255, 150, 150, 150),
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ) : SizedBox(width: 10,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chartData.name,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Wrap(
                              children: [
                                showArtist ? Text(
                                  showScrobbles ? "${chartData.getArtist()} • " : chartData.getArtist(),
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface.withAlpha(200), // fainter
                                    fontSize: 14, // slightly smaller
                                    fontWeight: FontWeight.w400, // lighter weight
                                  ),
                                ) : SizedBox(),
                                SizedBox(width: 0,),
                                showScrobbles ? Text(
                                  "${chartData.scrobbles} scrobbles",
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface.withAlpha(200), // fainter/ fainter
                                    fontSize: 14, // slightly smaller
                                    fontWeight: FontWeight.w400, // lighter weight
                                  ),
                                ) : SizedBox(),
                              ],
                            )
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
    );
  }
}



