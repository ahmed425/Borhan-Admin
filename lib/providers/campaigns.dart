import 'dart:io';
import 'package:BorhanAdmin/models/campaign.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/campaign.dart';

class Campaigns with ChangeNotifier {
  List<Campaign> _campaigns = [];

  List<Campaign> get campaigns {
    return [..._campaigns];
  }

  Campaign findById(String id) {
    // ignore: non_constant_identifier_names
    return _campaigns.firstWhere((campaign) => campaign.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    const url = 'https://borhanadmin.firebaseio.com/Campaigns.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Campaign> loadedCampaigns = [];
      extractedData.forEach((prodId, prodData) {
        loadedCampaigns.add(Campaign(
          id: prodId,
          campaignName: prodData['name'],
          campaignDescription: prodData['description'],
          imagesUrl: prodData['image'],
          time: prodData['time'],
        ));
      });
      _campaigns = loadedCampaigns;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> addCampaign(Campaign campaign) async {
    const url = 'https://borhanadmin.firebaseio.com/Campaigns.json';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'name': campaign.campaignName,
            'description': campaign.campaignDescription,
            'image': campaign.imagesUrl,
            'time': campaign.time,
          },
        ),
      );
      final newCampaign = Campaign(
        id: json.decode(response.body)['name'],
        campaignName: campaign.campaignName,
        campaignDescription: campaign.campaignDescription,
        imagesUrl: campaign.imagesUrl,
        time: campaign.time,
      );
      _campaigns.add(newCampaign);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateCampaign(String id, Campaign newCampaign) async {
    final campaignIndex =
        _campaigns.indexWhere((campaign) => campaign.id == id);
    if (campaignIndex >= 0) {
      final url = 'https://borhanadmin.firebaseio.com/Campaigns/$id.json';
      await http.patch(url,
          body: json.encode({
            'name': newCampaign.campaignName,
            'description': newCampaign.campaignDescription,
            'image': newCampaign.imagesUrl,
            'time': newCampaign.time,
          }));
      _campaigns[campaignIndex] = newCampaign;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteCampaign(String id) async {
    final url = 'https://borhanadmin.firebaseio.com/Campaigns/$id.json';
    final existingProductIndex = _campaigns.indexWhere((prod) => prod.id == id);
    var existingProduct = _campaigns[existingProductIndex];
    _campaigns.removeWhere((campaign) => campaign.id == id);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _campaigns.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
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
