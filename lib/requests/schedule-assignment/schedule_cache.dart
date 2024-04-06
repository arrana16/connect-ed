import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
      return true;
    } catch (e) {
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
        return null; // No data or expiration time found.
      }

      DateTime expirationTime = DateTime.parse(expirationTimeStr);
      if (expirationTime.isAfter(DateTime.now())) {
        // The data has not expired.
        return data;
      } else {
        // Data has expired. Remove it from SharedPreferences.
        await prefs.remove(_keyData);
        await prefs.remove(_keyExpiration);
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Function to clear data from SharedPreferences
  Future<void> clearData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyData);
      await prefs.remove(_keyExpiration);
    } catch (e) {
      throw Exception(e);
    }
  }
}

class RemoteSource {
  final MySharedPreferences mySharedPreferences;

  RemoteSource(this.mySharedPreferences);

  // Function to fetch data from the API and cache it locally
  Future<String> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final String link = prefs.getString("link") ?? '';
      final response = await http.get(Uri.parse(link));
      if (response.statusCode != 200) {
        throw Exception('Failed to load data');
      } else {
        final isSaved = await mySharedPreferences.saveDataWithExpiration(
            response.body, const Duration(minutes: 15));
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
