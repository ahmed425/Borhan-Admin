import 'dart:io';
import 'package:BorhanAdmin/screens/home_screen.dart';
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
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
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
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
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
    });
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if (_downloadUrl != null) {
      if (_initValues['logo'] != null && _initValues['logo'] != '') {
        Provider.of<Organizations>(context, listen: false)
            .deleteImage(_initValues['logo']);
      }
    }

    _editedOrg = Organization(
      logo: _downloadUrl != null ? _downloadUrl : _initValues['logo'],
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
        .updateOrganization(_editedOrg.id, _editedOrg);

    setState(() {
      _isLoading = false;
    });

    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));

    Toast.show("تم حفظ البيانات بنجاح", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
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
              color: Colors.teal[100],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          minLines: 1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Text('نبذة عن الجمعية'),
                        TextField(
                          controller: _descController,
                          onChanged: (val) {
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
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          minLines: 3,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Text('رقم الرخصة'),
                        TextField(
                          controller: _licenseController,
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
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
//                          minLines: 2,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Text('رابط صفحة الإنترنت'),
                        TextField(
                          controller: _webController,
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue),
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
                          child: _isLoadImg
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : newImage(),
                        ),
                        SizedBox(
                          height: 10,
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
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('إختيار صورة'),
                  onPressed: () {
                    getImage();
                  },
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.width / 2,
                child: _image != null
                    ? Image.file(_image)
                    : _editedOrg.logo != null //update
                        ? Image.network(_editedOrg.logo)
                        : _image == null
                            ? Container()
                            : Image.file(
                                _image,
                                height: 250,
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
