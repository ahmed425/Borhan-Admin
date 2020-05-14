import 'dart:math';

import 'package:flutter/material.dart';
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
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
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'مرحبا بك في برهان',
                        style: TextStyle(
                          color: Theme.of(context).accentTextTheme.title.color,
                          fontSize: 25,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
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
            child: Text('Okay'),
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
      }
      //  on HttpException catch (error) {
      //   var errorMessage = 'Authentication failed';
      //   if (error.toString().contains('INVALID_EMAIL')) {
      //     errorMessage = 'This is not a valid email address';
      //   }  else if (error.toString().contains('EMAIL_NOT_FOUND')) {
      //     errorMessage = 'Could not find a user with that email.';
      //   } else if (error.toString().contains('INVALID_PASSWORD')) {
      //     errorMessage = 'Invalid password.';
      //   }
      //   _showErrorDialog(errorMessage);
      // }
      catch (error) {
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
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
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
                      if (value.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
                    },
                  ),
                // if (_authMode == AuthMode.ResetPassword)
                //   TextFormField(
                //     enabled: _authMode == AuthMode.ResetPassword,
                //     decoration: InputDecoration(labelText: 'Confirm Password'),
                //     obscureText: true,
                //     validator: _authMode == AuthMode.ResetPassword
                //         ? (value) {
                //             if (value != _passwordController.text) {
                //               return 'Passwords do not match!';
                //             }
                //           }
                //         : null,
                //   ),
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

// import 'dart:io';
// import 'dart:math';

// import 'package:BorhanAdmin/providers/auth.dart';
// import 'package:BorhanAdmin/screens/home_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// // import '../models/http_exception.dart';
// enum AuthMode { Login, Reset }

// class AuthScreen extends StatelessWidget {
// //  static const routeName = '/auth';
//   @override
//   Widget build(BuildContext context) {
//     final deviceSize = MediaQuery.of(context).size;
//     // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
//     // transformConfig.translate(-10.0);
//     return Scaffold(
//       // resizeToAvoidBottomInset: false,
//       body: Stack(
//         children: <Widget>[
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
//                   Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 stops: [0, 1],
//               ),
//             ),
//           ),
//           SingleChildScrollView(
//             child: Container(
//               height: deviceSize.height,
//               width: deviceSize.width,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Flexible(
//                     child: Container(
//                       margin: EdgeInsets.only(bottom: 20.0),
//                       padding:
//                           EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
//                       transform: Matrix4.rotationZ(-8 * pi / 180)
//                         ..translate(-10.0),
//                       // ..translate(-10.0),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: Colors.deepOrange.shade900,
//                         boxShadow: [
//                           BoxShadow(
//                             blurRadius: 8,
//                             color: Colors.black26,
//                             offset: Offset(0, 2),
//                           )
//                         ],
//                       ),
//                       child: Text(
//                         'مرحبا بك في برهان',
//                         style: TextStyle(
//                           color: Theme.of(context).accentTextTheme.title.color,
//                           fontSize: 25,
//                           fontFamily: 'Anton',
//                           fontWeight: FontWeight.normal,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Flexible(
//                     flex: deviceSize.width > 600 ? 2 : 1,
//                     child: AuthCard(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AuthCard extends StatefulWidget {
//   const AuthCard({
//     Key key,
//   }) : super(key: key);

//   @override
//   _AuthCardState createState() => _AuthCardState();
// }

// class _AuthCardState extends State<AuthCard> {
//   final GlobalKey<FormState> _formKey = GlobalKey();
//   AuthMode _authMode = AuthMode.Login;

