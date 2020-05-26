import 'dart:convert';
import 'dart:io';
import 'package:BorhanAdmin/models/chat.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageChat with ChangeNotifier {
  List<Chat> _items = [];

  List<Chat> get items {
    return [..._items];
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

  Future<void> userAddMessage(Chat chat) async {
    const url = 'https://borhanadmin.firebaseio.com/chat.json';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'name': "Ahmed",
            'userId': "cdcd",
            'text': "dcc",
            'image': chat.img,
            'time': DateTime.now().toString(),
          },
        ),
      );
      final newMessage = Chat(
        id: json.decode(response.body)['name'],
        userId: chat.userId,
        userName: chat.userName,
        text: chat.text,
        img: chat.img,
        time: DateTime.now().toString(),
      );
//      _items.add(newMessage);
      _items.insert(0, newMessage);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> adminAddMessage(Chat chat) async {
    const url = 'https://borhanadmin.firebaseio.com/chat.json';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'name': "Admin",
            'userId': "cdcd",
            'text': "dcc",
            'image': chat.img,
            'time': DateTime.now().toString(),
          },
        ),
      );
      final newMessage = Chat(
        id: json.decode(response.body)['name'],
        userId: chat.userId,
        userName: chat.userName,
        text: chat.text,
        img: chat.img,
        time: DateTime.now().toString(),
      );
//      _items.add(newMessage);
      _items.insert(0, newMessage);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

//  Future<String> uploadImage(File image) async {
//    print("in upload");
//    StorageReference storageReference =
//        FirebaseStorage.instance.ref().child(image.path.split('/').last);
//    StorageUploadTask uploadTask = storageReference.putFile(image);
//    await uploadTask.onComplete;
//    print('File Uploaded');
//    String _downloadUrl = await storageReference.getDownloadURL();
//    print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
//        '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
//    print("from uploading :  " + _downloadUrl);
//    return _downloadUrl;
//  }

  Future<String> userUploadImage(File image) async {
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

  Future<String> adminUploadImage(File image) async {
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
