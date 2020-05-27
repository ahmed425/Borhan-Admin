import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/activity.dart';

class Activities with ChangeNotifier {
  List<Activity> _items = [];

  List<Activity> get items {
    return [..._items];
  }


  Activity findById(String id) {
    return _items.firstWhere((activity) => activity.id == id);
  }

  Future<void> fetchAndSetActivities(String orgId) async {
    final url = 'https://borhanadmin.firebaseio.com/activities/$orgId.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Activity> loadedActivities = [];
      extractedData.forEach((activityId, activityData) {
        loadedActivities.add(Activity(
          id: activityId,
          activityName: activityData['name'],
          activityDescription: activityData['description'],
          imagesUrl: activityData['image'],
        ));
      });
      _items = loadedActivities;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addActivity(Activity activity, String orgId) async {
    final url = 'https://borhanadmin.firebaseio.com/activities/$orgId.json';
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

  Future<void> updateActivity(String id, Activity newActivity,String orgId) async {
    final activityIndex = _items.indexWhere((activity) => activity.id == id);
    if (activityIndex >= 0) {
      final url = 'https://borhanadmin.firebaseio.com/activities/$orgId/$id.json';
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

  Future<void> deleteActivity(String id,String orgId) async {
    final url = 'https://borhanadmin.firebaseio.com/activities/$orgId/$id.json';
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

  Future<String> uploadImage(File image) async {
    print("in upload");
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(image.path.split('/').last);
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    print('File Uploaded');
    String _downloadUrl = await storageReference.getDownloadURL();
    print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
        '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    print("from uploading :  " + _downloadUrl);
    return _downloadUrl;
  }

  Future deleteImage(String imgUrl) async {
    print("From Delete Image");
    StorageReference myStorageReference =
        await FirebaseStorage.instance.getReferenceFromUrl(imgUrl);
    print(myStorageReference.path);
    await myStorageReference.delete();
    print("image deleted successfully");
  }
}
