import 'dart:io';

import 'package:BorhanAdmin/models/place.dart';
import 'package:BorhanAdmin/providers/auth.dart';
import 'package:BorhanAdmin/widgets/location_input.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

  final _nameController = TextEditingController();
  final _webController = TextEditingController();
  final _addressController = TextEditingController();
  final _bankController = TextEditingController();
  final _descController = TextEditingController();
  final _landController = TextEditingController();
  final _licenseController = TextEditingController();
  final _mobileController = TextEditingController();

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
        Provider.of<Organizations>(context, listen: false)
            .fetchAndSetOrg(orgLocalId)
            .then((value) => {
                  setState(() {
                    _editedOrg = value;
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
                    print(_editedOrg.logo);
                    _nameController.text = _initValues['orgName'];
                    _addressController.text = _initValues['address'];
                    _descController.text = _initValues['description'];
                    _landController.text = _initValues['landLineNo'];
                    _licenseController.text = _initValues['licenseNo'];
                    _mobileController.text = _initValues['mobileNo'];
                    _webController.text = _initValues['webPage'];
                    _bankController.text = _initValues['bankAccounts'];
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
      print(_editedOrg.logo);
      final currentLocData =
          await Provider.of<Organizations>(context, listen: false)
              .getTheCurrentUserLocation();
      if (_editedOrg.logo != null && _editedOrg.logo != '') {
        Provider.of<Organizations>(context, listen: false)
            .deleteImage(_editedOrg.logo);
      }
      print(
          "loca is : ${currentLocData.longitude} + ${currentLocData.latitude}");
      // _currentLocation.longitude=LocationInput.
//      myCurrentLocation.latitude = currentLocData.latitude;
//      myCurrentLocation.longitude = currentLocData.longitude;
//      if (currentLocData.longitude != null && currentLocData.latitude != null) {
      print("Current Location is not Null");
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
      await Provider.of<Organizations>(context, listen: false)
          .updateOrgWithCurrentLocation(
              _editedOrg.id, _editedOrg, currentLocData);
      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pop();

//        print("select on map");
//        await Provider.of<Organizations>(context, listen: false)
//            .updateOrgWithSelectedLocation(
//                _editedOrg.id, _editedOrg, _pickedLocation);
//        setState(() {
//          _isLoading = false;
//        });
//      Navigator.of(context).pop();

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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
//              decoration: BoxDecoration(
//                gradient: LinearGradient(
//                  colors: [
//                    Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
//                    Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
//                  ],
//                  begin: Alignment.topLeft,
//                  end: Alignment.bottomRight,
//                  stops: [0, 1],
//                ),
//              ),
              color: Colors.teal[100],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
//    child: Padding(
//    padding: const EdgeInsets.all(16.0),
//    child: Form(
//    key: _form,
//    child: SingleChildScrollView(
//    child: Column(
                child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'اسم الجمعية',
                        ),
                        TextField(
                          controller: _nameController,
//                    textDirection: TextDirection.rtl,
                          onChanged: (val) {
                            _editedOrg = Organization(
                              orgName: val,
                              id: _editedOrg.id,
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
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Text('عنوان الجمعية'),
                        TextField(
                          controller: _addressController,
//                    textDirection: TextDirection.rtl,
                          onChanged: (val) {
                            _editedOrg = Organization(
                              orgName: _editedOrg.orgName,
                              id: _editedOrg.id,
                              logo: _downloadUrl,
                              address: val,
                              description: _editedOrg.description,
                              licenseNo: _editedOrg.licenseNo,
                              landLineNo: _editedOrg.landLineNo,
                              mobileNo: _editedOrg.mobileNo,
                              bankAccounts: _editedOrg.bankAccounts,
                              webPage: _editedOrg.webPage,
                            );
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Text('نبذة عن الجمعية'),
                        TextField(
                          controller: _descController,
//                    textDirection: TextDirection.rtl,
                          onSubmitted: (val) {
                            _editedOrg = Organization(
                              orgName: _editedOrg.orgName,
                              id: _editedOrg.id,
                              logo: _downloadUrl,
                              address: _editedOrg.address,
                              description: val,
                              licenseNo: _editedOrg.licenseNo,
                              landLineNo: _editedOrg.landLineNo,
                              mobileNo: _editedOrg.mobileNo,
                              bankAccounts: _editedOrg.bankAccounts,
                              webPage: _editedOrg.webPage,
                            );
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Text('رقم الرخصة'),
                        TextField(
                          controller: _licenseController,
//                    textDirection: TextDirection.rtl,
                          onChanged: (val) {
                            _editedOrg = Organization(
                              orgName: _editedOrg.orgName,
                              id: _editedOrg.id,
                              logo: _downloadUrl,
                              address: _editedOrg.address,
                              description: _editedOrg.description,
                              licenseNo: val,
                              landLineNo: _editedOrg.landLineNo,
                              mobileNo: _editedOrg.mobileNo,
                              bankAccounts: _editedOrg.bankAccounts,
                              webPage: _editedOrg.webPage,
                            );
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Text('رقم الهاتف الأرضي'),
                        TextField(
                          controller: _landController,
//                    textDirection: TextDirection.rtl,
                          onChanged: (val) {
                            _editedOrg = Organization(
                              orgName: _editedOrg.orgName,
                              id: _editedOrg.id,
                              logo: _downloadUrl,
                              address: _editedOrg.address,
                              description: _editedOrg.description,
                              licenseNo: _editedOrg.licenseNo,
                              landLineNo: val,
                              mobileNo: _editedOrg.mobileNo,
                              bankAccounts: _editedOrg.bankAccounts,
                              webPage: _editedOrg.webPage,
                            );
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Text('رقم الهاتف المحمول'),
                        TextField(
                          controller: _mobileController,
//                    textDirection: TextDirection.rtl,
                          onChanged: (val) {
                            _editedOrg = Organization(
                              orgName: _editedOrg.orgName,
                              id: _editedOrg.id,
                              logo: _downloadUrl,
                              address: _editedOrg.address,
                              description: _editedOrg.description,
                              licenseNo: _editedOrg.licenseNo,
                              landLineNo: _editedOrg.landLineNo,
                              mobileNo: val,
                              bankAccounts: _editedOrg.bankAccounts,
                              webPage: _editedOrg.webPage,
                            );
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Text('تفاصيل الحساب المصرفي'),
                        TextField(
                          controller: _bankController,
//                    textDirection: TextDirection.rtl,
                          onChanged: (val) {
                            _editedOrg = Organization(
                              orgName: _editedOrg.orgName,
                              id: _editedOrg.id,
                              logo: _downloadUrl,
                              address: _editedOrg.address,
                              description: _editedOrg.description,
                              licenseNo: _editedOrg.licenseNo,
                              landLineNo: _editedOrg.landLineNo,
                              mobileNo: _editedOrg.mobileNo,
                              bankAccounts: val,
                              webPage: _editedOrg.webPage,
                            );
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Text('رابط صفحة الإنترنت'),
                        TextField(
                          controller: _webController,
//                    textDirection: TextDirection.rtl,
                          onChanged: (val) {
                            _editedOrg = Organization(
                              orgName: _editedOrg.orgName,
                              id: _editedOrg.id,
                              logo: _downloadUrl,
                              address: _editedOrg.address,
                              description: _editedOrg.description,
                              licenseNo: _editedOrg.licenseNo,
                              landLineNo: _editedOrg.landLineNo,
                              mobileNo: _editedOrg.mobileNo,
                              bankAccounts: _editedOrg.bankAccounts,
                              webPage: val,
                            );
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Container(
                          child: newImage(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
//                        LocationInput(_selectPlace),
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
              _image != null
                  ? Image.file(_image)
                  : _editedOrg.logo != null //update
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.width / 2,
//                                  height: MediaQuery.of(context).size.width,
                                child: CachedNetworkImage(
                                  imageUrl: _editedOrg.logo,
                                ),
                              ),
//                          fit: BoxFit.cover,
                            ),
                          ],
                        )
                      : Container()
            ],
          ),
        ),
      ),
    );
  }
}
