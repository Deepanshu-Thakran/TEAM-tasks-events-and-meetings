import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_scheduler/models/task.dart';
import 'package:task_scheduler/services/database.dart';
import 'package:task_scheduler/shared/constants.dart';

class EditTask extends StatefulWidget {

  final Task task;
  EditTask({this.task});

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final _formKey = GlobalKey<FormState>();

  DateTime _newDateTime;
  String _newName;
  int _newImportance;
  bool _newStatus;
  TimeOfDay _timeOfDay;

  Future<String> getCurrentUser() async {
    FirebaseUser _user;
    _user = await FirebaseAuth.instance.currentUser();
    String userid = _user.uid;
    return userid;
  }

  @override
  void initState() {
    super.initState();
    _newName = widget.task.name;
    _timeOfDay = TimeOfDay(hour: widget.task.date.hour, minute: widget.task.date.minute);
    _newDateTime = DateTime(widget.task.date.year, widget.task.date.month, widget.task.date.day);
    _newStatus = widget.task.status;
    _newImportance = widget.task.importance;
    mergeDateTime(_newDateTime, _timeOfDay);
  }

  mergeDateTime(DateTime date, TimeOfDay time) {
    setState(() {
      _newDateTime = date.add(Duration(hours: time.hour, minutes: time.minute));
    });
    print(_newDateTime.toString());
  }

  Future<Null> _datePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _newDateTime,
        firstDate: DateTime.now(),
        lastDate: DateTime(2025));

    if (picked != null && picked != _newDateTime) {
      print('Date selected ${_newDateTime.toString()}');
      setState(() {
        _newDateTime = picked;
        mergeDateTime(_newDateTime, _timeOfDay);
      });
    }
  }

  Future<Null> _timePicker(BuildContext context) async {
    final TimeOfDay timePicked =
        await showTimePicker(context: context, initialTime: _timeOfDay);
    if (timePicked != null && timePicked != _timeOfDay) {
      print('Date selected ${_timeOfDay.toString()}');
      setState(() {
        _timeOfDay = timePicked;
        mergeDateTime(_newDateTime, _timeOfDay);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text(
            'Edit Task',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            decoration: textInputDecoration.copyWith(hintText: 'Task Name',),
            initialValue: _newName,
            validator: (val) => val.isEmpty ? 'Please enter a name' : null,
            onChanged: (val) => setState(() => _newName = val),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: <Widget>[
              Text(
                'Importance',
                style: TextStyle(fontSize: 16.0),
              ),
              Expanded(
                child: Slider(
                  value: (_newImportance ?? 1).toDouble(),
                  activeColor: Colors.green[(_newImportance ?? 1) * 200],
                  inactiveColor: Colors.green[(_newImportance ?? 1) * 200],
                  min: 1,
                  max: 3,
                  divisions: 2,
                  onChanged: (val) =>
                      setState(() => _newImportance = val.round()),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: <Widget>[
              Text(
                '${_newDateTime.day}/${_newDateTime.month}/${_newDateTime.year}',
                style: TextStyle(fontSize: 17.0),
              ),
              Expanded(child: SizedBox()),
              IconButton(
                icon: Icon(Icons.calendar_today),
                color: Colors.green[400],
                onPressed: () {
                  _datePicker(context);
                },
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: <Widget>[
              Text(
                _timeOfDay.toString(),
                style: TextStyle(fontSize: 17.0),
              ),
              Expanded(child: SizedBox()),
              IconButton(
                icon: Icon(Icons.timer),
                color: Colors.green[400],
                onPressed: () {
                  _timePicker(context);
                },
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          RaisedButton(
            color: Colors.pink[400],
            child: Text(
              'Save Changes',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                await DatabaseService(
                        taskName: widget.task.name, uid: await getCurrentUser())
                    .updateUserData(
                  _newName,
                  _newImportance,
                  _newStatus,
                  _newDateTime,
                );
                Navigator.pop(context);
                print(_newName);
                print(_newStatus.toString());
                print(_newImportance.toString());
                print(_newDateTime.toString());
              }
            },
          ),
        ],
      ),
    );
  }
}