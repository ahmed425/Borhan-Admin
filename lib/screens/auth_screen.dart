import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:connectivity/connectivity.dart';
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
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            color: Color.fromRGBO(57, 162, 139, 1),
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
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
//                      transform: Matrix4.rotationZ(-8 * pi / 180)
//                        ..translate(-10.0),
                      // ..translate(-10.0),
//                      decoration: BoxDecoration(
//                        borderRadius: BorderRadius.circular(20),
//                        color: Colors.deepOrange.shade900,
//                        boxShadow: [
//                          BoxShadow(
//                            blurRadius: 8,
//                            color: Colors.black26,
//                            offset: Offset(0, 2),
//                          )
//                        ],
//                      ),
                      child: Image.asset(
                        'assets/images/borhan3.png',
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
    // TODO: implement initState
    super.initState();
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connresult) {
      if (connresult == ConnectivityResult.none) {
        dialogShown = true;
        showDialog(
            context: context,
            barrierDismissible: false,
            child: AlertDialog(
                title: const Text('حدث خطأ ما '),
                content: Text(
                    'فقدنا الاتصال بالانترنت  ،\n تأكد من اتصالالك وحاول مرة أخرى'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () => {
//                            SystemChannels.platform
//                                .invokeMethod('SystemNavigator.pop'),
                            Navigator.pop(context),
                          },
                      child: Text(
                        'خروج ',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
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
                ]
//              actions: <Widget>[
//                FlatButton(
//                    onPressed: () => {
//                          SystemChannels.platform
//                              .invokeMethod('SystemNavigator.pop'),
////                          Navigator.pop(context),
//                        },
//                    child: Text(
//                      'خروج ',
//                      style: TextStyle(color: Colors.red),
//                    ))
//              ],
                ));
      } else if (_previousResult == ConnectivityResult.none) {
        checkinternet().then((result) {
          if (result == true) {
            if (dialogShown == true) {
              dialogShown = false;
              print(
                  '-------------------------put your fix here ----------------------');
//              getOrganizationsAndCampaign();

              Navigator.pop(context);
            }
          }
        });
      }
      _previousResult = connresult;
    });
  }
//
//  @override
//  void initState(){
//
//
//  }
//

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
    print("alert");
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
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
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_authMode == AuthMode.Login) {
      try {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
        // Navigator.of(context).pushReplacementNamed('/home');
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
