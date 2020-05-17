import 'package:flutter/material.dart';
import './models/organization.dart';
import './providers/campaigns.dart';
import './providers/organizations_logic.dart';
import './screens/home_screen.dart';
import './screens/auth_screen.dart';
import 'package:provider/provider.dart';
import './screens/add_campaign.dart';
import './screens/home_screen.dart';
import './screens/auth_screen.dart';
import './screens/activity_screen.dart';
import './screens/add_activity.dart';
import './providers/auth.dart';
import './providers/activities.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: Activities(),
        ),
        ChangeNotifierProvider.value(
          value: Organizations(),
        ),
        ChangeNotifierProvider.value(
          value: Campaigns(),
        ),
      ],
      child: MaterialApp(
          title: 'Borhan',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: AuthScreen(),
          routes: {
            Home.routeName: (ctx) => Home(),
            ActivityScreen.routeName: (ctx) => ActivityScreen(),
            AddActivity.routeName: (ctx) => AddActivity(),
            AddCampaign.routeName: (ctx) => AddCampaign(),
          }),
    );
  }
}
