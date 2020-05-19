import 'package:flutter/foundation.dart';

class History with ChangeNotifier {
  final String id;
  final String donationType;
  final String donationAmount;
  final String donationDate;
  final String donationItems;
  final String donatorName;
  final String donatorMobile;
  final String donatorAddress;
  final String donationImage;

  History({
    this.id,
    @required this.donationType,
    @required this.donationDate,
    @required this.donationAmount,
    @required this.donationItems,
    @required this.donatorName,
    @required this.donatorMobile,
    @required this.donatorAddress,
    @required this.donationImage,
  });
}