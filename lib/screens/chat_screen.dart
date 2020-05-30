import 'package:BorhanAdmin/providers/auth.dart';
import 'package:BorhanAdmin/providers/organizations_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';
import '../models/chat.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';
  var id = '';

  ChatScreen({this.id});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // the id for specific user i(admin) chat with him
//  var id = '1212145f';
  String orgId = '';
  var _enteredMessage = '';
  var _isInit = true;
  var chat = Chat(
      time: '',
      text: '',
      userId: 'Admin Id',
      userName: 'Admin',
      img: '',
      id: null);

  final _controller = new TextEditingController();

  void _sendMessage() {
    FocusScope.of(context).unfocus();
    Provider.of<ChatProvider>(context, listen: false)
        .addMessage(chat, widget.id, orgId)
        .then((value) => {
              _controller.clear(),
              _enteredMessage = '',
              print('from add message'),
            });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      final data = Provider.of<Auth>(context);
      Provider.of<Organizations>(context)
          .fetchAndSetOrg(data.adminData.id)
          .then((value) => {
                orgId = value.id,
                print(orgId),
                Provider.of<ChatProvider>(context)
                    .fetchAndSetChat(widget.id, orgId),
              });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future _getData() async {
    final url =
        'https://borhanadmin.firebaseio.com/chat/$orgId/$widget.id.json';
    var response = await http.get(url);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    final chatDocs = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('المحادثة'),
      ),
      body: Container(
        color: Colors.teal[100],
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                future: _getData(),
                builder: (ctx, futureSnapshot) {
                  if (futureSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return StreamBuilder(builder: (ctx, chatSnapshot) {
                    if (chatSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      reverse: true,
                      itemCount: chatDocs.items.length,
                      itemBuilder: (_, index) => MessageBubble(
                        chatDocs.items[index].text,
                        chatDocs.items[index].userName,
                        chatDocs.items[index].userName != "Admin",
                      ),
                    );
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(labelText: 'كتابة رسالة ...'),
                      onTap: () {
//                        _isInit = true;
                      },
                      onChanged: (value) {
                        setState(() {
                          _enteredMessage = value;
                        });
                        print('from wigdet Message is : ' + value);
//                        _isInit = true;
                        Provider.of<ChatProvider>(context)
                            .fetchAndSetChat(widget.id, orgId);
                        chat = Chat(
                          img: chat.img,
                          text: value,
                          userName: chat.userName,
                          userId: chat.userId,
                          id: chat.id,
                          time: chat.time,
                        );
                      },
                    ),
                  ),
                  IconButton(
                    color: Theme.of(context).primaryColor,
                    icon: Icon(
                      Icons.send,
                    ),
                    onPressed:
                        _enteredMessage.trim().isEmpty ? null : _sendMessage,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
