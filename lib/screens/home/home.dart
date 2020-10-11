import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_scheduler/models/task.dart';
import 'package:task_scheduler/screens/home/task_list.dart';
import 'package:task_scheduler/services/auth.dart';
import 'package:task_scheduler/services/database.dart';
import 'package:provider/provider.dart';
import 'new_form.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final FirebaseAuth _auth = AuthService().auth;

  String userId;
  Future inputData() async {
    final user =  await _auth.currentUser();
    return user.uid;
  }




  @override
  void initState() {
    super.initState();
    inputData().then((value) {
      setState(() {
        userId = value;
        print(userId);
      });
    });
    print(userId);
  }

  @override
  Widget build(BuildContext context) {
    void _addNewPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: NewForm(),
            );
          });
    }

    return StreamProvider<List<Task>>.value(
      value: DatabaseService(uid: userId).tasks,
      child: Scaffold(
        backgroundColor: Colors.orangeAccent[50],
        appBar: AppBar(
          title: Text("My Tasks"),
          backgroundColor: Colors.orangeAccent[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.exit_to_app),
              label: Text("Logout"),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: TaskList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _addNewPanel();
          },
          backgroundColor: Colors.pink[400],
          child: Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}
