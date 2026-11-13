import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/character.dart';
import '../models/episode.dart';

class ApiService {
  static const String baseUrl = 'https://rickandmortyapi.com/api';

  // Mengambil daftar karakter
  static Future<List<Character>> getCharacters({
    String? status,
    String? name,
  }) async {
    final queryParameters = <String, String>{};

    if (status != null && status.toLowerCase() != 'all') {
      queryParameters['status'] = status.toLowerCase();
    }

    if (name != null && name.trim().isNotEmpty) {
      queryParameters['name'] = name.trim();
    }

    final uri = Uri.parse('$baseUrl/character').replace(
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];

      return results.map((item) => Character.fromJson(item)).toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Gagal mengambil data karakter');
    }
  }

  // Mengambil detail satu karakter
  static Future<Character> getCharacterDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/character/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Character.fromJson(data);
    } else {
      throw Exception('Gagal mengambil detail karakter');
    }
  }

  // Mengambil daftar episode
  static Future<List<Episode>> getEpisodes() async {
    final response = await http.get(Uri.parse('$baseUrl/episode'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];

      return results.map((item) => Episode.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data episode');
    }
  }
}
