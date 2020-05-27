import 'dart:io';
import 'package:BorhanAdmin/models/campaign.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/campaign.dart';

class Campaigns with ChangeNotifier {
  List<Campaign> _campaigns = [];

  List<Campaign> get campaigns {
    print(_campaigns);
    return [..._campaigns];
  }

  Campaign findById(String id) {
    // ignore: non_constant_identifier_names
    return _campaigns.firstWhere((campaign) => campaign.id == id);
  }

  Future<void> fetchAndSetProducts(String orgId) async {
    final url = 'https://borhanadmin.firebaseio.com/Campaigns/$orgId.json';
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
  Future<void> addCampaign(Campaign campaign,String orgId) async {
    final url = 'https://borhanadmin.firebaseio.com/Campaigns/$orgId.json';
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

  Future<void> updateCampaign(String id, Campaign newCampaign,String orgId) async {
    final campaignIndex =
        _campaigns.indexWhere((campaign) => campaign.id == id);
    if (campaignIndex >= 0) {
      final url = 'https://borhanadmin.firebaseio.com/Campaigns/$orgId/$id.json';
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

  Future<void> deleteCampaign(String id,String orgId) async {
    final url = 'https://borhanadmin.firebaseio.com/Campaigns/$orgId/$id.json';
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
