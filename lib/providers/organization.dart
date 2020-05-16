import 'package:flutter/foundation.dart';

class CharitableOrganization with ChangeNotifier {
  final String id;
  final String orgName;
  final String logo;
  final String address;
  final String description;
  final String licenseNo;
  final String landLineNo;
  final String mobileNo;
  final String bankAccounts;

  CharitableOrganization(
      {this.id,
      this.orgName,
      this.logo,
      this.address,
      this.description,
      this.licenseNo,
      this.landLineNo,
      this.mobileNo,
      this.bankAccounts});
}




