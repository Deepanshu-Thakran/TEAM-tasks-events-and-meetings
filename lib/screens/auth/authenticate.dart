import 'package:flutter/material.dart';
import 'package:task_scheduler/screens/auth/register.dart';
import 'package:task_scheduler/screens/auth/sign_in.dart';

class Authenticate extends StatefulWidget{
  @override
  AuthenticateState createState() => AuthenticateState();

}

class AuthenticateState extends State<Authenticate>{

  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}