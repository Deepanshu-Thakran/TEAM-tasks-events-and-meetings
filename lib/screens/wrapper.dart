import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:task_scheduler/models/user.dart';
import 'package:task_scheduler/screens/auth/authenticate.dart';
import 'package:task_scheduler/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    print(user);

    // return either home or auth widget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