//   Map<String, String> _authData = {
//     'email': '',
//     'password': '',
//   };
//   var _isLoading = false;
//   final _passwordController = TextEditingController();
//   void _showErrorDialog(String message) {
//     print("alert");
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text('حدث خطأ ما'),
//         content: Text(message),
//         actions: <Widget>[
//           FlatButton(
//             child: Text('Okay'),
//             onPressed: () {
//               Navigator.of(ctx).pop();
//             },
//           )
//         ],
//       ),
//     );
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState.validate()) {
//       // Invalid!
//       return;
//     }
//     // _showErrorDialog("ghghvghvghvghg");
//     print("submit");
//     _formKey.currentState.save();
//     setState(() {
//       _isLoading = true;
//     });
//     if (_authMode == AuthMode.Login) {
//       try {
//         // Log user in
//         await Provider.of<Auth>(context, listen: false).login(
//           _authData['email'],
//           _authData['password'],
//         );
//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => Home()));
//         // Navigator.of(context).pushReplacementNamed('/home');
//       }
//       //  on HttpException catch (error) {
//       //   var errorMessage = 'Authentication failed';
//       //   if (error.toString().contains('INVALID_EMAIL')) {
//       //     errorMessage = 'This is not a valid email address';
//       //   }  else if (error.toString().contains('EMAIL_NOT_FOUND')) {
//       //     errorMessage = 'Could not find a user with that email.';
//       //   } else if (error.toString().contains('INVALID_PASSWORD')) {
//       //     errorMessage = 'Invalid password.';
//       //   }
//       //   _showErrorDialog(errorMessage);
//       // }
//       catch (error) {
//         const errorMessage =
//             'البريد الإلكتروني أو كلمة المرور غير صحيحة,رجاء المحاولة مرة أخري';
//         _showErrorDialog(errorMessage);
//       }
//     } else {}

//     // on HttpException catch (error) {
//     //   //  if (error.toString().contains('INVALID_PASSWORD')) {
//     //            _showErrorDialog("noooooooo");

//     //   // }
//     // }

//     // try {
//     //   await Provider.of<Auth>(context, listen: false).login(
//     //     _authData['email'],
//     //     _authData['password'],
//     //   );
//     // } on HttpException catch (error) {
//     //   var errorMessage;

//     //   if (error.toString().contains('INVALID_PASSWORD')) {
//     //     errorMessage = 'Invalid password.';
//     //   }
//     //   _showErrorDialog(errorMessage);
//     // } catch (error) {
//     //   const errorMessage =
//     //       'Could not authenticate you. Please try again later.';
//     //   _showErrorDialog(errorMessage);
//     // }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   void _switchAuthMode() {
//     if (_authMode == AuthMode.Login) {
//       setState(() {
//         _authMode = AuthMode.Reset;
//       });
//     } else {
//       setState(() {
//         _authMode = AuthMode.Login;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final deviceSize = MediaQuery.of(context).size;
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       elevation: 8.0,
//       child: Container(
//         height: 260,
//         constraints: BoxConstraints(minHeight: 260),
//         width: deviceSize.width * 0.75,
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: 'البريد الإلكتروني',
//                     // contentPadding:
//                     //     const EdgeInsets.only(left: 0, bottom: 10.0, top: 10.0),
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value.isEmpty || !value.contains('@')) {
//                       return 'Invalid email!';
//                     }
//                   },
//                   onSaved: (value) {
//                     _authData['email'] = value;
//                   },
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: 'كلمة المرور',
//                     // contentPadding: const EdgeInsets.only(
//                     //     left: 205, bottom: 10.0, top: 10.0),
//                   ),
//                   obscureText: true,
// //                  textAlign: TextAlign.right,
//                   controller: _passwordController,

//                   validator: (value) {
//                     if (value.isEmpty || value.length < 5) {
//                       return 'Password is too short!';
//                     }
//                   },
//                   onSaved: (value) {
//                     _authData['password'] = value;
//                   },
//                 ),
//                 if (_authMode == AuthMode.Reset)
//                   TextFormField(
//                     style: TextStyle(fontSize: 22.0),
//                     decoration: InputDecoration(
//                       labelText: 'البريد الإلكتروني',
//                       // contentPadding: const EdgeInsets.only(
//                       //     left: 205, bottom: 10.0, top: 10.0),
//                     ),
//                     onSaved: (value) => _email = value,
//                   ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 RaisedButton(
//                   child: Text('تسجيل الدخول'),
//                   onPressed: _submit,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
//                   color: Theme.of(context).primaryColor,
//                   textColor: Theme.of(context).primaryTextTheme.button.color,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
