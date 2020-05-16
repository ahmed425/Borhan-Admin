import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'activity_screen.dart';
import 'edit_organization_details.dart';

class Home extends StatelessWidget {
  static const routeName = '/home';

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
          title: Text("الصفحة الرئيسية"),
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
          child: Center(
            child: Column(
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditOrganizationScreen()));
                  },
                  child: Text('تعديل بيانات الجمعية'),
                ),
                RaisedButton(
                  onPressed: () { Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ActivityScreen()));},
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
        ),
      ),
    );
  }
}
