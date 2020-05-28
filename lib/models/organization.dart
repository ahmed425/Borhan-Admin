import 'package:flutter/foundation.dart';

class Organization with ChangeNotifier {
  final String id;
  final String orgName;
  final String logo;
  final String address;
  final String description;
  final String licenseNo;
  final String landLineNo;
  final String mobileNo;
  final String bankAccounts;
  final String webPage;
  final String orgLocalId;

  Organization(
      {this.id,
        this.orgLocalId,
      this.orgName,
      this.logo,
      this.address,
      this.description,
      this.licenseNo,
      this.landLineNo,
      this.mobileNo,
      this.bankAccounts,
      this.webPage});
}
