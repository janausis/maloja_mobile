import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:maloja_mobile/services/setup_service.dart';

class AlbumService {
  Future<List<Album>> fetchAlbums(
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

      final response = await http.get(Uri.parse('$baseUrl/apis/mlj_1/charts/albums?perpage=$perPage&page=$page$filter'));

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);

        if (jsonBody['status'] == 'ok' && jsonBody['list'] is List) {
          final List<dynamic> albumList = jsonBody['list'];
          return albumList.map((albumData) => Album.fromJson(albumData)).toList();
        } else {
          throw Exception('Invalid response structure');
        }
      } else {
        throw Exception('Failed to load albums: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching albums: $e');
    }
  }
}

class Album {
  final int id;
  final int rank;
  final String albumTitle;
  final int scrobbles;
  final List<String> artists;

  Album({
    required this.id,
    required this.rank,
    required this.albumTitle,
    required this.scrobbles,
    required this.artists,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['album_id'] as int,
      rank: json['rank'] as int,
      albumTitle: json['album']['albumtitle'] as String,
      scrobbles: json['scrobbles'] as int,
      artists: List<String>.from(json['album']['artists']),
    );
  }
}
