import 'package:flutter/material.dart';
import '../models/donation_history.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryProvider with ChangeNotifier {

  List<History> _items = [];

  List<History> get items {
    return [..._items];
  }

  Future<void> fetchAndSetActivities(String orgId) async {
    final url = 'https://borhanadmin.firebaseio.com/DonationHistory/$orgId.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<History> loadedHistory = [];
      extractedData.forEach((historyId, historyData) {
        loadedHistory.add(History(
          id: historyId,
          donatorName: historyData['donatorName'],
          donatorMobile: historyData['donatorMobile'],
          donatorAddress: historyData['donatorAddress'],
          donationType: historyData['donationType'],
          donationItems: historyData['donationItems'],
          donationDate: historyData['donationDate'],
          donationAmount: historyData['donationAmount'],
          donationImage: historyData['donationImage'],
          orgName: historyData['OrganizationName'],
          actName: historyData['ActivityName'],
        ));
      });
      _items = loadedHistory;
      print(_items);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}