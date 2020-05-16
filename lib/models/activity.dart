import 'package:flutter/foundation.dart';

class Activity with ChangeNotifier{
  final String id;
  final String activityName;
  final String activityDescription;
  final String imagesUrl;

  Activity({
    this.id,
    @required this.activityName,
    @required this.activityDescription,
    this.imagesUrl,
  });
}