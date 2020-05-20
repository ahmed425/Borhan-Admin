import 'dart:io';
import 'package:BorhanAdmin/models/campaign.dart';
import 'package:BorhanAdmin/models/donation_request.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/campaign.dart';

class DonationRequests with ChangeNotifier {
  List<DonationRequest> _donationRequests = [];

  List<DonationRequest> get donationRequests {
//    print("List of donations are: ");
    print(_donationRequests);
    return [..._donationRequests];
  }

  DonationRequest findById(String id) {
    // ignore: non_constant_identifier_names
    return _donationRequests.firstWhere((request) => request.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    const url = 'https://borhanadmin.firebaseio.com/DonationRequests.json';
    try {
      print("vghvghvghvggh");
      print(_donationRequests);
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
//      print(extractedData);
      final List<DonationRequest> loadedRequests = [];
      extractedData.forEach((prodId, prodData) {
        loadedRequests.add(DonationRequest(
            id: prodId,
            donatorName: prodData['DonatorName'],
            donatorMobileNo: prodData['DonationMobileNo'],
            donationDate: prodData['DonationDate'],
            donationType: prodData['DonationType'],
            donationItems: prodData['DonatorItems'],
            donatorAddress: prodData['DonatorAddress'],
            donationAmount: prodData['DonationAmount'],
            availableOn: prodData['AvailableOn'],
            image: prodData['Image']));
      });
      _donationRequests = loadedRequests;
      print("id is ${_donationRequests[0].id}");
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> addCampaign(DonationRequest campaign) async {
    const url = 'https://borhanadmin.firebaseio.com/DonationHistory.json';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "donationDate": campaign.donationDate,
            "donationImage":
                "https://www.albawabhnews.com/upload/photo/news/382/8/600x338o/299.jpg?q=1",
            "donationItem": campaign.donationItems,
            "donationType": "عيني",
            "donatorAddress": "سيدي بشر",
            "donatorMobile": "01001159966",
            "donatorName": "آيه فتحي"
//            'id': campaign.campaignName,
//            'donation': campaign.campaignDescription,
//            'image': campaign.imagesUrl,
//            'time': campaign.time,
          },
        ),
      );
      final newCampaign = DonationRequest(
        id: json.decode(response.body)['name'],
        donatorName: campaign.donatorName,
        donationItems: campaign.donationItems,
        image: campaign.image,
        donationDate: campaign.donationDate,
      );
      _donationRequests.add(newCampaign);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

//  Future<void> updateCampaign(String id, Campaign newCampaign) async {
//    final campaignIndex =
//        _donationRequests.indexWhere((campaign) => campaign.id == id);
//    if (campaignIndex >= 0) {
//      final url =
//          'https://borhanadmin.firebaseio.com/donationRequests/$id.json';
//      await http.patch(url,
//          body: json.encode({
//            'name': newCampaign.campaignName,
//            'description': newCampaign.campaignDescription,
//            'image': newCampaign.imagesUrl,
//            'time': newCampaign.time,
//          }));
//      _donationRequests[campaignIndex] = newCampaign;
//      notifyListeners();
//    } else {
//      print('...');
//    }
//  }

//  Future<void> deleteRequest(String id) async {
//    print("id is $id");
//    final url = 'https://borhanadmin.firebaseio.com/DonationRequests/$id.json';
//    final existingProductIndex =
//        _donationRequests.indexWhere((prod) => prod.id == id);
//    var existingProduct = _donationRequests[existingProductIndex];
//    _donationRequests.removeWhere((campaign) => campaign.id == id);
//    notifyListeners();
//    final response = await http.delete(url);
//    print("delete response ${response.statusCode}");
//    if (response.statusCode >= 400) {
//      _donationRequests.insert(existingProductIndex, existingProduct);
//      notifyListeners();
//      throw HttpException('Could not delete product.');
//    }
//    print("request deleted successfully");
////    existingProduct = null;
//  }

  Future<void> deleteRequest(String id) async {
    final url = 'https://borhanadmin.firebaseio.com/DonationRequests/$id.json';
    final existingProductIndex =
        _donationRequests.indexWhere((prod) => prod.id == id);
    var existingProduct = _donationRequests[existingProductIndex];
    _donationRequests.removeWhere((campaign) => campaign.id == id);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _donationRequests.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    print("deleted successfully");
    print(response.statusCode);
    existingProduct = null;
  }

//  Future<String> uploadImage(File image) async {
//    print("in upload");
//    StorageReference storageReference =
//        FirebaseStorage.instance.ref().child(image.path.split('/').last);
//    StorageUploadTask uploadTask = storageReference.putFile(image);
//    await uploadTask.onComplete;
//    print('File Uploaded');
//    String _downloadUrl = await storageReference.getDownloadURL();
//    print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
//        '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
//    print("from uploading :  " + _downloadUrl);
//    return _downloadUrl;
//  }

//  Future deleteImage(String imgUrl) async {
//    print("From Delete Image");
//    StorageReference myStorageReference =
//        await FirebaseStorage.instance.getReferenceFromUrl(imgUrl);
//    print(myStorageReference.path);
//    await myStorageReference.delete();
//    print("image deleted successfully");
//  }
}

//    Campaign(
//      campaignName: 'كساء',
//      campaignDescription: 'clothes',
//    ),
//    Campaign(
//      campaignName: 'كفالة اليتيم',
//      campaignDescription: 'clothes',
//    ),
//    Campaign(
//      campaignName: 'اطعام',
//      campaignDescription: 'clothes',
//    ),

//import 'dart:io';
//import '../models/donationRequest.dart';
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';
//
//class DonationRequests with ChangeNotifier {
//  List<DonationRequest> _donationRequests = [];
//
//  List<DonationRequest> get donationRequests {
//    print("from get");
//    print(_donationRequests);
//    return [..._donationRequests];
//  }
//
//  // Campaign findById(String id) {
//  //   // ignore: non_constant_identifier_names
//  //   return _donationRequests.firstWhere((campaign) => campaign.id == id);
//  // }
//
//  Future<void> fetchAndSetRequests() async {
//    const url = 'https://borhanadmin.firebaseio.com/DonatationRequests.json';
//    try {
//      final response = await http.get(url);
//      final extractedData = json.decode(response.body) as Map<String, dynamic>;
//      final List<DonationRequest> loadedRequests = [];
//      extractedData.forEach((prodId, prodData) {
//        loadedRequests.add(DonationRequest(
//            donationType: prodData['donationType'],
//            donatorName: prodData['donatorName'],
//            donatorAddress: prodData['donatorAddress'],
//            donationItems: prodData['donatorItems'],
//            donationAmount: prodData['donationAmount'],
//            donationDate: prodData['donationDate'],
//            availableOn: prodData['availableOn'],
//            image: prodData['image']));
//      });
//      _donationRequests = loadedRequests;
//      notifyListeners();
//    } catch (error) {
//      throw (error);
//    }
//  }
//}
//// ignore: non_constant_identifier_names
//// Future<void> addCampaign(Campaign campaign) async {
////   const url = 'https://borhanadmin.firebaseio.com/donationRequests.json';
////   try {
////     final response = await http.post(
////       url,
////       body: json.encode(
////         {
////           'name': campaign.campaignName,
////           'description': campaign.campaignDescription,
////           'image': campaign.imagesUrl,
////           'time': campaign.time,
////         },
////       ),
////     );
////     final newCampaign = Campaign(
////       id: json.decode(response.body)['name'],
////       campaignName: campaign.campaignName,
////       campaignDescription: campaign.campaignDescription,
////       imagesUrl: campaign.imagesUrl,
////       time: campaign.time,
////     );
////     _donationRequests.add(newCampaign);
////     notifyListeners();
////   } catch (error) {
////     print(error);
////     throw error;
////   }
//// }
//
//// Future<void> updateCampaign(String id, Campaign newCampaign) async {
////   final campaignIndex =
////       _donationRequests.indexWhere((campaign) => campaign.id == id);
////   if (campaignIndex >= 0) {
////     final url = 'https://borhanadmin.firebaseio.com/donationRequests/$id.json';
////     await http.patch(url,
////         body: json.encode({
////           'name': newCampaign.campaignName,
////           'description': newCampaign.campaignDescription,
////           'image': newCampaign.imagesUrl,
////           'time': newCampaign.time,
////         }));
////     _donationRequests[campaignIndex] = newCampaign;
////     notifyListeners();
////   } else {
////     print('...');
////   }
//// }
//
//// Future<void> deleteCampaign(String id) async {
////   final url = 'https://borhanadmin.firebaseio.com/donationRequests/$id.json';
////   final existingProductIndex = _donationRequests.indexWhere((prod) => prod.id == id);
////   var existingProduct = _donationRequests[existingProductIndex];
////   _donationRequests.removeWhere((campaign) => campaign.id == id);
////   notifyListeners();
////   final response = await http.delete(url);
////   if (response.statusCode >= 400) {
////     _donationRequests.insert(existingProductIndex, existingProduct);
////     notifyListeners();
////     throw HttpException('Could not delete product.');
////   }
////   existingProduct = null;
//// }
//
////   Future<String> uploadImage(File image) async {
////     print("in upload");
////     StorageReference storageReference =
////         FirebaseStorage.instance.ref().child(image.path.split('/').last);
////     StorageUploadTask uploadTask = storageReference.putFile(image);
////     await uploadTask.onComplete;
////     print('File Uploaded');
////     String _downloadUrl = await storageReference.getDownloadURL();
////     print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
////         '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
////     print("from uploading :  " + _downloadUrl);
////     return _downloadUrl;
////   }
//
////   Future deleteImage(String imgUrl) async {
////     print("From Delete Image");
////     StorageReference myStorageReference =
////         await FirebaseStorage.instance.getReferenceFromUrl(imgUrl);
////     print(myStorageReference.path);
////     await myStorageReference.delete();
////     print("image deleted successfully");
////   }
//// }
//
////    Campaign(
////      campaignName: 'كساء',
////      campaignDescription: 'clothes',
////    ),
////    Campaign(
////      campaignName: 'كفالة اليتيم',
////      campaignDescription: 'clothes',
////    ),
////    Campaign(
////      campaignName: 'اطعام',
////      campaignDescription: 'clothes',
////    ),
