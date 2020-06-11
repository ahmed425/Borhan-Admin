//import 'package:BorhanAdmin/screens/email_screen.dart';
//import 'package:BorhanAdmin/screens/help_screen.dart';
import 'dart:io' show Platform;
import 'package:BorhanAdmin/providers/auth.dart';
import 'package:BorhanAdmin/providers/organizations_provider.dart';
import 'package:BorhanAdmin/providers/shard_pref.dart';
import 'package:BorhanAdmin/screens/auth_screen.dart';
import 'package:BorhanAdmin/screens/help_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../screens/video_screen.dart';
import '../screens/donation_tabs_screen.dart';
import 'package:flutter/material.dart';
import '../screens/campaign_screen.dart';
import '../screens/activity_screen.dart';
import '../screens/edit_organization_details.dart';
import 'activity_screen.dart';
import 'edit_organization_details.dart';
import 'image_chatting.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

//var timeDilation = 2.0; // Will slow down animations by a factor of two

class Home extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var orgName = '';
//  var data;
  var shPref;
  var _isInit = true;
  var orgLogo = '';
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Auth>(context).loadSharedPrefs().then((adminData) => {
            print('fromm Hooooooome'),
            shPref = Provider.of<Auth>(context).userLoad,
            print(shPref),
            print(adminData),
            _isLoading = true,
      //      data = Provider.of<Auth>(context);
      Provider.of<Organizations>(context)
          .fetchAndSetOrg(shPref.id)
          .then((value) => {
      orgName = value.orgName,
      orgLogo = value.logo,
      print("From Home Charity Org is : " + orgName),
      }),
          });

    }
    _isInit = false;

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void _showErrorDialog(String message) {
    print("alert");
    showDialog(
      context: context,
      builder: (ctx) => (Platform.isAndroid)?
      AlertDialog(
        title: Text('تسجيل خروج'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('الغاء'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          FlatButton(
            child: Text('نعم'),
            onPressed: () {
              SharedPref sharedPref = SharedPref();
              sharedPref.remove("admin");
//              Navigator.of(ctx).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => AuthScreen()));
            },
          ),
        ],
      ):CupertinoAlertDialog(
                title: Text('تسجيل خروج'),
        content: Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('نعم'),
            onPressed: () {
              SharedPref sharedPref = SharedPref();
              sharedPref.remove("admin");
//              Navigator.of(ctx).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => AuthScreen()));
            },
          ),
          CupertinoDialogAction(
            child: Text('الغاء'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
      //  .then((value) => Navigator.of(context).pop());
  }


  @override
  Widget build(BuildContext context) {
//    print('from Hoooooomeee id :  ' + data.adminData.id);
    return Container(
      child: Scaffold(
        backgroundColor: Colors.teal[100],
        appBar: AppBar(
          title: Text("الصفحة الرئيسية"),
          centerTitle: true,
          leading: Container(),
        ),
        body: _isLoading
            ? Container(
                color: Colors.teal[100],
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(orgLogo),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                          ),
                          Text(
                            orgName,
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                            ),
                            SizedBox(
                              width: 250,
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, EditOrganizationScreen.routName,
                                      arguments: shPref.id);
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 8.0),
                                color: Theme.of(context).primaryColor,
                                textColor: Theme.of(context)
                                    .primaryTextTheme
                                    .button
                                    .color,
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
                                          builder: (context) =>
                                              ActivityScreen(orgLocalId: shPref.id,)));
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 8.0),
                                color: Theme.of(context).primaryColor,
                                textColor: Theme.of(context)
                                    .primaryTextTheme
                                    .button
                                    .color,
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
                                          builder: (context) =>
                                              CampaignScreen(orgLocalId: shPref.id,)));
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 8.0),
                                color: Theme.of(context).primaryColor,
                                textColor: Theme.of(context)
                                    .primaryTextTheme
                                    .button
                                    .color,
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
                                          builder: (context) =>
                                              DonationTabsScreen(orgLocalId: shPref.id,)));
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 8.0),
                                color: Theme.of(context).primaryColor,
                                textColor: Theme.of(context)
                                    .primaryTextTheme
                                    .button
                                    .color,
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
                                          builder: (context) =>
                                              VideoPlayerScreen()));
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 8.0),
                                color: Theme.of(context).primaryColor,
                                textColor: Theme.of(context)
                                    .primaryTextTheme
                                    .button
                                    .color,
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
                                          builder: (context) => HelpScreen(orgLocalId: shPref.id,)));
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 8.0),
                                color: Theme.of(context).primaryColor,
                                textColor: Theme.of(context)
                                    .primaryTextTheme
                                    .button
                                    .color,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: SizedBox(
                                width: 250,
                                child: RaisedButton(
                                  onPressed: () {
                                    _showErrorDialog("هل تريد تسجيل الخروج");
                                  },
                                  child: Text(
                                    'تسجيل الخروج',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 8.0),
                                  color: Theme.of(context).primaryColor,
                                  textColor: Theme.of(context)
                                      .primaryTextTheme
                                      .button
                                      .color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
