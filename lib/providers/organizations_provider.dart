import 'dart:convert';
import 'dart:io';
import 'package:BorhanAdmin/models/place.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:location/location.dart';

import '../models/organization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../helpers/location_helper.dart';

class Organizations with ChangeNotifier {
  List<Organization> _items = [];

  List<Organization> get items {
    return [..._items];
  }

  Organization findById(String id) {
    var organization = _items.firstWhere((org) => org.orgLocalId == id);
    print("from find  " + organization.toString());
    return organization;
  }

  Organization findByOrgId(String orgId) {
    var organization = _items.firstWhere((org) => org.id == orgId);
    print("from find  " + organization.toString());
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
        print('from fetch extracted data' + extractedData.toString());
        extractedData.forEach((autoOrgId, orgData) {
          print("ID" + autoOrgId);
          print(orgData);
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
        print("from fetch  " + _items.toString());
        print("from fetch  " + _items[1].id);
        print("from fetch  " + _items[1].orgName);
        print("orgLocalId" + orgId);
        notifyListeners();
        var organization = _items.firstWhere((org) => org.id == orgId);
        print("from fetch Organization  " + organization.id);
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
//        print('from fetch extracted data' + extractedData.toString());
        extractedData.forEach((autoOrgId, orgData) {
//          print("ID" + autoOrgId);
//          print(orgData);
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
//        print("from fetch  " + _items.toString());
//        print("from fetch  " + _items[1].id);
//        print("from fetch  " + _items[1].orgName);
//        print("orgLocalId" + orgLocalId);
        notifyListeners();
        var organization =
            _items.firstWhere((org) => org.orgLocalId == orgLocalId);
//        print("from fetch Organization  " + organization.id);
        return organization;
      } else {
        print('No Data in this chat');
      }
    } catch (error) {
      throw (error);
    }
  }

  /*
  * for (int i = 0; i < loadedOrganizations.length; i++) {
        if (loadedOrganizations[i].orgLocalId == orgId) {
          _item = loadedOrganizations[i];
          notifyListeners();
        }
      }*/

  Future<LocationData> getTheCurrentUserLocation() async {
    final locData = await Location().getLocation();
    // final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
    //   latitude: locData.latitude,
    //   longitude: locData.longitude,
    // );
    // setState(() {
    //   _previewImageUrl = staticMapImageUrl;
    // });
    // widget.onSelectPlace(locData.latitude, locData.longitude);
    return locData;
  }

  Future<void> updateOrgWithCurrentLocation(
      String orgId, Organization newOrg, LocationData currentLocation) async {
//    print("  Current Address is   :  ${currentLocation.longitude}+${currentLocation.latitude}");
//    final address = currentLocation.longitude+currentLocation.latitude;
//    await LocationHelper.getPlaceAddress(currentLocation.latitude, currentLocation.longitude);
    final url =
        'https://borhanadmin.firebaseio.com/CharitableOrganizations/$orgId.json';
//    print("  Current Address is   :  $address");
//    print('befor update logo from provider');
//    print(newOrg.logo);
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

//  Future<void> updateOrgWithSelectedLocation(
//      String id, Organization newOrg, PlaceLocation pickedLocation) async {
//    print(
//        "  pickedLocation Address is   :  ${pickedLocation.longitude}+${pickedLocation.latitude}");
//    final address = await LocationHelper.getPlaceAddress(
//        pickedLocation.latitude, pickedLocation.longitude);
//    final url =
//        'https://borhanadmin.firebaseio.com/CharitableOrganizations/-M7m8Gs9EitK0NIqAC-Y.json';
//    print("  pickedLocation Address is   :  $address");
//
//    await http.patch(url,
//        body: json.encode({
//          'orgName': newOrg.orgName,
//          'logo': newOrg.logo,
//          'address': address,
//          'description': newOrg.description,
//          'licenseNo': newOrg.licenseNo,
//          'landLineNo': newOrg.landLineNo,
//          'mobileNo': newOrg.mobileNo,
//          'bankAccounts': newOrg.bankAccounts,
//          'webPage': newOrg.webPage,
//        }));
//    notifyListeners();
//  }

  Future<String> uploadImage(File image) async {
    print("in upload");
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(image.path.split('/').last);
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    print('File Uploaded');
    String _downloadUrl = await storageReference.getDownloadURL();
//    print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
//        '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
//    print("from uploading :  " + _downloadUrl);
    return _downloadUrl;
  }

  Future deleteImage(String imgUrl) async {
    print("From Delete Image");
    StorageReference myStorageReference =
        await FirebaseStorage.instance.getReferenceFromUrl(imgUrl);
//    print(myStorageReference.path);
    await myStorageReference.delete();
    print("image deleted successfully");
  }
}
