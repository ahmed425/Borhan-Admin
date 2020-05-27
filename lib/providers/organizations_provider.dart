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
      String id, Organization newOrg, LocationData currentLocation) async {
    print(
        "  Current Address is   :  ${currentLocation.longitude}+${currentLocation.latitude}");
    final address = await LocationHelper.getPlaceAddress(
        currentLocation.latitude, currentLocation.longitude);
    final url =
        'https://borhanadmin.firebaseio.com/CharitableOrganizations/-M7m8Gs9EitK0NIqAC-Y.json';
    print("  Current Address is   :  $address");

    await http.patch(url,
        body: json.encode({
          'orgName': newOrg.orgName,
          'logo': newOrg.logo,
          'address': address,
          'description': newOrg.description,
          'licenseNo': newOrg.licenseNo,
          'landLineNo': newOrg.landLineNo,
          'mobileNo': newOrg.mobileNo,
          'bankAccounts': newOrg.bankAccounts,
          'webPage': newOrg.webPage,
        }));
    notifyListeners();
  }

  Future<void> updateOrgWithSelectedLocation(
      String id, Organization newOrg, PlaceLocation pickedLocation) async {
    print(
        "  pickedLocation Address is   :  ${pickedLocation.longitude}+${pickedLocation.latitude}");
    final address = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);
    final url =
        'https://borhanadmin.firebaseio.com/CharitableOrganizations/-M7m8Gs9EitK0NIqAC-Y.json';
    print("  pickedLocation Address is   :  $address");

    await http.patch(url,
        body: json.encode({
          'orgName': newOrg.orgName,
          'logo': newOrg.logo,
          'address': address,
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
    print("in upload");
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(image.path.split('/').last);
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    print('File Uploaded');
    String _downloadUrl = await storageReference.getDownloadURL();
    print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
        '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    print("from uploading :  " + _downloadUrl);
    return _downloadUrl;
  }

  Future deleteImage(String imgUrl) async {
    print("From Delete Image");
    StorageReference myStorageReference =
        await FirebaseStorage.instance.getReferenceFromUrl(imgUrl);
    print(myStorageReference.path);
    await myStorageReference.delete();
    print("image deleted successfully");
  }
}
