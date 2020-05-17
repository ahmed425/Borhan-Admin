import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../providers/activities.dart';
import '../models/activity.dart';

class AddActivity extends StatefulWidget {
  static const routeName = '/add-activity';

  @override
  _AddActivityState createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  final _descFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _addActivity = Activity(
    id: null,
    activityName: '',
    activityDescription: '',
    imagesUrl: '',
  );
  var _isInit = true;
  var _initValues = {
    'actName': '',
    'actDescription': '',
    'imgUrl': '',
  };
  var _isLoading = false;
  File _image;
  String _downloadUrl;

  Future getImage() async {
    File img;
    img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = img;
    });

    Provider.of<Activities>(context, listen: false)
        .uploadImage(_image).then((val){
          _downloadUrl = val;
          print("value from upload" + _downloadUrl);
    });

    Provider.of<Activities>(context, listen: false)
        .deleteImage(_addActivity.imagesUrl);
  }

//  @override
//  void dispose() {
//    // TODO: implement dispose
//    _descFocusNode.dispose();
//    super.dispose();
//  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    print("---------------------------------------------");
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if (_addActivity.id != null) {
      print("activity id :  "+_addActivity.id);
      _addActivity = Activity(
        id: _addActivity.id,
        imagesUrl: _downloadUrl!=null? _downloadUrl:_addActivity.imagesUrl,
        activityDescription: _addActivity.activityDescription,
        activityName: _addActivity.activityName,
      );
      print(_addActivity.imagesUrl);
      Provider.of<Activities>(context, listen: false)
          .updateActivity(_addActivity.id, _addActivity);
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
            .addActivity(_addActivity);
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
      final activityId = ModalRoute.of(context).settings.arguments as String;
      if (activityId != null) {
        _addActivity = Provider.of<Activities>(context, listen: false)
            .findById(activityId);
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
      appBar: AppBar(
        title: _addActivity.id != null
            ? Text('تعديل النشاط')
            : Text('إضافة نشاط جديد'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
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
                        child: newImage(),
//                      child: addImage(),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: new RaisedButton(
                          child: _addActivity.id != null
                              ? Text('حفظ')
                              : Text('إضافة'),
                          color: Colors.lightBlueAccent,
                          onPressed: _saveForm,
                        ),
                      ),
                    ],
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
                child: Text('gallery'),
                onPressed: () {
                  getImage();
                },
              ),
              _addActivity.id!=null && _addActivity.imagesUrl != null
                  ? Image.network(_addActivity.imagesUrl)
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
