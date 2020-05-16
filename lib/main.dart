import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      ],
      child: MaterialApp(
          title: 'Borhan',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
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
