import 'dart:io';

import 'package:BorhanAdmin/models/place.dart';
import 'package:BorhanAdmin/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../models/organization.dart';
import '../providers/organizations_logic.dart';

class EditOrganizationScreen extends StatefulWidget {
  @override
  _EditOrganizationScreenState createState() => _EditOrganizationScreenState();
}

class _EditOrganizationScreenState extends State<EditOrganizationScreen> {
  // final _myFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  PlaceLocation _pickedLocation;
  PlaceLocation _currentLocation;
  var _editedOrg = Organization(
    id: '1',
    orgName: '',
    logo: '',
    address: '',
    description: '',
    licenseNo: '',
    landLineNo: '',
    mobileNo: '',
    bankAccounts: '',
  );
  File _image;
  String _downloadUrl;
  var _isLoading = false;
  var _isLoadImg = false;

  Future getImage() async {
    File img;
    img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = img;
      _isLoadImg = true;
    });

    Provider.of<Organizations>(context, listen: false)
        .uploadImage(_image)
        .then((val) {
      _downloadUrl = val;
      setState(() {
        _isLoadImg = false;
      });
      print("value from upload" + _downloadUrl);
    });
  }

  Future<void> _saveForm() async {
    PlaceLocation myCurrentLocation;
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {});
    if (_editedOrg.id != null) {
      final currentLocData =
          await Provider.of<Organizations>(context, listen: false)
              .getTheCurrentUserLocation();
      Provider.of<Organizations>(context, listen: false)
          .deleteImage(_downloadUrl);
      print(
          "loca is : ${currentLocData.longitude} + ${currentLocData.latitude}");
      // _currentLocation.longitude=LocationInput.
//      myCurrentLocation.latitude = currentLocData.latitude;
//      myCurrentLocation.longitude = currentLocData.longitude;
      if (currentLocData.longitude != null && currentLocData.latitude != null) {
        print("Current Location is not Null");
        await Provider.of<Organizations>(context, listen: false)
            .updateOrgWithCurrentLocation(
                _editedOrg.id, _editedOrg, currentLocData);
      } else {
//        print("select on map");
        await Provider.of<Organizations>(context, listen: false)
            .updateOrgWithSelectedLocation(
                _editedOrg.id, _editedOrg, _pickedLocation);
      }
      Toast.show("تم حفظ البيانات بنجاح", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  void _selectPlace(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
    print(_pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل بيانات الجمعية'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
              Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0, 1],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'اسم الجمعية'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'يرجي ملأ هذا الحقل';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      _editedOrg = Organization(
                        id: _editedOrg.id,
                        orgName: value,
                        logo: _downloadUrl,
                        address: _editedOrg.address,
                        description: _editedOrg.description,
                        licenseNo: _editedOrg.licenseNo,
                        landLineNo: _editedOrg.landLineNo,
                        mobileNo: _editedOrg.mobileNo,
                        bankAccounts: _editedOrg.bankAccounts,
                        webPage: _editedOrg.webPage,
                      );
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'عنوان الجمعية'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'يرجي ملأ هذا الحقل';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      _editedOrg = Organization(
                        id: _editedOrg.id,
                        orgName: _editedOrg.orgName,
                        logo: _downloadUrl,
                        address: value,
                        description: _editedOrg.description,
                        licenseNo: _editedOrg.licenseNo,
                        landLineNo: _editedOrg.landLineNo,
                        mobileNo: _editedOrg.mobileNo,
                        bankAccounts: _editedOrg.bankAccounts,
                        webPage: _editedOrg.webPage,
                      );
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'نبذة عن الجمعية'),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'يرجي ملأ هذا الحقل';
                      }
                      if (value.length < 10) {
                        return 'يجب ألا يقل عن 10 أحرف';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedOrg = Organization(
                        id: _editedOrg.id,
                        orgName: _editedOrg.orgName,
                        logo: _downloadUrl,
                        address: _editedOrg.address,
                        description: value,
                        licenseNo: _editedOrg.licenseNo,
                        landLineNo: _editedOrg.landLineNo,
                        mobileNo: _editedOrg.mobileNo,
                        bankAccounts: _editedOrg.bankAccounts,
                        webPage: _editedOrg.webPage,
                      );
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'رقم الرخصة'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'يرجي ملأ هذا الحقل';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedOrg = Organization(
                        id: _editedOrg.id,
                        orgName: _editedOrg.orgName,
                        logo: _downloadUrl,
                        address: _editedOrg.address,
                        description: _editedOrg.description,
                        licenseNo: value,
                        landLineNo: _editedOrg.landLineNo,
                        mobileNo: _editedOrg.mobileNo,
                        bankAccounts: _editedOrg.bankAccounts,
                        webPage: _editedOrg.webPage,
                      );
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'رقم الهاتف الأرضي'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'يرجي ملأ هذا الحقل';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      _editedOrg = Organization(
                        id: _editedOrg.id,
                        orgName: _editedOrg.orgName,
                        logo: _downloadUrl,
                        address: _editedOrg.address,
                        description: _editedOrg.description,
                        licenseNo: _editedOrg.licenseNo,
                        landLineNo: value,
                        mobileNo: _editedOrg.mobileNo,
                        bankAccounts: _editedOrg.bankAccounts,
                        webPage: _editedOrg.webPage,
                      );
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'رقم الموبايل '),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'يرجي ملأ هذا الحقل';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      _editedOrg = Organization(
                        id: _editedOrg.id,
                        orgName: _editedOrg.orgName,
                        logo: _downloadUrl,
                        address: _editedOrg.address,
                        description: _editedOrg.description,
                        licenseNo: _editedOrg.licenseNo,
                        landLineNo: _editedOrg.landLineNo,
                        mobileNo: value,
                        bankAccounts: _editedOrg.bankAccounts,
                        webPage: _editedOrg.webPage,
                      );
                    },
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'تفاصيل الحساب البنكي '),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'يرجي ملأ هذا الحقل';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      _editedOrg = Organization(
                        id: _editedOrg.id,
                        orgName: _editedOrg.orgName,
                        logo: _downloadUrl,
                        address: _editedOrg.address,
                        description: _editedOrg.description,
                        licenseNo: _editedOrg.licenseNo,
                        landLineNo: _editedOrg.landLineNo,
                        mobileNo: _editedOrg.mobileNo,
                        bankAccounts: value,
                        webPage: _editedOrg.webPage,
                      );
                    },
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'رابط صفحة الإنترنت'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'يرجي ملأ هذا الحقل';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      _editedOrg = Organization(
                        id: _editedOrg.id,
                        orgName: _editedOrg.orgName,
                        logo: _downloadUrl,
                        address: _editedOrg.address,
                        description: _editedOrg.description,
                        licenseNo: _editedOrg.licenseNo,
                        landLineNo: _editedOrg.landLineNo,
                        mobileNo: _editedOrg.mobileNo,
                        bankAccounts: _editedOrg.bankAccounts,
                        webPage: value,
                      );
                    },
                  ),
                  Container(
                    child: newImage(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  LocationInput(_selectPlace),
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
        height: 200,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              RaisedButton(
                child: Text('إختيار صورة'),
                onPressed: () {
                  getImage();
                },
              ),
              _editedOrg.id != null && _image != null
                  ? Image.file(_image)
                  : _editedOrg.id != null && _downloadUrl != null //update
                      ? Image.network(_downloadUrl)
                      : _image == null
                          ? Container()
                          : Image.file(
                              _image,
                              fit: BoxFit.contain,
                            ),
            ],
          ),
        ),
      ),
    );
  }
}
