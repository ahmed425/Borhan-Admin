import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  var _editedOrg =Organization(
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

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {});
    if (_editedOrg.id != null) {
      await Provider.of<Organizations>(context, listen: false)
          .updateOrg(_editedOrg.id, _editedOrg);
    }
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
                        logo: _editedOrg.logo,
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
                        logo: _editedOrg.logo,
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
                        logo: _editedOrg.logo,
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
                        logo: _editedOrg.logo,
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
                        logo: _editedOrg.logo,
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
                        logo: _editedOrg.logo,
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
                        logo: _editedOrg.logo,
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
                        logo: _editedOrg.logo,
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.only(
                          top: 8,
                          right: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                        child: _imageUrlController.text.isEmpty
                            ? Text('Enter a URL')
                            : FittedBox(
                                child: Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Image URL'),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageUrlFocusNode,
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'يرجي إدخال رابط صورة';
                            }
                            if (!value.startsWith('http') &&
                                !value.startsWith('https')) {
                              return 'يرجي إدخال رابط صورة صحيح';
                            }
                            if (!value.endsWith('.png') &&
                                !value.endsWith('.jpg') &&
                                !value.endsWith('.jpeg')) {
                              return 'يرجي إدخال رابط صورة صحيح';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedOrg = Organization(
                              id: _editedOrg.id,
                              orgName: _editedOrg.orgName,
                              logo: value,
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
