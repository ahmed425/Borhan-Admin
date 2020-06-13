import 'package:BorhanAdmin/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserChatProvider with ChangeNotifier {

  List<String> _users = [];
  List<String> get users {
    return [..._users];
  }

  List<String> _usersLocalId = [];
  List<String> get usersLocalId {
    return [..._usersLocalId];
  }

  Future<void> fetchAndSetAllUsers(String orgId) async {
    final url = 'https://borhanadmin.firebaseio.com/chat/$orgId.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<String> loadedChat = [];
      if (extractedData != null) {
        extractedData.forEach((usersId,data) {
          loadedChat.insert(0,usersId);
        });
        _users = loadedChat;
        notifyListeners();
      } else {
        print('No Data in this chat');
      }
    } catch (error) {
      throw (error);
    }
  }
}
