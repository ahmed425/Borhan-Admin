import 'dart:io' show Platform;
import 'package:BorhanAdmin/providers/auth.dart';
import 'package:BorhanAdmin/providers/organizations_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../providers/activities.dart';
import '../models/activity.dart';

class AddActivity extends StatefulWidget {
  static const routeName = '/add-activity';
  final orgLocalId ;
  final actId;
  AddActivity({this.orgLocalId,this.actId});
  @override
  _AddActivityState createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  String orgId = '';
  final _descFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _isLoadImg = false;
  var _isInit = true;
  var _isLoading = false;
  File _image;
  String _downloadUrl;
  var _addActivity = Activity(
    id: null,
    activityName: '',
    activityDescription: '',
    imagesUrl: '',
  );
  var _initValues = {
    'actName': '',
    'actDescription': '',
    'imgUrl': '',
  };

  Future getImage() async {
    File img;
    img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = img;
      _isLoadImg = true;
    });

    Provider.of<Activities>(context, listen: false)
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
    if (_addActivity.imagesUrl != null && _addActivity.imagesUrl != '') {
      print(
          '---------------------------- from delete image -----------------------------');
      print('Image Url : ' + _addActivity.imagesUrl);
      Provider.of<Activities>(context, listen: false)
          .deleteImage(_addActivity.imagesUrl);
    }
    print("---------------------------------------------");
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if (_addActivity.id != null) {
      print("activity id :  " + _addActivity.id);
      _addActivity = Activity(
        id: _addActivity.id,
        imagesUrl: _downloadUrl != null ? _downloadUrl : _addActivity.imagesUrl,
        activityDescription: _addActivity.activityDescription,
        activityName: _addActivity.activityName,
      );
      print(_addActivity.imagesUrl);
      Provider.of<Activities>(context, listen: false)
          .updateActivity(_addActivity.id, _addActivity, orgId);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      _addActivity = Activity(
        id: _addActivity.id,
        imagesUrl: _downloadUrl,
        activityDescription: _addActivity.activityDescription,
        activityName: _addActivity.activityName,
      );
      print(_addActivity.imagesUrl);
      try {
        await Provider.of<Activities>(context, listen: false)
            .addActivity(_addActivity, orgId);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => (Platform.isAndroid)?
          AlertDialog(
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
          ):CupertinoAlertDialog(
             title: Text('خطأ'),
            content: Text('حدث خطأ ما'),
            actions: <Widget>[
              CupertinoDialogAction(
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
//      final data = Provider.of<Auth>(context);
    print('from add act screen when edit');
    print(widget.orgLocalId);
      Provider.of<Organizations>(context)
          .fetchAndSetOrg(widget.orgLocalId)
          .then((value) => {
                orgId = value.id,
                print(orgId),
              });
//      final activityId = ModalRoute.of(context).settings.arguments as String;
      final activityId = widget.actId;
      if (activityId != null) {
        _addActivity = Provider.of<Activities>(context, listen: false)
            .findById(activityId);
        print(
            'After Find Activity  _addActivity =  ' + _addActivity.toString());
        print('After Find Activity  Activity Name =  ' +
            _addActivity.activityName);
        _initValues = {
          'actName': _addActivity.activityName,
          'actDescription': _addActivity.activityDescription,
          'imgUrl': _addActivity.imagesUrl,
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
        title: _addActivity.id != null
            ? Text('تعديل النشاط')
            : Text('إضافة نشاط جديد'),
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
                          'اسم النشاط',
                          textAlign: TextAlign.center,
                        ),
                        TextFormField(
                          textAlign: TextAlign.right,
                          initialValue: _initValues['actName'],
                          decoration: const InputDecoration(
                            hintText: 'مثال: نشاط إطعام',
                          ),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_descFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'من فضلك أدخل أسم للنشاط';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _addActivity = Activity(
                              activityName: value,
                              activityDescription:
                                  _addActivity.activityDescription,
                              imagesUrl: _addActivity.imagesUrl,
                              id: _addActivity.id,
                            );
                          },
                        ),
                        Text(
                          'الوصف',
                          textAlign: TextAlign.center,
                        ),
                        TextFormField(
                          initialValue: _initValues['actDescription'],
                          textAlign: TextAlign.right,
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            hintText: 'نشاط يساعد في اطعام المحتاجين',
                          ),
                          focusNode: _descFocusNode,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'من فضلك أدخل وصف للنشاط';
                            }
                            if (value.length < 10) {
                              return 'الوصف يجب ألا يقل عن 10 أحرف';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _addActivity = Activity(
                              activityName: _addActivity.activityName,
                              activityDescription: value,
                              imagesUrl: _addActivity.imagesUrl,
                              id: _addActivity.id,
                            );
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          color: Colors.teal[100],
                          child: _isLoadImg
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : newImage(),
//                      child: addImage(),
                        ),
                        Container(
                          color: Colors.teal[100],
                          padding: const EdgeInsets.all(10.0),
                          child: new RaisedButton(
                            textColor: Colors.white,
                            child: _addActivity.id != null
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
        color: Colors.teal[100],
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
              _addActivity.id != null && _image != null
                  ? Image.file(
                      _image,
                      height: MediaQuery.of(context).size.width,
                    )
                  : _addActivity.id != null &&
                          _addActivity.imagesUrl != null //update
                      ? Container(
                          color: Colors.teal[100],
                          height: MediaQuery.of(context).size.width,
                          child: Image.network(_addActivity.imagesUrl))
                      : _image == null
                          ? Container(
                              color: Colors.teal[100],
                            )
                          : Image.file(
                              _image,
                              height: MediaQuery.of(context).size.width,
                            ),
            ],
          ),
        ),
      ),
    );
  }
}
