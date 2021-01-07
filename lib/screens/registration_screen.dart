import'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import '../Helper Classes.dart';
import 'chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'RegisterScreen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool showSpinner = false ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner ,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    KtextFieldDecoration.copyWith(hintText: 'Enter Your Email '),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: KtextFieldDecoration.copyWith(
                    hintText: 'Enter Your Password '),
              ),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: SignInButton(
                    buttonText: 'Register Now',
                    buttonColor: Colors.lightBlueAccent,
                    OnPressed: () async
                    {
                      setState(() {
                        showSpinner = true ;
                      });
                      try{
                        Firebase.initializeApp();
                        final newUser = await  _auth.createUserWithEmailAndPassword(email: email, password: password);
                        print(newUser);
                        if (newUser !=  Null )
                          {
                            Navigator.pushNamed(context, ChatScreen.id);
                          }
                        setState(() {
                          showSpinner = false ;
                        });
                      }
                      catch (e)
                      {
                        print (e);
                      }
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
