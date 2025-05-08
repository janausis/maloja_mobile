import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:maloja_mobile/services/setup_service.dart';

class PulseService {
  Future<List<Pulse>> fetchPulse(String s, String baseUrl) async {
    try {
      String filter = "";

      switch (s) {
        case "weeks":
          filter = "?trail=1&step=week";
          break;
        case "months":
          filter = "?trail=1&step=month";
          break;
        case "years":
          filter = "?trail=1&step=year";
          break;
        default:
          filter = "?trail=1&step=day";
          break;
      }

      final response = await http.get(Uri.parse('$baseUrl/apis/mlj_1/pulse$filter'));


      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);

        if (jsonBody['status'] == 'ok' && jsonBody['list'] is List) {
          final List<dynamic> trackList = jsonBody['list'];
          final List<Pulse> fullList = trackList
              .asMap()
              .entries
              .map((entry) => Pulse.fromJson(entry.value, entry.key))
              .toList()
              .reversed
              .toList();

          // Trim trailing zeros
          int lastNonZeroIndex = fullList.lastIndexWhere((pulse) => pulse.scrobbles != 0);
          final List<Pulse> trimmedList = fullList.sublist(0, lastNonZeroIndex + 1);

          // Find max scrobbles value
          final maxScrobbles = trimmedList.fold<int>(0, (max, pulse) => pulse.scrobbles > max ? pulse.scrobbles : max);

          // Calculate percentage for each object and update it
          for (var pulse in trimmedList) {
            pulse.percentage = maxScrobbles == 0 ? 0 : pulse.scrobbles / maxScrobbles;
          }

          return trimmedList;

        } else {
          throw Exception('Invalid response structure');
        }
      } else {
        throw Exception('Failed to load pulse: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching pulse: $e');
    }
  }
}



class Pulse {
  final int scrobbles;
  final String description;
  double percentage = 0;

  Pulse({
    required this.scrobbles,
    required this.description,
  });

  factory Pulse.fromJson(Map<String, dynamic> json, int rank) {
    return Pulse(
      scrobbles: json["scrobbles"] as int,
      description: json["range"]["description"],
    );
  }
}
