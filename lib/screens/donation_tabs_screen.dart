import 'package:flutter/material.dart';
import '../screens/donation_history.dart';

class DonationTabsScreen extends StatefulWidget {
  static const routeName = '/donationTabsScreen';

  @override
  _DonationTabsScreenState createState() => _DonationTabsScreenState();
}

class _DonationTabsScreenState extends State<DonationTabsScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'التبرعات',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            labelStyle: TextStyle(fontSize: 20.0),
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.turned_in_not),
                text: 'التبرعات الحالية',
              ),
              Tab(
                icon: Icon(Icons.done_outline),
                text: 'التبرعات السابقة',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: Text('current donation'),
            ),
            DonationHistory(),
          ],
        ),
      ),
    );
  }
}
