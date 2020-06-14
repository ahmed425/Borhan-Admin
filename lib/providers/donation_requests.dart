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
    return _donationRequests.firstWhere((request) => request.id == id);
  }

  Future<void> fetchAndSetProducts(String orgId) async {
    final url =
        'https://borhanadmin.firebaseio.com/DonationRequests/$orgId.json';
    try {
      print("from fetch req orgid " + orgId);
      print(_donationRequests);
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<DonationRequest> loadedRequests = [];
      if (extractedData != null) {
        extractedData.forEach((prodId, donationData) {
          loadedRequests.add(DonationRequest(
              id: prodId,
              userId: donationData['userId'],
              status: donationData['status'],
              orgName: donationData['organizationName'],
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
        print("from fetch id is ${_donationRequests[0].id}");
        print("from fetch id is ${_donationRequests[0].donatorName}");
        notifyListeners();
      } else {
        print("no requests");
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addDonationReqInHistory(DonationRequest donationReq, String orgId) async {
    final url =
        'https://borhanadmin.firebaseio.com/DonationHistory/$orgId.json';
    try {
      await http.post(
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
            "activityName": donationReq.actName,
            "userId": donationReq.userId,
            "status": donationReq.status,
            "orgName": donationReq.orgName,
          },
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteRequest(String id, String orgId) async {
    final url =
        'https://borhanadmin.firebaseio.com/DonationRequests/$orgId/$id.json';
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
    print(response.statusCode);
  }

  Future<void> updateInMyDonation(
      String userId, DonationRequest donationReq) async {
    final reqIndex =
    _donationRequests.indexWhere((request) => request.id == donationReq.id);
    if (reqIndex >= 0) {
      var id = donationReq.id;
      final url =
          'https://borhanadmin.firebaseio.com/MyDonations/$userId/$id.json';
      await http.patch(url,
          body: json.encode({
            "userId": donationReq.userId,
            "status": donationReq.status,
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
          }));
      _donationRequests[reqIndex] = donationReq;
      notifyListeners();
    }
  }

  Future<void> updateDonationReq(
      DonationRequest donationReq, String orgId) async {
    final reqIndex =
    _donationRequests.indexWhere((request) => request.id == donationReq.id);
    if (reqIndex >= 0) {
      var reqId = donationReq.id;
      final url =
          'https://borhanadmin.firebaseio.com/DonationRequests/$orgId/$reqId.json';
      await http.patch(url,
          body: json.encode({
            "userId": donationReq.userId,
            "status": donationReq.status,
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
          }));
      _donationRequests[reqIndex] = donationReq;
      notifyListeners();
    }
  }
}
