import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Everything the user adds to the list is a task.
//Task provider is self explanatory and its job is being the provider for the project.

class Task {
  final String id;
  String description;
  DateTime dueDate;
  TimeOfDay dueTime;
  bool isDone;

  Task({
    @required this.id,
    @required this.description,
    this.dueDate,
    this.dueTime,
    this.isDone = false,
  });
}

class TaskProvider with ChangeNotifier {
  List<Task> get itemsList {


  //  _toDoList=[];
    updateList();
    return _toDoList;
  }

  Future<void> updateList() async {
    _toDoList=[];
    String email;
    await FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
     email = await getFamilyEmail(user);

    Firestore.instance
        .collection("Families")
        .document(email)
        .collection("Todo")
        .snapshots()
        .forEach((element) {
          element.documents.forEach((doc) {
            _toDoList.add(Task(id: doc.documentID, description: doc['description'], dueDate: DateTime.parse(doc['dueDate'].toString().substring(0,10)), dueTime: TimeOfDay(hour:int.parse(doc['dueTime'].toString().substring(10,12)), minute: int.parse(doc['dueTime'].toString().substring(13,15)))));
          });
    });
    });

 }

   List<Task> _toDoList = [
    Task(
      id: 'task#1',
      description: 'Create my models',
      dueDate: DateTime.now(),
      dueTime: TimeOfDay.now(),
    ),
    Task(
      description: 'Add provider',
      id: 'task#2',
      dueDate: DateTime.now(),
      dueTime: TimeOfDay.now(),
    ),


  ];




  Task getById(String id) {
    return _toDoList.firstWhere((task) => task.id == id);
  }

  Future<String> getFamilyEmail(FirebaseUser user) async {

    String family_email;
     family_email= await Firestore.instance
        .collection('users')
        .document(user.uid)
        .get()
        .then((value) {
      return value.data['fam_email'];
    });

   return family_email;
  }


  Future<void> createNewTask(Task task) async {
    final newTask = Task(
      id: task.id,
      description: task.description,
      dueDate: task.dueDate,
      dueTime: task.dueTime,
    );



    String email;
    await FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      String email = await getFamilyEmail(user);

      Firestore.instance
          .collection("Families")
          .document(email)
          .collection("Todo")
          .document(task.id)
          .setData({
        'description': task.description,
        'dueDate': task.dueDate.toString(),
        'dueTime': task.dueTime.toString(),
    });
    });
    _toDoList.add(newTask);
    notifyListeners();
  }


  void editTask(Task task) {
    removeTask(task.id);
    createNewTask(task);
  }

  void removeTask(String id) {
    _toDoList.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void changeStatus(String id) {
    int index = _toDoList.indexWhere((task) => task.id == id);
    _toDoList[index].isDone = !_toDoList[index].isDone;
    //print('PROVIDER ${_toDoList[index].isDone.toString()}');
  }
}
