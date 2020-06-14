import 'package:BorhanAdmin/providers/organizations_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';
import '../models/chat.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';
  final orgLocalId;

  final id;

  ChatScreen({this.id, this.orgLocalId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String orgId = '';
  var _enteredMessage = '';
  var _isInit = true;
  bool _loading = false;
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
    chat = Chat(
      img: chat.img,
      text: _enteredMessage,
      userName: chat.userName,
      userId: chat.userId,
      id: chat.id,
      time: chat.time,
    );
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
    if (_isInit) {
      Provider.of<Organizations>(context)
          .fetchAndSetOrg(widget.orgLocalId)
          .then((value) => {
                orgId = value.id,
                print(orgId),
                Provider.of<ChatProvider>(context)
                    .fetchAndSetChat(widget.id, orgId)
                    .then((value) => {
                          _loading = true,
                        }),
              });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final chatDocs = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('المحادثة'),
      ),
      body: _loading
          ? Container(
              color: Colors.teal[100],
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: FutureBuilder(
                      future: chatDocs.fetchAndSetChat(widget.id, orgId),
                      builder: (ctx, futureSnapshot) {
                        return StreamBuilder(builder: (ctx, chatSnapshot) {
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
                            decoration:
                                InputDecoration(labelText: 'كتابة رسالة ...'),
                            onChanged: (value) {
                              setState(() {
                                _enteredMessage = value;
                              });
                              print('from wigdet Message is : ' +
                                  _enteredMessage);
                            },
                          ),
                        ),
                        IconButton(
                          color: Theme.of(context).primaryColor,
                          icon: Icon(
                            Icons.send,
                          ),
                          onPressed: _enteredMessage.trim().isEmpty
                              ? null
                              : _sendMessage,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
