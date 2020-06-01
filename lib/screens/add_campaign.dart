import 'package:BorhanAdmin/models/campaign.dart';
import 'package:BorhanAdmin/providers/auth.dart';
import 'package:BorhanAdmin/providers/campaigns.dart';
import 'package:BorhanAdmin/providers/organizations_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../providers/campaigns.dart';
import '../models/campaign.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddCampaign extends StatefulWidget {
  static const routeName = '/add-Campaign';

  @override
  _AddCampaignState createState() => _AddCampaignState();
}

class _AddCampaignState extends State<AddCampaign> {
  String orgId = '';
  final _descFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _addCampaign = Campaign(
    id: null,
    campaignName: '',
    campaignDescription: '',
    imagesUrl: '',
    time: '',
  );
  var _isLoadImg = false;
  var _isInit = true;
  var _initValues = {
    'campName': '',
    'campDescription': '',
    'imgUrl': '',
    'time': '',
  };
  var _isLoading = false;
  File _image;
  String _downloadUrl;

  Future getImage() async {
    File img;
    img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = img;
      _isLoadImg = true;
    });

    Provider.of<Campaigns>(context, listen: false)
        .uploadImage(_image)
        .then((val) {
      _downloadUrl = val;
      setState(() {
        _isLoadImg = false;
      });
      print("value from upload" + _downloadUrl);
    });
  }
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _descFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    if (_addCampaign.imagesUrl != null && _addCampaign.imagesUrl != '') {
      print(
          '---------------------------- from delete image -----------------------------');
      print('Image Url : ' + _addCampaign.imagesUrl);
      Provider.of<Campaigns>(context, listen: false)
          .deleteImage(_addCampaign.imagesUrl);
    }
    print("---------------------------------------------");
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if (_addCampaign.id != null) {
      print("Campaign id :  " + _addCampaign.id);
      _addCampaign = Campaign(
        id: _addCampaign.id,
        imagesUrl: _downloadUrl != null ? _downloadUrl : _addCampaign.imagesUrl,
        campaignDescription: _addCampaign.campaignDescription,
        campaignName: _addCampaign.campaignName,
        time: _addCampaign.time,
      );
      print(_addCampaign.imagesUrl);
      Provider.of<Campaigns>(context, listen: false)
          .updateCampaign(_addCampaign.id, _addCampaign, orgId);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      _addCampaign = Campaign(
        id: _addCampaign.id,
        imagesUrl: _downloadUrl,
        campaignDescription: _addCampaign.campaignDescription,
        campaignName: _addCampaign.campaignName,
        time: _addCampaign.time,
      );
      print(_addCampaign.imagesUrl);
      try {
        await Provider.of<Campaigns>(context, listen: false)
            .addCampaign(_addCampaign, orgId);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('خطأ'),
            content: Text('حدث خطأ ما'),
            actions: <Widget>[
              FlatButton(
                child: Text('حسنا'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final data = Provider.of<Auth>(context);
      Provider.of<Organizations>(context)
          .fetchAndSetOrg(data.adminData.id)
          .then((value) => {
                orgId = value.id,
                print(orgId),
              });
      final campaignId = ModalRoute.of(context).settings.arguments as String;
      if (campaignId != null) {
        _addCampaign =
            Provider.of<Campaigns>(context, listen: false).findById(campaignId);
        _initValues = {
          'campName': _addCampaign.campaignName,
          'campDescription': _addCampaign.campaignDescription,
          'imgUrl': _addCampaign.imagesUrl,
          'time': _addCampaign.time,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        title: _addCampaign.id != null
            ? Text('تعديل الحملة')
            : Text('إضافة حملة جديدة'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: Colors.teal[100],
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'اسم الحمة',
                          textAlign: TextAlign.center,
                        ),
                        TextFormField(
                          textAlign: TextAlign.right,
                          initialValue: _initValues['campName'],
                          decoration: const InputDecoration(
                            hintText: 'مثال: حملة رمضان الخير',
                          ),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_descFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'من فضلك أدخل أسم للحملة';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _addCampaign = Campaign(
                              campaignName: value,
                              campaignDescription:
                                  _addCampaign.campaignDescription,
                              imagesUrl: _addCampaign.imagesUrl,
                              time: _addCampaign.time,
                              id: _addCampaign.id,
                            );
                          },
                        ),
                        Text(
                          'الوصف',
                          textAlign: TextAlign.center,
                        ),
                        TextFormField(
                          initialValue: _initValues['campDescription'],
                          textAlign: TextAlign.right,
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            hintText: 'حملة تساعد في اطعام المحتاجين',
                          ),
                          focusNode: _descFocusNode,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'من فضلك أدخل وصف للحملة';
                            }
                            if (value.length < 10) {
                              return 'الوصف يجب ألا يقل عن 10 أحرف';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _addCampaign = Campaign(
                              campaignName: _addCampaign.campaignName,
                              campaignDescription: value,
                              imagesUrl: _addCampaign.imagesUrl,
                              time: _addCampaign.time,
                              id: _addCampaign.id,
                            );
                          },
                        ),
                        Text(
                          'وقت الحملة',
                          textAlign: TextAlign.center,
                        ),
                        TextFormField(
                          textAlign: TextAlign.right,
                          initialValue: _initValues['time'],
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_descFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'من فضلك أدخل وقت للحملة';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _addCampaign = Campaign(
                              campaignName: _addCampaign.campaignName,
                              campaignDescription:
                                  _addCampaign.campaignDescription,
                              imagesUrl: _addCampaign.imagesUrl,
                              time: value,
                              id: _addCampaign.id,
                            );
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: _isLoadImg
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : newImage(),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: new RaisedButton(
                            textColor: Colors.white,
                            child: _addCampaign.id != null
                                ? Text('حفظ')
                                : Text('إضافة'),
                            color: Colors.teal,
                            onPressed: _saveForm,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget newImage() {
    return Center(
      child: Container(
        height: 300,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              RaisedButton(
                child: Text(
                  'اختيار صورة',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                color: Colors.teal,
                onPressed: () {
                  getImage();
                },
              ),
              _addCampaign.id != null && _image != null
                  ? Image.file(_image)
                  : _addCampaign.id != null &&
                          _addCampaign.imagesUrl != null //update
                      ? Image.network(_addCampaign.imagesUrl)
                      : _image == null
                          ? Container()
                          : Image.file(
                              _image,
                              height: 250,
                            ),
            ],
          ),
        ),
      ),
    );
  }
}
