import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:maloja_mobile/services/setup_service.dart';

class ScrobbleService {
  Future<List<Scrobble>> fetchScrobbles(String s, String baseUrl) async {
    try {
      String filter = "?in=today";
      switch (s) {
        case "week":
          filter = "?in=thisweek";
          break;
        case "month":
          filter = "?in=thismonth";
          break;
        case "year":
          filter = "?in=thisyear";
          break;
        case "total":
          filter = "";
          break;
      }

      final response = await http.get(Uri.parse('$baseUrl/apis/mlj_1/scrobbles$filter'));

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);

        if (jsonBody['status'] == 'ok' && jsonBody['list'] is List) {
          final List<dynamic> trackList = jsonBody['list'];
          return trackList.asMap().entries.map(
                (entry) => Scrobble.fromJson(entry.value, entry.key),
          ).toList();
        } else {
          throw Exception('Invalid response structure');
        }
      } else {
        throw Exception('Failed to load scrobbles: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching scrobbles: $e');
    }
  }
}



class Scrobble {
  final int id;
  final int rank;
  final String title;
  final String album;
  final int length;
  final int time_created;
  final List<String> artists;

  Scrobble({
    required this.id,
    required this.rank,
    required this.title,
    required this.album,
    required this.length,
    required this.time_created,
    required this.artists,
  });

  factory Scrobble.fromJson(Map<String, dynamic> json, int rank) {
    return Scrobble(
      id: json["rawscrobble"]['track_id'] as int,
      rank: rank,
      title: json["track"]['title'],
      length: json["track"]['length'] as int,
      album: json["track"]['album'] != null
          ? json["track"]['album']['albumtitle'] as String
          : "Unknown Album",
      time_created: json['rawscrobble']["scrobble_time"] as int,
      artists: List<String>.from(json["track"]['artists']),
    );
  }
}
