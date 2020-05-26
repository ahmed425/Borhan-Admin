import 'dart:io';

import 'package:BorhanAdmin/models/chat.dart';
import 'package:BorhanAdmin/providers/chat_provider.dart';
import 'package:BorhanAdmin/providers/image_chat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageChatScreen extends StatefulWidget {
//  ImageChatScreen(this.imagePickFn);

//  final void Function(File pickedImage) imagePickFn;

  @override
  _ImageChatScreenState createState() => _ImageChatScreenState();
}

class _ImageChatScreenState extends State<ImageChatScreen> {
//  File _pickedImage;
//  File _image;
//  String _downloadUrl;
  String imageUrl1;
  String imageUrl2;

  File imageFile;
  Chat myChat;

  @override
  void initState() {
    super.initState();

    imageUrl1 = '';
    imageUrl2 = '';

//    readLocal();
  }

  Future userGetImage() async {
    File img;
    img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = img;
//      _isLoadImg = true;
    });

    Provider.of<ImageChat>(context, listen: false)
        .userUploadImage(imageFile)
        .then((val) {
      imageUrl1 = val;
      setState(() {
//        _isLoadImg = false;
      });
      print("value from upload User" + imageUrl1);
    });
  }

  Future adminGetImage() async {
    File img;
    img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = img;
//      _isLoadImg = true;
    });

    Provider.of<ImageChat>(context, listen: false)
        .adminUploadImage(imageFile)
        .then((val) {
      imageUrl2 = val;
      setState(() {
//        _isLoadImg = false;
      });
      print("value from upload Admin" + imageUrl2);
    });
  }

  Future userUploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl1 = downloadUrl;
      setState(() {
//        isLoading = false;
        userOnSendMessage(imageUrl1, 1);
      });
    }, onError: (err) {
      setState(() {
//        isLoading = false;
      });
//      FlutterToast.showToast(msg: 'This file is not an image');
    });
  }

  Future adminUploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl2 = downloadUrl;
      setState(() {
//        isLoading = false;
        adminOnSendMessage(imageUrl2, 1);
      });
    }, onError: (err) {
      setState(() {
//        isLoading = false;
      });
//      FlutterToast.showToast(msg: 'This file is not an image');
    });
  }

  void userOnSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    Chat mychat2 = Chat(
        id: "",
        img: content,
        text: "hi",
        time: "",
        userId: "1",
        userName: "AHMED");
    if (content.trim() != '') {
      Provider.of<ImageChat>(context).userAddMessage(mychat2);
    } else {
//      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  void adminOnSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    Chat mychat3 = Chat(
        id: "",
        img: content,
        text: "hi",
        time: "",
        userId: "1",
        userName: "Admin");
    if (content.trim() != '') {
      Provider.of<ImageChat>(context).adminAddMessage(mychat3);
    } else {
//      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: Scaffold(
            appBar: AppBar(
              title: Text("االمحادثة"),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  FlatButton.icon(
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      userGetImage();
                      userOnSendMessage(imageUrl1, 1);
                    },
                    icon: Icon(Icons.image),
                    label: Text('المتبرع'),
                  ),
                  newImage1(),
                  FlatButton.icon(
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      adminGetImage();
                      adminOnSendMessage(imageUrl2, 1);
                    },
                    icon: Icon(Icons.image),
                    label: Text('إدارة الجمعية'),
                  ),
                  newImage2(),
                ],
              ),
            )));

//
//      ],
//    );
  }

  Widget newImage1() {
    return Center(
      child: Container(
        height: 150,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),

//              _addActivity.id != null && _image != null
//                  Image.file(imageFile)
//                  : _addActivity.id != null &&
              imageUrl1 != null
                  ? Container(child: Image.network(imageUrl1))
                  : Container(),

//              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget newImage2() {
    return Center(
      child: Container(
        height: 150,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),

//              _addActivity.id != null && _image != null
//                  Image.file(imageFile)
//                  : _addActivity.id != null &&
              imageUrl2 != null
                  ? Container(child: Image.network(imageUrl2))
                  : Container(),
//                   imageFile == null
//                   Container()
//                   Image.file(
//                imageFile,
//                height: 250,
//              ),
            ],
          ),
        ),
      ),
    );
  }
}

//  Future getImage() async {
//    File img;
//    img = await ImagePicker.pickImage(source: ImageSource.gallery);
//    setState(() {
//      _image = img;
////      _isLoadImg = true;
//    });
//

//    focusNode.addListener(onFocusChange);
//
//    groupChatId = '';
//
//    isLoading = false;
//    isShowSticker = false;
//   myChat;
//    Provider.of<ImageChat>(context, listen: false)
//        .uploadImage(_image)
//        .then((val) {
//      _downloadUrl = val;
//      setState(() {
////        _isLoadImg = false;
//      });
//      print("value from upload" + _downloadUrl);
//    });
//  }
//                   imageFile == null
//                   Container()
//                   Image.file(
//                imageFile,
//                height: 250,

//      textEditingController.clear();

//      var documentReference = Firestore.instance
//          .collection('messages')
//          .document(groupChatId)
//          .collection(groupChatId)
//          .document(DateTime.now().millisecondsSinceEpoch.toString());

//      Firestore.instance.runTransaction((transaction) async {
//        await transaction.set(
//          documentReference,
//          {
//            'idFrom': id,
//            'idTo': peerId,
//            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
//            'content': content,
//            'type': type
//          },
//        );
//      });
//      listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
//  Future userGetImage() async {
//    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
//
//    if (imageFile != null) {
//      setState(() {
////        isLoading = true;
//      });
////      if (imageUrl1 != '') {
//      userUploadFile();
////      } else {
////        adminUploadFile();
////      }
//    }
//  }

//  Future adminGetImage() async {
//    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
//
//    if (imageFile != null) {
//      setState(() {
////        isLoading = true;
//      });
////      if (imageUrl1 != '') {
//      adminUploadFile();
////      } else {
////        adminUploadFile();
////      }
//    }
//  }

//      textEditingController.clear();

//      var documentReference = Firestore.instance
//          .collection('messages')
//          .document(groupChatId)
//          .collection(groupChatId)
//          .document(DateTime.now().millisecondsSinceEpoch.toString());

//      Firestore.instance.runTransaction((transaction) async {
//        await transaction.set(
//          documentReference,
//          {
//            'idFrom': id,
//            'idTo': peerId,
//            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
//            'content': content,
//            'type': type
//          },
//        );
//      });
//      listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
//  void _pickImage() async {
//    final pickedImageFile = await ImagePicker.pickImage(
//      source: ImageSource.camera,
//      imageQuality: 50,
//      maxWidth: 150,
//    );
//    setState(() {
//      _pickedImage = pickedImageFile;
//    });
//    widget.imagePickFn(pickedImageFile);
//  }
