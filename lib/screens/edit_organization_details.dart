import 'dart:io';

import 'package:BorhanAdmin/models/place.dart';
import 'package:BorhanAdmin/providers/auth.dart';
import 'package:BorhanAdmin/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../models/organization.dart';
import '../providers/organizations_provider.dart';

class EditOrganizationScreen extends StatefulWidget {
  static const routName = '/editOrg';

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
    id: null,
    orgName: '',
    logo: '',
    address: '',
    description: '',
    licenseNo: '',
    landLineNo: '',
    mobileNo: '',
    bankAccounts: '',
    orgLocalId: '',
    webPage: '',
  );
  var orgLocalId = '';
  File _image;
  String _downloadUrl;
  var _isLoading = false;
  var _isLoadImg = false;
  var _isInit = true;
  var _initValues = {
    'webPage': '',
    'orgLocalId': '',
    'address': '',
    'bankAccounts': '',
    'description': '',
    'landLineNo': '',
    'licenseNo': '',
    'logo': '',
    'mobileNo': '',
    'orgName': '',
  };

  @override
  void dispose() {
    // TODO: implement dispose
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (orgLocalId != null) {
        orgLocalId = ModalRoute.of(context).settings.arguments as String;
        print('from Edit Org ' + orgLocalId);
        Provider.of<Organizations>(context, listen: false).fetchAndSetOrg(orgLocalId).then((_) => {
          setState(() {
            _editedOrg = Provider.of<Organizations>(context, listen: false)
                .findById(orgLocalId);
            _initValues = {
              'webPage': _editedOrg.webPage,
              'orgLocalId': _editedOrg.orgLocalId,
              'address': _editedOrg.address,
              'bankAccounts': _editedOrg.bankAccounts,
              'description': _editedOrg.description,
              'landLineNo': _editedOrg.landLineNo,
              'licenseNo': _editedOrg.licenseNo,
              'logo': _editedOrg.logo,
              'mobileNo': _editedOrg.mobileNo,
              'orgName': _editedOrg.orgName,
            };
            print("After init value" + _editedOrg.orgName);
          }),
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
//    PlaceLocation myCurrentLocation;
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedOrg.id != null) {
      _editedOrg = Organization(
        logo: _downloadUrl != null ? _downloadUrl : _editedOrg.logo,
        id: _editedOrg.id,
        orgName: _editedOrg.orgName,
        address: _editedOrg.address,
        description: _editedOrg.description,
        licenseNo: _editedOrg.licenseNo,
        landLineNo: _editedOrg.landLineNo,
        mobileNo: _editedOrg.mobileNo,
        bankAccounts: _editedOrg.bankAccounts,
        webPage: _editedOrg.webPage,
        orgLocalId: _editedOrg.orgLocalId,
      );
      final currentLocData = await Provider.of<Organizations>(context, listen: false)
              .getTheCurrentUserLocation();
      if (_editedOrg.logo != null && _editedOrg.logo != '') {
      Provider.of<Organizations>(context, listen: false)
          .deleteImage(_downloadUrl);
      }
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
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      } else {
//        print("select on map");
        await Provider.of<Organizations>(context, listen: false)
            .updateOrgWithSelectedLocation(
                _editedOrg.id, _editedOrg, _pickedLocation);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
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
    print('From Build' + _initValues['orgName']);
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
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          :Container(
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
                  Text(
                    _initValues['orgName'],
                    textAlign: TextAlign.center,
                  ),
                  TextFormField(
                    textAlign: TextAlign.right,
                    initialValue: 'يــــــــــــــــــــــــــــارب',
                    decoration: const InputDecoration(
                      hintText: 'مثال: نشاط إطعام',
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'من فضلك أدخل أسم للنشاط';
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
                    decoration: InputDecoration(labelText: 'اسم الجمعية'),
                    initialValue: _initValues['orgName'],
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
                    initialValue: _initValues['address'],
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
                    initialValue: _initValues['description'],
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
                    initialValue: _initValues['licenseNo'],
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
                    initialValue: _initValues['landLineNo'],
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
                    decoration:
                        InputDecoration(labelText: 'رقم الهاتف المحمول '),
                    initialValue: _initValues['mobileNo'],
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
                    initialValue: _initValues['bankAccounts'],
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
                    initialValue: _initValues['webPage'],
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
