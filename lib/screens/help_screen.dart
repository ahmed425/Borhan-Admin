import 'package:BorhanAdmin/screens/all_users_chat.dart';
import 'package:BorhanAdmin/screens/email_screen.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  final orgLocalId;

  HelpScreen({this.orgLocalId});

  static const routeName = '/help';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('طلبات المساعدة'),
      ),
      body: Container(
        color: Colors.teal[100],
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width*8/9,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmailScreen()));
                    },
                    child: Text(
                      'طلب الدعم الفني بواسطة البريد الإلكتروني',
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
                  padding: const EdgeInsets.only(top: 35),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width*8/9,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllUsersChatScreen(
                              orgLocalId: this.orgLocalId,
                            ),
                          ));
                    },
                    child: Text(
                      'محادثة مع مستخدمي التطبيق',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
