import 'package:flutter/foundation.dart';

class DonationRequest with ChangeNotifier {
  final String id;
  final String donationType;
  final String donatorName;
  final String donatorMobileNo;
  final String donatorAddress;
  final String donationItems;
  final String donationAmount;
  final String donationDate;
  final String availableOn;
  final String image;
  final String orgName;
  final String actName;
  final String userId;
  final String status;

  DonationRequest(
      {this.id,
      this.donationType,
      this.donatorName,
      this.donatorMobileNo,
      this.donatorAddress,
      this.donationItems,
      this.donationAmount,
      this.donationDate,
      this.availableOn,
      this.image,
      this.orgName,
      this.actName,
      this.userId,
      this.status,});
}
