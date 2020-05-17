import 'package:BorhanAdmin/models/campaign.dart';
import 'package:BorhanAdmin/providers/campaigns.dart';
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
  Future<File> imageFile;
  final _descFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _addCampaign = Campaign(
    id: null,
    campaignName: '',
    campaignDescription: '',
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
          _addCampaign = Campaign(
            campaignName: _addCampaign.campaignName,
            campaignDescription: _addCampaign.campaignDescription,
            imagesUrl: snapshot.data.toString(),
            id: _addCampaign.id,
            time: _addCampaign.time,
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
//        } else if (_addCampaign.id != null) {
//          return Image.file(
//            new File(_addCampaign.imagesUrl),
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
  // FirebaseApp.initializeApp(this);
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
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(_image.path.split('/').last);
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
    print(
        '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n +++++++++++++++++++++++++++++++++++++++++++');
    print("from uploading$_downloadUrl");
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
              _downloadUrl != null
                  ? Image.network(_downloadUrl)
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
    if (_addCampaign.id != null) {
      // for getting image from storage in firebase
      downloadImage();
      //
      Provider.of<Campaigns>(context, listen: false)
          .updateCampaign(_addCampaign.id, _addCampaign);
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
        await Provider.of<Campaigns>(context, listen: false)
            .addCampaign(_addCampaign);
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
      final campaignId = ModalRoute.of(context).settings.arguments as String;
      if (campaignId != null) {
        _addCampaign =
            Provider.of<Campaigns>(context, listen: false).findById(campaignId);
        _initValues = {
          'actName': _addCampaign.campaignName,
          'actDescription': _addCampaign.campaignDescription,
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
      appBar: AppBar(
        title: _addCampaign.id != null
            ? Text('تعديل الحملة')
            : Text('إضافة حملة جديدة'),
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
                        'اسم الحملة',
                        textAlign: TextAlign.center,
                      ),
                      TextFormField(
                        textAlign: TextAlign.right,
                        initialValue: _initValues['actName'],
                        decoration: const InputDecoration(
                          hintText: 'مثال:حملة رمضان الخير  ',
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
                            id: _addCampaign.id,
                            time: _addCampaign.time,
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
                          hintText: 'حملة تساعد في اطعام المحتاجين',
                        ),
//                        focusNode: _descFocusNode,
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
                            id: _addCampaign.id,
                            time: _addCampaign.time,
                          );
                        },
                      ),
                      Text(
                        'وقت الحملة',
                        textAlign: TextAlign.center,
                      ),
                      TextFormField(
                        initialValue: _initValues['actDescription'],
                        textAlign: TextAlign.right,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText: 'وقت الحملة',
                        ),
//                        focusNode: _descFocusNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'من فضلك أدخل وقت للحملة';
                          }
//                          if (value.length < 10) {
//                            return 'الوصف يجب ألا يقل عن 10 أحرف';
//                          }
                          return null;
                        },
                        onSaved: (value) {
                          _addCampaign = Campaign(
                            campaignName: _addCampaign.campaignName,
                            campaignDescription:
                                _addCampaign.campaignDescription,
                            imagesUrl: _addCampaign.imagesUrl,
                            id: _addCampaign.id,
                            time: value,
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
                          child: _addCampaign.id != null
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
}
