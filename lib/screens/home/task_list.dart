import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:task_scheduler/models/task.dart';
import 'package:task_scheduler/screens/home/task_tile.dart';

class TaskList extends StatefulWidget{
  @override
  _TaskListState createState() => _TaskListState();

}

class _TaskListState extends State<TaskList>{
  @override
  Widget build(BuildContext context) {

    final tasks = Provider.of<List<Task>>(context) ?? [];

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskTile(task: tasks[index]);
      },
    );
  }

}