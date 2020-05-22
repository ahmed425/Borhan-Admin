import 'package:BorhanAdmin/screens/email_screen.dart';

import '../screens/video_screen.dart';
import '../screens/donation_tabs_screen.dart';
import 'package:flutter/material.dart';
import '../screens/campaign_screen.dart';
import '../screens/activity_screen.dart';
import '../screens/edit_organization_details.dart';
import 'activity_screen.dart';
import 'edit_organization_details.dart';

class Home extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Container(
//      decoration: BoxDecoration(
//        gradient: LinearGradient(
//          colors: [
//            Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
//            Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
//          ],
//          begin: Alignment.topLeft,
//          end: Alignment.bottomRight,
//          stops: [0, 1],
//        ),
//      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("الصفحة الرئيسية"),
        ),
        body: Container(
          color: Colors.teal[100],
//          decoration: BoxDecoration(
//            gradient: LinearGradient(
//              colors: [
//                Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
//                Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
//              ],
//              begin: Alignment.topLeft,
//              end: Alignment.bottomRight,
//              stops: [0, 1],
//            ),
//          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  SizedBox(
                    width: 250,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditOrganizationScreen()));
                      },
                      child: Text(
                        'تعديل بيانات الجمعية',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryTextTheme.button.color,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  SizedBox(
                    width: 250,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ActivityScreen()));
                      },
                      child: Text(
                        'إدارة أنشطة الجمعية',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryTextTheme.button.color,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  SizedBox(
                    width: 250,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CampaignScreen()));
                      },
                      child: Text(
                        'إدارة الحملات',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryTextTheme.button.color,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  SizedBox(
                    width: 250,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>DonationTabsScreen()));
                      },
                      child: Text(
                        'متابعة التبرعات',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryTextTheme.button.color,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  SizedBox(
                    width: 250,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VideoPlayerScreen()));
                      },
                      child: Text(
                        'مشاهدة فيديو توضيحي',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      color: Theme.of(context).primaryColor,
                      textColor:
                          Theme.of(context).primaryTextTheme.button.color,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  SizedBox(
                    width: 250,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EmailScreen()));
                      },
                      child: Text(
                        'المساعدة',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      color: Theme.of(context).primaryColor,
                      textColor:
                          Theme.of(context).primaryTextTheme.button.color,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  SizedBox(
                    width: 250,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'الرجوع إلي صفحة الدخول',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      color: Theme.of(context).primaryColor,
                      textColor:
                          Theme.of(context).primaryTextTheme.button.color,
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
}
