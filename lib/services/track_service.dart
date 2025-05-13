import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:maloja_mobile/services/setup_service.dart';

class TrackService {
  Future<List<Track>> fetchTracks(
      String s,
      String baseUrl,
      {int perPage = 100, int page = 0}
      ) async {
    try {
      String filter = "&in=today";
      switch (s) {
        case "week":
          filter = "&in=thisweek";
          break;
        case "month":
          filter = "&in=thismonth";
          break;
        case "year":
          filter = "&in=thisyear";
          break;
        case "total":
          filter = "";
          break;
      }

      final response = await http.get(Uri.parse('$baseUrl/apis/mlj_1/charts/tracks?perpage=$perPage&page=$page$filter'));

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);

        if (jsonBody['status'] == 'ok' && jsonBody['list'] is List) {
          final List<dynamic> trackList = jsonBody['list'];
          return trackList.map((trackData) => Track.fromJson(trackData)).toList();
        } else {
          throw Exception('Invalid response structure');
        }
      } else {
        throw Exception('Failed to load tracks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching tracks: $e');
    }
  }
}



class Track {
  final int id;
  final int rank;
  final String title;
  final String album;
  final int length;
  final int scrobbles;
  final List<String> artists;

  Track({
    required this.id,
    required this.rank,
    required this.title,
    required this.album,
    required this.length,
    required this.scrobbles,
    required this.artists,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['track_id'] as int,
      rank: json['rank'] as int,
      title: json["track"]['title'],
      length: json["track"]['length'] as int,
      album: json["track"]['album'] != null
          ? json["track"]['album']['albumtitle'] as String
          : "Unknown Album",
      scrobbles: json['scrobbles'] as int,
      artists: List<String>.from(json["track"]['artists']),
    );
  }
}
