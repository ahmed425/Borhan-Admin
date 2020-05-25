import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';
import '../models/chat.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var _enteredMessage = '';
  var _isInit = true;
  var chat = Chat(
      time: '',
      text: '',
      userId: '121212dfdf',
      userName: 'Admin',
      img: '',
      id: null);

  final _controller = new TextEditingController();

  void _sendMessage() {
    FocusScope.of(context).unfocus();
    Provider.of<ChatProvider>(context, listen: false)
        .addMessage(chat)
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
      Provider.of<ChatProvider>(context).fetchAndSetChat();
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
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                future: FirebaseAuth.instance.currentUser(),
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
                        chatDocs.items[index].userId != "121212dfdf",
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
                      onChanged: (value) {
                        setState(() {
                          _enteredMessage = value;
                        });
                        print('from wigdet Message is : ' + value);
                        _isInit = true;
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
