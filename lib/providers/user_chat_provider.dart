
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserChatProvider with ChangeNotifier {

  List<String> _users = [];
  List<String> get users {
    return [..._users];
  }

  List<String> _usersLocalId = [];

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

//  Future<void> fetchAndSetAllUsersLocalId(String orgId) async {
//    final url = 'https://borhanadmin.firebaseio.com/chat/$orgId.json';
//    try {
//      final response = await http.get(url);
////      print('All Users from fetch');
//      final extractedData = json.decode(response.body) as Map<String, dynamic>;
////      print(response.body);
//      final List<String> loadedChat = [];
//      if (extractedData != null) {
//        extractedData.forEach((usersLocalid,Data) {
//          loadedChat.insert(0,usersLocalid);
//        });
//        _usersLocalId = loadedChat;
//        notifyListeners();
////        print(_users);
//      } else {
//        print('No Data in this chat');
//      }
//    } catch (error) {
//      throw (error);
//    }
//  }
//
//  Future<void> fetchAndSetAllUsersNames(String orgId) async {
//    _usersLocalId.forEach((element) async {
//      print(element);
//      final url = 'https://borhanadmin.firebaseio.com/chat/$orgId/$element.json';
//      try {
//        final response = await http.get(url);
//        print('All Users from fetch');
//        final extractedData = json.decode(response.body) as Map<String, dynamic>;
//        print(response.body);
//        final List<String> loadedChat = [];
//        if (extractedData != null) {
//          extractedData.forEach((userId,Data) {
//            loadedChat.add(Data['name']);
//            return;
//          });
//          _users.add(loadedChat[0]);
//          notifyListeners();
//        print(_users);
//        } else {
//          print('No Data in this chat');
//        }
//      } catch (error) {
//        throw (error);
//      }
//    });
//
//  }
}
