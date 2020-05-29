import 'package:BorhanAdmin/providers/auth.dart';
import 'package:BorhanAdmin/providers/chat_provider.dart';
import 'package:BorhanAdmin/providers/organizations_provider.dart';
import 'package:BorhanAdmin/providers/user_chat_provider.dart';
import 'package:BorhanAdmin/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/activities.dart';

class AllUsersChatScreen extends StatefulWidget {
  static const routeName = '/usersChat';

  @override
  _UsersChatScreenState createState() => _UsersChatScreenState();
}

class _UsersChatScreenState extends State<AllUsersChatScreen> {
  String orgId = '';
  var _isInit = true;
  var _isLoading = false;

//  String currentUserId = '1212145f';
//String currentUserId ='M8CoA0TH86hmKSikh1K';
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final data = Provider.of<Auth>(context);
      Provider.of<Organizations>(context)
          .fetchAndSetOrg(data.adminData.id)
          .then((value) => {
                orgId = value.id,
                print(orgId),
                Provider.of<UserChatProvider>(context)
                    .fetchAndSetAllUsers(orgId)
                    .then((_) => {
                          print('from provider'),
                          setState(() {
                            _isLoading = false;
                          }),
                        }),
              });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final allUsers = Provider.of<UserChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('المحادثات'),
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            Container(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) =>
                          buildItem(context, allUsers.users, index),
                      itemCount: allUsers.users.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, List<String> documents, int i) {
    if (documents[i] == null) {
      return Container();
    } else {
//      print("documents"+documents.toString());
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                child: Icon(
                  Icons.account_circle,
                  size: 50.0,
                ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'البريد الألكتروني للعميل: ${documents[i]}',
                          style: TextStyle(color: Colors.teal),
                        ),
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChatScreen(id: documents[i].split('.')[0])));
          },
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }
}