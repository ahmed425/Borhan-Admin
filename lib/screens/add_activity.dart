import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddActivity extends StatefulWidget {
  static const routeName = '/add-activity';

  @override
  _AddActivityState createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {

  Future<File> imageFile;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة نشاط جديد'),
      ),
      body: Form(
          child: Column(
            children: <Widget>[
              Text(
                'اسم النشاط',
                textAlign: TextAlign.left,
              ),
              TextFormField(
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  hintText: 'مثال: نشاط إطعام',
                ),
              ),
              Text('الوصف'),
              TextFormField(
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  hintText: 'نشاط يساعد في اطعام المحتاجين',
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: addImage(),
              ),
//              Container(
//                child: GridView.builder(
//                  padding: const EdgeInsets.all(10.0),
//                  itemCount: 4,
//                  itemBuilder: (ctx, i) => images(
//                    images[i]
//                  ),
//                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                    crossAxisCount: 2,
//                    childAspectRatio: 3 / 2,
//                    crossAxisSpacing: 10,
//                    mainAxisSpacing: 10,
//                  ),
//                ),
//              ),
              Container(
                  padding: const EdgeInsets.all(10.0),
                  child: new RaisedButton(
                    child: const Text('إضافة'),
                    color: Colors.lightBlueAccent,
                    onPressed: () {},
                  )),
        ],
      )),
    );
  }
}
