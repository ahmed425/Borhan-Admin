import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';
import './providers/activities.dart';
import './providers/campaigns.dart';
import './providers/history_provider.dart';
import './providers/organizations_logic.dart';
import './providers/email_provider.dart';
import './providers/video_provider.dart';
import './providers/donation_requests.dart';
import './screens/add_campaign.dart';
import './screens/activity_screen.dart';
import './screens/add_activity.dart';
import './screens/donation_tabs_screen.dart';
import './screens/donation_request_details.dart';
import './screens/home_screen.dart';
import './screens/auth_screen.dart';
import './screens/video_screen.dart';
import './screens/email_screen.dart';

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
        ChangeNotifierProvider.value(
          value: DonationRequests(),
        ),
        ChangeNotifierProvider.value(
          value: HistoryProvider(),
        ),
        ChangeNotifierProvider.value(
          value: Video(),
        ),
        ChangeNotifierProvider.value(
          value: EmailProvider(),
        ),
      ],
      child: MaterialApp(
          builder: (BuildContext context, Widget child) {
            return new Directionality(
              textDirection: TextDirection.rtl,
              child: new Builder(
                builder: (BuildContext context) {
                  return new MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaleFactor: 1.0,
                    ),
                    child: child,
                  );
                },
              ),
            );
          },
          title: 'Borhan',
          theme: ThemeData(
            primarySwatch: Colors.teal,
          ),
          home: AuthScreen(),
          routes: {
            Home.routeName: (ctx) => Home(),
            ActivityScreen.routeName: (ctx) => ActivityScreen(),
            AddActivity.routeName: (ctx) => AddActivity(),
            AddCampaign.routeName: (ctx) => AddCampaign(),
            VideoPlayerScreen.routeName: (ctx) => VideoPlayerScreen(),
            DonationTabsScreen.routeName: (ctx) => DonationTabsScreen(),
            DonationRequestDetailsScreen.routeName: (ctx) => DonationRequestDetailsScreen(),
            EmailScreen.routeName: (ctx) => EmailScreen(),
          }),
    );
  }
}
