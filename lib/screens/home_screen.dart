//import 'package:BorhanAdmin/screens/email_screen.dart';
//import 'package:BorhanAdmin/screens/help_screen.dart';

import 'package:BorhanAdmin/providers/auth.dart';
import 'package:BorhanAdmin/providers/organizations_provider.dart';
import 'package:BorhanAdmin/screens/auth_screen.dart';
import 'package:BorhanAdmin/screens/help_screen.dart';
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

  var data;
  var _isInit = true;
  var orgLogo = '';

  @override
  void didChangeDependencies() {
    if (_isInit) {
      data = Provider.of<Auth>(context);
      Provider.of<Organizations>(context)
          .fetchAndSetOrg(data.adminData.id)
          .then((value) => {
                orgName = value.orgName,
                orgLogo = value.logo,
                print("From Home Charity Org is : " + orgName),
              });
    }
    _isInit = false;

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

//

  Route _createRoute1() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ActivityScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.decelerate;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _createRoute3() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => CampaignScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.decelerate;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _createRoute4() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          DonationTabsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.decelerate;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _createRoute5() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          VideoPlayerScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.decelerate;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _createRoute6() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HelpScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.decelerate;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _createRoute7() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AuthScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.decelerate;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('from Hoooooomeee id :  ' + data.adminData.id);
    return Container(
      child: Scaffold(
        backgroundColor: Colors.teal[100],
        appBar: AppBar(
          title: Text("الصفحة الرئيسية"),
          centerTitle: true,
          leading: Container(),
        ),
        body: Container(
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
                                arguments: data.adminData.id);
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
                            timeDilation = 3;
                            Navigator.of(context).push(_createRoute1());
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
                            timeDilation = 3;

                            Navigator.of(context).push(_createRoute3());
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
                            timeDilation = 3;

                            Navigator.of(context).push(_createRoute4());
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
                            timeDilation = 3;

                            Navigator.of(context).push(_createRoute5());
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
                            timeDilation = 3;

                            Navigator.of(context).push(_createRoute6());
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
                          textColor:
                              Theme.of(context).primaryTextTheme.button.color,
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
                              timeDilation = 3;

                              Navigator.of(context).pop(_createRoute7());
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 8.0),
                            color: Theme.of(context).primaryColor,
                            textColor:
                                Theme.of(context).primaryTextTheme.button.color,
                          ),
                        ),
                      ),
                    ],
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
