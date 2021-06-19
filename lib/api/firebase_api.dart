import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_family/model/todo.dart';
import 'package:my_family/utils.dart';

class FirebaseApi {
  static Future<String> createTodo(Todo todo) async {
    final docTodo = Firestore.instance.collection('todo').document();

    todo.id = docTodo.documentID;
    await docTodo.setData(todo.toJson());

    return docTodo.documentID;
  }

  static Stream<List<Todo>> readTodos() => Firestore.instance
      .collection('todo')
      .orderBy(TodoField.createdTime, descending: true)
      .snapshots()
      .transform(Utils.transformer(Todo.fromJson));

  static Future updateTodo(Todo todo) async {
    final docTodo = Firestore.instance.collection('todo').document(todo.id);

    await docTodo.updateData(todo.toJson());
  }

  static Future deleteTodo(Todo todo) async {
    final docTodo = Firestore.instance.collection('todo').document(todo.id);

    await docTodo.delete();
  }
}
