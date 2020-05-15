import 'package:flutter/foundation.dart';

class Activity {
  final String activityName;
  final String activityDescription;
  final List<String> imagesUrl;

  Activity({
    @required this.activityName,
    @required this.activityDescription,
    this.imagesUrl,
  });
}