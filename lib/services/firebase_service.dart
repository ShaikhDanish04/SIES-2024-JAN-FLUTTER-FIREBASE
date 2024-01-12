import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo_app/models/todo_model.dart';

class FirebaseService {
  final CollectionReference todos = FirebaseFirestore.instance.collection('todos');

  Future<List<Todo>> getTodos() async {
    try {
      QuerySnapshot querySnapshot = await todos.get();
      return querySnapshot.docs.map((doc) => Todo.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error getting todos: $e');
      return []; // Return an empty list or handle the error as needed
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      await todos.add(todo.toMap());
    } catch (e) {
      print('Error adding todo: $e');
    }
  }

  Future<void> updateTodoStatus(String todoId, bool isCompleted) async {
    try {
      await todos.doc(todoId).update({'isCompleted': isCompleted});
    } catch (e) {
      print('Error updating todo status: $e');
    }
  }
}
