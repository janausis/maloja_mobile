import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:maloja_mobile/services/setup_service.dart';

class ArtistService {
  Future<List<Artist>> fetchArtists() async {
    try {
      String baseUrl = await ServerService().getServerUrl();

      final response = await http.get(Uri.parse('$baseUrl/apis/mlj_1/charts/artists'));

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);

        if (jsonBody['status'] == 'ok' && jsonBody['list'] is List) {
          final List<dynamic> artistList = jsonBody['list'];
          return artistList.map((artistData) => Artist.fromJson(artistData)).toList();
        } else {
          throw Exception('Invalid response structure');
        }
      } else {
        throw Exception('Failed to load artists: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching artists: $e');
    }
  }
}


class Artist {
  final int id;
  final int rank;
  final String name;
  final int scrobbles;
  final int realScrobbles;
  final List<String> associatedArtists;

  Artist({
    required this.id,
    required this.rank,
    required this.name,
    required this.scrobbles,
    required this.realScrobbles,
    required this.associatedArtists
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['artist_id'] as int,
      rank: json['rank'] as int,
      name: json['artist'] as String,
      scrobbles: json['scrobbles'] as int,
      realScrobbles: json['real_scrobbles'] as int,
      associatedArtists: List<String>.from(json['associated_artists']),
    );
  }

}
