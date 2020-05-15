import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './activity_screen.dart';

class Home extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الصفحة الرئيسية"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {},
              child: Text('تعديل بيانات الجمعية'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivityScreen(),
                  ),
                );
              },
              child: Text('إدارة أنشطة الجمعية'),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text('إدارة الحملات'),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text('  متابعة التبرعات'),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text('  مشاهدة فيديو توضيحي'),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text('المساعدة'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('الرجوع إلي صفحة الدخول'),
            ),
          ],
        ),
      ),
    );
  }
}
