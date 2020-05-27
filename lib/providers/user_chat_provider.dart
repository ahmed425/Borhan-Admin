import 'dart:io';
import '../models/chat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserChatProvider with ChangeNotifier {

  List<String> _users = [];
  List<String> get users {
    return [..._users];
  }

  Future<void> fetchAndSetAllUsers(String orgId) async {
    final url = 'https://borhanadmin.firebaseio.com/chat/$orgId.json';
    try {
      final response = await http.get(url);
      print('All Users from fetch');
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(response.body);
      final List<String> loadedChat = [];
      if (extractedData != null) {
        extractedData.forEach((usersId,Data) {
          loadedChat.insert(0,usersId);
        });
        _users = loadedChat;
        notifyListeners();
//        print(_users);
      } else {
        print('No Data in this chat');
      }
    } catch (error) {
      throw (error);
    }
  }
}
