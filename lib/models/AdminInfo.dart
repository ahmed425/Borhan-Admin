import 'package:flutter/foundation.dart';

class AdminInfo with ChangeNotifier {
  final String id;
  final String email;

  AdminInfo({
    this.id,
    @required this.email,
  });

  Map<String, dynamic> toJson() => {
    'id' :id,
    'email': email,
  };

  AdminInfo.fromJson(Map<String, dynamic> json):
        id = json['id'],
        email = json['email'];

  @override
  String toString() {
    return "UserNav object data is id = $id email = $email";
  }
}
