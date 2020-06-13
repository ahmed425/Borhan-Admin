import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/organization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Organizations with ChangeNotifier {
  List<Organization> _items = [];

  List<Organization> get items {
    return [..._items];
  }

  Organization findById(String id) {
    var organization = _items.firstWhere((org) => org.orgLocalId == id);
    return organization;
  }

  Organization findByOrgId(String orgId) {
    var organization = _items.firstWhere((org) => org.id == orgId);
    return organization;
  }

  Future<String> fetchAndSetOrgName(String orgId) async {
    final url =
        'https://borhanadmin.firebaseio.com/CharitableOrganizations.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Organization> loadedActivities = [];
      if (extractedData != null) {
        extractedData.forEach((autoOrgId, orgData) {
          loadedActivities.add(Organization(
              id: autoOrgId,
              orgName: orgData['orgName'],
              address: orgData['address'],
              bankAccounts: orgData['bankAccounts'],
              landLineNo: orgData['landLineNo'],
              description: orgData['description'],
              licenseNo: orgData['licenseNo'],
              mobileNo: orgData['mobileNo'],
              webPage: orgData['webPage'],
              logo: orgData['logo'],
              orgLocalId: orgData['orgLocalId']));
        });
        _items = loadedActivities;
        notifyListeners();
        var organization = _items.firstWhere((org) => org.id == orgId);
        return organization.orgName;
      } else {
        print('No Data in this chat');
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<Organization> fetchAndSetOrg(String orgLocalId) async {
    final url =
        'https://borhanadmin.firebaseio.com/CharitableOrganizations.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Organization> loadedActivities = [];
      if (extractedData != null) {
        extractedData.forEach((autoOrgId, orgData) {
          loadedActivities.add(Organization(
              id: autoOrgId,
              orgName: orgData['orgName'],
              address: orgData['address'],
              bankAccounts: orgData['bankAccounts'],
              landLineNo: orgData['landLineNo'],
              description: orgData['description'],
              licenseNo: orgData['licenseNo'],
              mobileNo: orgData['mobileNo'],
              webPage: orgData['webPage'],
              logo: orgData['logo'],
              orgLocalId: orgData['orgLocalId']));
        });
        _items = loadedActivities;
        notifyListeners();
        var organization =
            _items.firstWhere((org) => org.orgLocalId == orgLocalId);
        return organization;
      } else {
        print('No Data in this chat');
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateOrganization(
      String orgId, Organization newOrg) async {
    final url =
        'https://borhanadmin.firebaseio.com/CharitableOrganizations/$orgId.json';
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
    notifyListeners();
  }

  Future<String> uploadImage(File image) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(image.path.split('/').last);
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    String _downloadUrl = await storageReference.getDownloadURL();
    return _downloadUrl;
  }

  Future deleteImage(String imgUrl) async {
    StorageReference myStorageReference =
        await FirebaseStorage.instance.getReferenceFromUrl(imgUrl);
    await myStorageReference.delete();
  }
}
