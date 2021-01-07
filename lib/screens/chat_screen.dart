import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;
User loggedUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'Chat Screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String TextMessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp();
    getUser();
  }

  void getUser() async {
    try {
      final user = await _auth.currentUser;
      print ('before crashing');
      print(user.email);
      if (user != Null) {
        print('in side if condition ');
        loggedUser = user;
        print('logged Email :' + loggedUser.email.toString());
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pushNamed(context, LoginScreen.id) ;
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            messagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        TextMessage = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      messageTextController.clear();
                      _firestore.collection('messages').add(
                          {'text': TextMessage, 'Sender': loggedUser.email ,"messageTime": numberOfmessage});
                      numberOfmessage = numberOfmessage + 1 ;
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BubbleButton extends StatelessWidget {
  final text;
  final sender;
  final bool isMe ;
  BubbleButton({this.sender, this.text , this.isMe});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:isMe? CrossAxisAlignment.end :  CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style: TextStyle(
              color: Colors.black45,
              fontSize: 12,
            ),
          ),
          Material(
              borderRadius: isMe?BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)) :
              BorderRadius.only(
                  bottomRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
              color: isMe?Colors.lightBlueAccent : Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 10.0),
                child: Text(
                  '$text',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: isMe?Colors.white : Colors.black45,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class messagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').orderBy('messageTime', descending: false).snapshots(),
        builder: (context, snapshot) {
          // if (!snapshot.hasData) {
          //   return Center(
          //     child: CircularProgressIndicator(
          //       backgroundColor: Colors.lightBlueAccent,
          //     ),
          //   );
          // }
          List<BubbleButton> BubbleWidgets = [];
          final messages = snapshot.data.docs;
          for (var message in messages) {
            final mess = message.data();

            final text = mess['text'];
            final sender = mess['Sender'];
            print ('text : '+ text + '   sender' + sender);

            final currentUser = loggedUser.email;
            print ('from massege stream : ' + 'Sender :'+sender.toString() +'   current :'+ currentUser);
            print ((currentUser == sender ?true:false).toString());
            final bubbleMessageWidget =
                BubbleButton(sender: sender, text: text , isMe:currentUser == sender ?true:false);
            BubbleWidgets.add(bubbleMessageWidget);
          }

          return Expanded(
            child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                children: BubbleWidgets),
          );
        });
  }
}
