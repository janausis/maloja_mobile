// lib/services/setup_service.dart

import 'dart:convert';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ServerService {
  Future<bool> pingServer(Uri uri) async {
    try {
      // Send the HTTP request and get the response
      final response = await http.get(uri).timeout(const Duration(seconds: 5));

      // Check for valid response status code
      if (response.statusCode == 200) {
        // Try to parse the JSON body if it exists

        final Map<String, dynamic> jsonBody = jsonDecode(response.body);

        // Check if the "status" key exists and is not "ok"
        if (!jsonBody.containsKey('status')) {
          return false;
        }

        return true;  // Server responded successfully
      } else {
        throw Exception('Server responded with code ${response.statusCode}');
      }
    } catch (e) {
      // Catch and throw any other exceptions that occur during the request
      throw Exception('Server seems to be invalid!');
    }
  }

  Future<String> getServerUrl() async {
    final box = await Hive.openBox('settings');
    final selectedUrl = box.get('selectedUrl', defaultValue: '');
    return selectedUrl;
  }
}
