import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/organization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Organizations with ChangeNotifier {
  Future<void> updateOrg(String id, Organization newOrg) async {
    final url =
        'https://borhanadmin.firebaseio.com/CharitableOrganizations/-M7m8Gs9EitK0NIqAC-Y.json';
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
