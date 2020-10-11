import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_scheduler/models/task.dart';
import 'package:task_scheduler/screens/home/edit_task.dart';
import 'package:task_scheduler/services/database.dart';

class TaskTile extends StatefulWidget {

  final Task task;
  TaskTile({this.task});

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile>{

  bool _newStatus;
  DateTime date;

  void initState() {
    super.initState();
    date = widget.task.date;
  }

  void _editPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: EditTask(task: widget.task),
            );
          });
    }

  Future<String> getCurrentUser() async {
    FirebaseUser _user;
    _user = await FirebaseAuth.instance.currentUser();
    String userid = _user.uid;
    return userid;
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          onTap: () async {
            _editPanel();
          },
          leading: CircleAvatar(
            radius: 15.0,
            backgroundColor: Colors.green[widget.task.importance*200],
          ),
          title: Text(
              widget.task.name,
            style: widget.task.status ? TextStyle(decoration: TextDecoration.lineThrough) : null,
          ),
          subtitle: Text('${widget.task.date.hour.toString().padLeft(2,'0')}:${widget.task.date.minute.toString().padLeft(2,'0')} on date:${widget.task.date.day.toString().padLeft(2,'0')}-${widget.task.date.month.toString().padLeft(2,'0')}-${widget.task.date.year.toString()}'),
          trailing: FlatButton(
              onPressed: () async {
               setState(() {
                 _newStatus = !widget.task.status;
               });
               await DatabaseService(taskName: widget.task.name, uid: await getCurrentUser()).updateUserData(
                   widget.task.name,
                   widget.task.importance,
                   _newStatus,
                   widget.task.date,
               );
              },
              child: (widget.task.status ? Icon(Icons.check_box, color: Colors.green,) : Icon(Icons.check_box_outline_blank, color: Colors.grey)),
          ),
        ),
      ),
    );
  }
  
}