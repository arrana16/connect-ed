import 'dart:convert';

import 'package:applebycollegeapp/classes/games.dart';
import 'package:applebycollegeapp/classes/sports.dart';
import 'package:applebycollegeapp/classes/standings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SportsCacheHandler {
  SportsCacheHandler();

  Future<void> writeData(String data, String key, Duration expiration,
      String expirationKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, data);
    await prefs.setString(
        expirationKey, DateTime.now().add(expiration).toIso8601String());
  }

  Future<String?> readData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    if (data != null) {
      return data;
    } else {
      return null;
    }
  }

  Future<DateTime?> readExpiration(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? expiration = prefs.getString(key);
    if (expiration != null) {
      return DateTime.parse(expiration);
    } else {
      return null;
    }
  }

  Future<List<Sport>> getSports() async {
    // try {
    DateTime? expiration = await readExpiration("_SportsExpiration");
    String? data = await readData("_SportsData");
    if (data != null &&
        expiration != null &&
        expiration.isAfter(DateTime.now())) {
      final parsed =
          (jsonDecode(data)["data"] as List).cast<Map<String, dynamic>>();
      final sports = parsed.map<Sport>((json) => Sport.fromJson(json)).toList();
      return sports;
    }
    final response = await http
        .get(Uri.parse('https://urchin-app-xjcdr.ondigitalocean.app/sports/'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load data');
    }

    await writeData(response.body, "_SportsData", const Duration(minutes: 15),
        "_SportsExpiration");

    final parsed = (jsonDecode(response.body)["data"] as List)
        .cast<Map<String, dynamic>>();
    final sports = parsed.map<Sport>((json) => Sport.fromJson(json)).toList();
    print(sports);
    return sports;
  }

  Future<List<Game>> getGames() async {
    // try {
    DateTime? expiration = await readExpiration("_GamesExpiration");
    String? data = await readData("_GamesData");

    if (data != null &&
        expiration != null &&
        expiration.isAfter(DateTime.now())) {
      final parsed =
          (jsonDecode(data)["data"] as List).cast<Map<String, dynamic>>();
      return parsed.map<Game>((json) => Game.fromJson(json)).toList();
    }
    final response = await http
        .get(Uri.parse('https://urchin-app-xjcdr.ondigitalocean.app/games'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load data');
    }

    await writeData(response.body, "_GamesData", const Duration(minutes: 15),
        "_GamesExpiration");
    final parsed = (jsonDecode(response.body)["data"] as List)
        .cast<Map<String, dynamic>>();
    final sports = parsed.map<Game>((json) => Game.fromJson(json)).toList();
    return sports;
  }

  Future<List<Standing>> getStandings() async {
    // try {
    DateTime? expiration = await readExpiration("_StandingsExpiration");
    String? data = await readData("_StandingsData");

    if (data != null &&
        expiration != null &&
        expiration.isAfter(DateTime.now())) {
      final parsed =
          (jsonDecode(data)["data"] as List).cast<Map<String, dynamic>>();
      return parsed.map<Standing>((json) => Standing.fromJson(json)).toList();
    }
    final response = await http.get(
        Uri.parse('https://urchin-app-xjcdr.ondigitalocean.app/standings'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load data');
    }

    await writeData(response.body, "_StandingsData",
        const Duration(minutes: 15), "_StandingsExpiration");
    final parsed = (jsonDecode(response.body)["data"] as List)
        .cast<Map<String, dynamic>>();
    final sports =
        parsed.map<Standing>((json) => Standing.fromJson(json)).toList();
    return sports;
  }
}
