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
  @override
  void didChangeDependencies() {
    var _isLoading = false;
    Provider.of<Auth>(context).loadSharedPrefs().then((value) => {
          if (value != null)
            {
              _isLoading = true,
            }
        });
    Timer(
        Duration(seconds: 4),
        () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    _isLoading ? Home() : AuthScreen(),
              ),
            ));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
