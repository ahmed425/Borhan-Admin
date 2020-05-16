import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/activity.dart';

class Activities with ChangeNotifier {
  List<Activity> _items = [
//    Activity(
//      activityName: 'كساء',
//      activityDescription: 'clothes',
//    ),
//    Activity(
//      activityName: 'كفالة اليتيم',
//      activityDescription: 'clothes',
//    ),
//    Activity(
//      activityName: 'اطعام',
//      activityDescription: 'clothes',
//    ),
  ];

  List<Activity> get items {
    return [..._items];
  }

  Activity findById(String id) {
    return _items.firstWhere((activity) => activity.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    const url = 'https://borhanadmin.firebaseio.com/activities.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Activity> loadedActivities = [];
      extractedData.forEach((prodId, prodData) {
        loadedActivities.add(Activity(
          id: prodId,
          activityName: prodData['name'],
          activityDescription: prodData['description'],
          imagesUrl: prodData['image'],
        ));
      });
      _items = loadedActivities;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addActivity(Activity activity) async {
    const url = 'https://borhanadmin.firebaseio.com/activities.json';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'name': activity.activityName,
            'description': activity.activityDescription,
            'image': activity.imagesUrl,
          },
        ),
      );
      final newActivity = Activity(
        id: json.decode(response.body)['name'],
        activityName: activity.activityName,
        activityDescription: activity.activityDescription,
        imagesUrl: activity.imagesUrl,
      );
      _items.add(newActivity);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateActivity(String id, Activity newActivity) async{
    final activityIndex = _items.indexWhere((activity) => activity.id == id);
    if (activityIndex >= 0) {
      final url = 'https://borhanadmin.firebaseio.com/activities/$id.json';
      await http.patch(url,
          body: json.encode({
            'name': newActivity.activityName,
            'description': newActivity.activityDescription,
            'image': newActivity.imagesUrl,
          }));
      _items[activityIndex] = newActivity;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteActivity(String id) async{
    final url = 'https://borhanadmin.firebaseio.com/activities/$id.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeWhere((activity) => activity.id == id);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}