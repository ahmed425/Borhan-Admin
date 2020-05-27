import './providers/chat_provider.dart';
import './providers/user_chat_provider.dart';
import './screens/all_users_chat.dart';
import 'package:BorhanAdmin/providers/chat_provider.dart';
import 'package:BorhanAdmin/providers/image_chat.dart';
import 'package:BorhanAdmin/screens/chat_screen.dart';
import 'package:BorhanAdmin/screens/help_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';
import './providers/activities.dart';
import './providers/campaigns.dart';
import './providers/history_provider.dart';
import './providers/organizations_provider.dart';
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
        ChangeNotifierProvider.value(
          value: ChatProvider(),
        ),
        ChangeNotifierProvider.value(
          value: ImageChat(),
        ),
        ChangeNotifierProvider.value(
          value: UserChatProvider(),
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
            DonationRequestDetailsScreen.routeName: (ctx) =>
                DonationRequestDetailsScreen(),
            HelpScreen.routeName: (ctx) => HelpScreen(),
            EmailScreen.routeName: (ctx) => EmailScreen(),
            ChatScreen.routeName: (ctx) => ChatScreen(),
            AllUsersChatScreen.routeName: (ctx) => AllUsersChatScreen(),
          }),
    );
  }
}
