import 'dart:async';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:app_settings/app_settings.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import 'home_screen.dart';

enum AuthMode { ResetPassword, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.teal[50],
            ),
            SingleChildScrollView(
              child: Container(
                height: deviceSize.height,
                width: deviceSize.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 94.0),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: deviceSize.width > 600 ? 2 : 1,
                      child: AuthCard(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  StreamSubscription connectivitySubscription;
  ConnectivityResult _previousResult;
  bool dialogShown = false;

  Future<bool> checkinternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      }
    } on SocketException catch (_) {
      return Future.value(false);
    }
  }

  @override
  void initState() {
    super.initState();
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connresult) {
      if (connresult == ConnectivityResult.none) {
        dialogShown = true;
        showDialog(
            context: context,
            barrierDismissible: false,
            child: (Platform.isAndroid)
                ? AlertDialog(
                    title: const Text('حدث خطأ ما '),
                    content: Text(
                        'فقدنا الاتصال بالانترنت  ،\n تأكد من اتصالالك وحاول مرة أخرى'),
                    actions: <Widget>[
                        FlatButton(
                            onPressed: () => {
                                  Navigator.pop(context),
                                },
                            child: Text(
                              'خروج ',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )),
                        FlatButton(
                            onPressed: () => {
                                  AppSettings.openWIFISettings(),
                                },
                            child: Text(
                              ' اعدادت Wi-Fi ',
                              style: TextStyle(color: Colors.blue),
                            )),
                        FlatButton(
                            onPressed: () => {
                                  AppSettings.openDataRoamingSettings(),
                                },
                            child: Text(
                              ' اعدادت الباقه ',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ))
                      ])
                : CupertinoAlertDialog(
                    title: const Text('حدث خطأ ما '),
                    content: Text(
                        'فقدنا الاتصال بالانترنت  ،\n تأكد من اتصالالك وحاول مرة أخرى'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                          onPressed: () => {
                                AppSettings.openWIFISettings(),
                              },
                          child: Text(
                            ' اعدادت Wi-Fi ',
                            style: TextStyle(color: Colors.blue),
                          )),
                      CupertinoDialogAction(
                          onPressed: () => {
                                AppSettings.openDataRoamingSettings(),
                              },
                          child: Text(
                            ' اعدادت الباقه ',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          )),
                      CupertinoDialogAction(
                        onPressed: () => {
                          Navigator.pop(context),
                        },
                        child: Text(
                          'خروج ',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ));
      } else if (_previousResult == ConnectivityResult.none) {
        checkinternet().then((result) {
          if (result == true) {
            if (dialogShown == true) {
              dialogShown = false;
              Navigator.pop(context);
            }
          }
        });
      }
      _previousResult = connresult;
    });
  }

  @override
  void dispose() {
    super.dispose();
    connectivitySubscription.cancel();
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => (Platform.isAndroid)
          ? AlertDialog(
              title: Text('حدث خطأ ما'),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text('حسنا'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            )
          : CupertinoAlertDialog(
              title: Text('خطأ'),
              content: Text('حدث خطأ ما'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('حسنا'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      print('not valid');
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_authMode == AuthMode.Login) {
      try {
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      } catch (error) {
        const errorMessage =
            'البريد الإلكتروني أو كلمة المرور غير صحيحة,رجاء المحاولة مرة أخري';
        _showErrorDialog(errorMessage);
      }
    } else {
      await Provider.of<Auth>(context, listen: false)
          .resetPassword(_authData['email']);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.ResetPassword;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.ResetPassword ? 320 : 260,
        constraints: BoxConstraints(
            minHeight: _authMode == AuthMode.ResetPassword ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'البريد الإلكتروني'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'يجب إدخال البريد الإلكتروني';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                if (_authMode == AuthMode.Login)
                  TextFormField(
                    decoration: InputDecoration(labelText: 'كلمة المرور'),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'يجب إدخال كلمة المرور';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
                    },
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child: Text(_authMode == AuthMode.Login
                        ? 'تسجيل الدخول'
                        : 'إرسال رابط تغيير كلمة المرور'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'هل نسيت كلمة المرور؟' : 'الرجوع إلي تسجيل الدخول'} '),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
