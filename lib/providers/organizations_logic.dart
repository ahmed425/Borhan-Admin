import 'dart:convert';
import '../models/organization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Organizations with ChangeNotifier {
  Future<void> updateOrg(String id, Organization newOrg) async {
    // id = json.decode(response.body)['name'];
    // final orgIndex = _orgs.indexWhere((org) => org.id == id);
    // if (orgIndex >= 0) {
    final url =
        'https://borhanadmin.firebaseio.com/CharitableOrganizations/1.json';
    await http.patch(url,
        body: json.encode({
          'orgName': newOrg.orgName,
          'logo': newOrg.logo,
          'address': newOrg.address,
          'description': newOrg.description,
          'licenseNo': newOrg.licenseNo,
          'landLineNo': newOrg.landLineNo,
          'mobileNo': newOrg.mobileNo,
          'bankAccounts': newOrg.bankAccounts,
          'webPage': newOrg.webPage,
        }));
    // _orgs[orgIndex] = newOrg;
    notifyListeners();
  }
}
