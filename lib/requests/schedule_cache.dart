import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class MySharedPreferences {
  static const String _keyData = 'myData';
  static const String _keyExpiration = 'expirationTime';

  // Function to save data with an expiration date to SharedPreferences
  Future<bool> saveDataWithExpiration(
      String data, Duration expirationDuration) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      DateTime expirationTime = DateTime.now().add(expirationDuration);
      await prefs.setString(_keyData, data);
      await prefs.setString(_keyExpiration, expirationTime.toIso8601String());
      print('Data saved to SharedPreferences.');
      return true;
    } catch (e) {
      print('Error saving data to SharedPreferences: $e');
      return false;
    }
  }

  // Function to get data from SharedPreferences if it's not expired
  Future<String?> getDataIfNotExpired() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? data = prefs.getString(_keyData);
      String? expirationTimeStr = prefs.getString(_keyExpiration);
      if (data == null || expirationTimeStr == null) {
        print('No data or expiration time found in SharedPreferences.');
        return null; // No data or expiration time found.
      }

      DateTime expirationTime = DateTime.parse(expirationTimeStr);
      if (expirationTime.isAfter(DateTime.now())) {
        print('Data has not expired.');
        // The data has not expired.
        return data;
      } else {
        // Data has expired. Remove it from SharedPreferences.
        await prefs.remove(_keyData);
        await prefs.remove(_keyExpiration);
        print('Data has expired. Removed from SharedPreferences.');
        return null;
      }
    } catch (e) {
      print('Error retrieving data from SharedPreferences: $e');
      return null;
    }
  }

  // Function to clear data from SharedPreferences
  Future<void> clearData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyData);
      await prefs.remove(_keyExpiration);
      print('Data cleared from SharedPreferences.');
    } catch (e) {
      print('Error clearing data from SharedPreferences: $e');
    }
  }
}

class RemoteSource {
  final MySharedPreferences mySharedPreferences;

  RemoteSource(this.mySharedPreferences);

  // Function to fetch data from the API and cache it locally
  Future<String> fetchData() async {
    print('fetchData');
    try {
      final response = await http.get(Uri.parse(
          'https://appleby.myschoolapp.com/podium/feed/iCal.aspx?z=rwbg9TXaxP2HmddvSTQ7hag8xBZbtW85mYDkAvSRgQWHFAQLrIAjDzM8j%2ffMmkZ75F1qvYGSl1lZiVeFaSZ4AA%3d%3d'));
      if (response.statusCode != 200) {
        throw Exception('Failed to load data');
      } else {
        final isSaved = await mySharedPreferences.saveDataWithExpiration(
            response.body, const Duration(days: 3));
        if (isSaved) {
          return response.body;
        } else {
          throw Exception('Failed to save data');
        }
      }
    } catch (error) {
      throw Exception(error);
    }
  }
}
