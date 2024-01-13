import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo_app/models/todo_model.dart';

class FirebaseService {
  final CollectionReference todos = FirebaseFirestore.instance.collection('todos');

  Future<List<Todo>> getTodos() async {
    try {
      QuerySnapshot querySnapshot = await todos.get();
      return querySnapshot.docs.map((doc) {
        print(doc.data());
        print(doc.id);
        var todo = Todo.fromMap(doc.data() as Map<String, dynamic>);
        return Todo(id: doc.id, title: todo.title,isCompleted: todo.isCompleted);
      }).toList();
    } catch (e) {
      print('Error getting todos: $e');
      return []; // Return an empty list or handle the error as needed
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      await todos.add(todo.toMap()).asStream().handleError((e) {
        print('Stream Error $e');
      });
    } catch (e) {
      print('Error adding todo: $e');
      throw Exception('You are offline');
    }
  }

  Future<void> updateTodoStatus(String todoId, bool isCompleted) async {
    try {
      await todos.doc(todoId).update({'isCompleted': isCompleted});
    } catch (e) {
      print('Error updating todo status: $e');
    }
  }

  Future<void> deleteTodo(String todoId) async {
    try {
      await todos.doc('$todoId').delete().asStream().handleError((e) {
        print('Stream Error $e');
      });
    } catch (e) {
      print('Error deleting todo: $e');
      throw Exception('You are offline');
    }
  }
}
