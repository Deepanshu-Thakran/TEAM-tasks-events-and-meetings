import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_scheduler/models/task.dart';
import 'package:task_scheduler/models/user.dart';

class DatabaseService {
  final String uid;
  final String taskName;
  DatabaseService({this.taskName, this.uid});

  //collection reference
  CollectionReference userCollection = Firestore.instance.collection('users');
  CollectionReference taskCollection = Firestore.instance.collection('tasks');

  Future updateUserData(
      String name, int importance, bool status, DateTime date) async {
    return await userCollection
        .document(uid)
        .collection('tasks')
        .document(taskName)
        .setData({
      'name': name,
      'importance': importance,
      'status': status,
      'date': date,
    });
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  String userId;
  Future<void> inputData() async {
    final FirebaseUser user = await auth.currentUser();
    userId = user.uid;
    print(userId);
    return userId;
  }

  Future newUserData() async {
    return await userCollection.document(uid).setData({
      'uID': uid,
    });
  }

  //task list from snapshot
  List<Task> _taskListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Task(
        name: doc.data['name'] ?? '',
        importance: doc.data['importance'] ?? 0,
        status: doc.data['status'] ?? false,
        date: doc.data['date'].toDate() ?? DateTime.now(),
      );
    }).toList();
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      name: snapshot.data['name'],
      importance: snapshot.data['importance'],
      status: snapshot.data['status'],
    );
  }

  //get task stream
  Stream<List<Task>> get tasks {
    return userCollection
        .document(uid)
        .collection('tasks')
        .snapshots()
        .map(_taskListFromSnapshot);
  }

  //get user doc
  Stream<UserData> get userData {
    return userCollection
        .document(uid)
        .collection('tasks')
        .document(taskName)
        .snapshots()
        .map(_userDataFromSnapshot);
  }
}
