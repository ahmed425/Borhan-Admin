import 'package:flutter/foundation.dart';

class User with ChangeNotifier{
  final String id;
  final String name;

  User({
    this.id,
    this.name,
  });
}