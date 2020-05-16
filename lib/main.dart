import 'package:flutter/material.dart';
<<<<<<< Updated upstream
=======
import './providers/organization.dart';
import './providers/organizations_logic.dart';
import './screens/home_screen.dart';
import './screens/auth_screen.dart';
>>>>>>> Stashed changes
import 'package:provider/provider.dart';
import './screens/home_screen.dart';
import './screens/auth_screen.dart';
import './screens/activity_screen.dart';
import './screens/add_activity.dart';
import './providers/auth.dart';

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
          value: Organizations(),
        ),
        ChangeNotifierProvider.value(
          value: Organization(),
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
          }),
    );
  }
}
