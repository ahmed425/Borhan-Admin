import 'dart:convert';
import 'package:BorhanAdmin/models/AdminInfo.dart';
import 'package:BorhanAdmin/providers/shard_pref.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {

  String _orgId;

  String get orgId => _orgId;

  AdminInfo _adminLoaded;

  AdminInfo get userLoad {
    return _adminLoaded;
  }

  var _adminData = AdminInfo(email: '', id: '');
  AdminInfo get adminData {
    return _adminData;
  }

  Future<AdminInfo> loadSharedPrefs() async {
    AdminInfo admin;
    try {
      SharedPref sharedPref = SharedPref();
      admin = AdminInfo.fromJson(await sharedPref.read("admin"));
      _adminLoaded = admin;
      print('from loading sh pref');
      print(_adminData.id);
    } catch (error) {
      // do something
      print('error in fetch from sh pref');
//      print(error);
    }
    return admin;
  }

//  loadSharedPrefs() async {
//    try {
//     SharedPref sharedPref = SharedPref();
//     AdminInfo user = AdminInfo.fromJson(await sharedPref.read("admin"));
//      _userLoad = user;
//      print('*********************************************');
//      print('from loading from sh admin : ');
//      print(_userLoad);
//      } catch (Excepetion) {
//    // do something
//       }
//   }

  Future<void> _authenticate(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBxvZKA_BX1E0Ae_R8BS3L_-hyUSi1vkbo';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
//      _orgId = responseData['localId'];
//      print("Org Id: " + _orgId);
      _adminData = AdminInfo(
        email: responseData['email'],
        id: responseData['localId'],
      );
      SharedPref sharedPref = SharedPref();
      sharedPref.save("admin", _adminData);
      print('after sh pref');
      print("Admin Data is :  $responseData");

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> _sendResetPasswordEmail(String email) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyBxvZKA_BX1E0Ae_R8BS3L_-hyUSi1vkbo';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {"requestType": "PASSWORD_RESET", "email": email},
        ),
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> resetPassword(String email) async {
    return _sendResetPasswordEmail(email);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password);
  }
}
