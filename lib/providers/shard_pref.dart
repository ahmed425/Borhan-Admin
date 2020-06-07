import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  read(String key) async {
    print('inside read');
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key));
  }

  save(String key, value) async {
    print('inside save');
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    print('inside remove');
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}