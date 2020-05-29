import 'dart:io';
import '../models/donation_request.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DonationRequests with ChangeNotifier {
  List<DonationRequest> _donationRequests = [];

  List<DonationRequest> get donationRequests {
    print(_donationRequests);
    return [..._donationRequests];
  }

  DonationRequest findById(String id) {
    // ignore: non_constant_identifier_names
    return _donationRequests.firstWhere((request) => request.id == id);
  }

  Future<void> fetchAndSetProducts(String orgId) async {
    final url = 'https://borhanadmin.firebaseio.com/DonationRequests/$orgId.json';
    try {
      print("from fetch req");
      print(_donationRequests);
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
//      print(extractedData);
      final List<DonationRequest> loadedRequests = [];
      if (extractedData != null) {
        extractedData.forEach((prodId, donationData) {
          loadedRequests.add(DonationRequest(
              id: prodId,
              donatorName: donationData['donatorName'],
              donatorMobileNo: donationData['donatorMobile'],
              donationDate: donationData['donationDate'],
              donationType: donationData['donationType'],
              donationItems: donationData['donationItems'],
              donatorAddress: donationData['donatorAddress'],
              donationAmount: donationData['donationAmount'],
              availableOn: donationData['availableOn'],
              actName: donationData['activityName'],
              image: donationData['donationImage']));
        });

        _donationRequests = loadedRequests;
        print("id is ${_donationRequests[0].id}");
        print("id is ${_donationRequests[0].donatorName}");
        notifyListeners();
      } else {
        print("no requests");
      }
    } catch (error) {
      throw (error);
//      print("error is $error");
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> addDonationReq(DonationRequest donationReq,String orgId) async {
    final url = 'https://borhanadmin.firebaseio.com/DonationHistory/$orgId.json';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "donationDate": donationReq.donationDate,
            "donationAmount": donationReq.donationAmount,
            "donationImage": donationReq.image,
            "donationItems": donationReq.donationItems,
            "donationType": donationReq.donationType,
            "donatorAddress": donationReq.donatorAddress,
            "donatorMobile": donationReq.donatorMobileNo,
            "donatorName": donationReq.donatorName,
            "organizationName": donationReq.orgName,
            "activityName": donationReq.actName
          },
        ),
      );
//      final newCampaign = DonationRequest(
//        id: json.decode(response.body)['name'],
//        donatorName: campaign.donatorName,
//        donationItems: campaign.donationItems,
//        image: campaign.image,
//        donationDate: campaign.donationDate,
//      );
//      _donationRequests.add(newCampaign);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteRequest(String id,String orgId) async {
    final url = 'https://borhanadmin.firebaseio.com/DonationRequests/$orgId/$id.json';
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
//    existingProduct = null;
  }
}