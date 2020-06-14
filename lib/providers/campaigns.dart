import 'dart:io';
import 'package:BorhanAdmin/models/campaign.dart';
import 'package:BorhanAdmin/providers/organizations_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/campaign.dart';

class Campaigns with ChangeNotifier {
  Organizations orgData = new Organizations();
  List<Campaign> _campaigns = [];

  List<Campaign> get campaigns {
    return [..._campaigns];
  }

  Campaign findById(String id) {
    return _campaigns.firstWhere((campaign) => campaign.id == id);
  }

  Future<void> fetchAndSetProducts(String orgId) async {
    final url = 'https://borhanadmin.firebaseio.com/AdminCampaigns/$orgId.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Campaign> loadedCampaigns = [];
      if (extractedData != null) {
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
      } else {
        print('No Data in this chat');
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addAdminCampaign(Campaign campaign, String orgId) async {
    if (campaign.imagesUrl == null) {
      campaign = Campaign(
        campaignName: campaign.campaignName,
        campaignDescription: campaign.campaignDescription,
        imagesUrl: 'https://ibb.co/VL1Bfh6',
        time: campaign.time,
      );
    }
    final adminUrl =
        'https://borhanadmin.firebaseio.com/AdminCampaigns/$orgId.json';
    try {
      final response = await http.post(
        adminUrl,
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
      updateUserCampaign(newCampaign.id, newCampaign, orgId);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateUserCampaign(
      String id, Campaign newCampaign, String orgId) async {
    final orgName = await orgData.fetchAndSetOrgName(orgId);

    if (newCampaign.imagesUrl == null) {
      newCampaign = Campaign(
        campaignName: newCampaign.campaignName,
        campaignDescription: newCampaign.campaignDescription,
        imagesUrl: 'https://ibb.co/VL1Bfh6',
        time: newCampaign.time,
      );
    }
    final userUrl = 'https://borhanadmin.firebaseio.com/Campaigns/$id.json';
    await http.patch(userUrl,
        body: json.encode({
          'name': newCampaign.campaignName,
          'description': newCampaign.campaignDescription,
          'image': newCampaign.imagesUrl,
          'time': newCampaign.time,
          'orgId': orgId,
          'orgName': orgName,
        }));
    notifyListeners();
  }

  Future<void> updateCampaign(
      String id, Campaign newCampaign, String orgId) async {
    final orgName = await orgData.fetchAndSetOrgName(orgId);

    final campaignIndex =
        _campaigns.indexWhere((campaign) => campaign.id == id);
    if (campaignIndex >= 0) {
      final url =
          'https://borhanadmin.firebaseio.com/AdminCampaigns/$orgId/$id.json';
      final userUrl = 'https://borhanadmin.firebaseio.com/Campaigns/$id.json';
      await http.patch(userUrl,
          body: json.encode({
            'name': newCampaign.campaignName,
            'description': newCampaign.campaignDescription,
            'image': newCampaign.imagesUrl,
            'time': newCampaign.time,
            'orgId': orgId,
            'orgName': orgName,
          }));
      await http.patch(url,
          body: json.encode({
            'name': newCampaign.campaignName,
            'description': newCampaign.campaignDescription,
            'image': newCampaign.imagesUrl,
            'time': newCampaign.time,
          }));
      _campaigns[campaignIndex] = newCampaign;
      notifyListeners();
    }
  }

  Future<void> deleteAdminCampaign(String id, String orgId) async {
    final url =
        'https://borhanadmin.firebaseio.com/AdminCampaigns/$orgId/$id.json';
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
    deleteUserCampaign(id);
  }

  Future<void> deleteUserCampaign(String id) async {
    final userUrl = 'https://borhanadmin.firebaseio.com/Campaigns/$id.json';
    notifyListeners();
    final response = await http.delete(userUrl);
    if (response.statusCode >= 400) {
      notifyListeners();
      throw HttpException('Could not delete from user app.');
    }
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
