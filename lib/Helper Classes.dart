import 'package:flutter/material.dart';
class SignInButton extends StatelessWidget {
  SignInButton({this.buttonText , this.buttonColor , this.OnPressed});
  final String buttonText ;
  final Color buttonColor ;
  final Function OnPressed ;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color:buttonColor ,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: () {
            OnPressed();
          },
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            buttonText ,
            style:TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
