import 'package:flutter/foundation.dart';

class AdminInfo with ChangeNotifier {
  final String id;
  final String email;

  AdminInfo({
    this.id,
    @required this.email,
  });
}
