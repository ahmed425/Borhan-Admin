import 'dart:async';
import 'package:BorhanAdmin/providers/auth.dart';
import 'package:BorhanAdmin/screens/home_screen.dart';
import 'package:provider/provider.dart';

import '../screens/auth_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
//  @override
//  void initState() {
//    super.initState();
//
//  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    var shPref;
    var _isLoading = false;
    Provider.of<Auth>(context).loadSharedPrefs().then((value) => {
          print('fromm Splash Screen'),
          shPref = Provider.of<Auth>(context).userLoad,
          if (value != null)
            {
              _isLoading = true,
            }
        });
    Timer(
        Duration(seconds: 4),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) =>
                _isLoading ? Home() : AuthScreen())));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(57, 162, 139, 1),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Image.asset(
            'assets/images/borhan3.png',
            // width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
