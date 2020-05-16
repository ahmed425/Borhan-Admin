import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../providers/activities.dart';
import '../models/activity.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddActivity extends StatefulWidget {
  static const routeName = '/add-activity';

  @override
  _AddActivityState createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  Future<File> imageFile;
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

//  List<Future<File>> images;
//  var i = 0;

  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
//      images.add(imageFile);
//      i++;
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          print(snapshot.data);
          _addActivity = Activity(
            activityName: _addActivity.activityName,
            activityDescription: _addActivity.activityDescription,
            imagesUrl: snapshot.data.toString(),
            id: _addActivity.id,
          );
          return Image.file(
            snapshot.data,
            width: 300,
            height: 300,
          );
        } else if (snapshot.error != null) {
          return const Text(
            'فشل في تحديد الصوره',
            textAlign: TextAlign.center,
          );
//        } else if (_addActivity.id != null) {
//          return Image.file(
//            new File(_addActivity.imagesUrl),
//          );
        } else {
          return const Text(
            'لم يتم تحديد صور',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  Widget addImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        showImage(),
        RaisedButton(
          child: Text("إضافة صورة"),
          onPressed: () {
            pickImageFromGallery(ImageSource.gallery);
          },
        ),
      ],
    );
  }

  File _image;
  var _upload = false;
  String _downloadUrl;
  StorageReference _reference =
      FirebaseStorage.instance.ref().child('imageUrl.jpg');

  Future getImage() async {
    File img;
    img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  Future uploadImage() async {
    print("object");
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child(_image.path.split('/').last);
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _downloadUrl = fileURL;
      });
    });
//    StorageUploadTask uploadTask = _reference.putFile(_image);
//    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
//    setState(() {
//      _upload = true;
//    });
    print('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n +++++++++++++++++++++++++++++++++++++++++++');
    print("from uploading");
  }
  Future downloadImage() async {
    String downloadAddress = await _reference.getDownloadURL();
  setState(() {
    _downloadUrl = downloadAddress;
  });
  }

  Widget newImage() {
    return Center(
      child: Container(
        height: 300,
        child: ListView(
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
            _downloadUrl != null
                ? Image.network(_downloadUrl)
                : _image==null? Container(): Image.file(
                    _image,
                    height: 250,
                  ),
          ],
        ),
      ),
    );
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
    print("---------------------------------------------");
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_addActivity.id != null) {
      // for getting image from storage in firebase
      downloadImage();
      //
      Provider.of<Activities>(context, listen: false)
          .updateActivity(_addActivity.id, _addActivity);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        // for storing image in Storage in firebase
        print('before');
        uploadImage();
        //
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
                child: ListView(
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
                          activityDescription: _addActivity.activityDescription,
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
    );
  }
}
