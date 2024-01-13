import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_todo_app/models/todo_model.dart';
import 'package:firebase_todo_app/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  TextEditingController _todoController = TextEditingController();
  List<Todo> _todos = [];
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _checkInternetConnectivity();
    _loadTodos();

    // Subscribe to connectivity changes
    Connectivity().onConnectivityChanged.listen((result) {
      _checkInternetConnectivity();
    });
  }

  Future<void> _checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isOffline = (connectivityResult == ConnectivityResult.none);
    });
  }

  Future<void> _loadTodos() async {
    try {
      List<Todo> todos = await _firebaseService.getTodos();
      setState(() {
        _todos = todos;
        _isOffline = false; // Reset the offline status when data is successfully loaded.
      });
    } catch (e) {
      print('Error loading todos: $e');
      setState(() {
        _isOffline = true;
      });
    }
  }

  Future<void> _addTodo() async {
    String title = _todoController.text.trim();
    if (title.isNotEmpty) {
      Todo newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        isCompleted: false,
      );
      try {
        await _firebaseService.addTodo(newTodo);
      } catch (_) {
        print('Log: Todo Failed');
      }
      _loadTodos();
      _todoController.clear();
    }
  }

  Future<void> _toggleTodoStatus(String todoId, bool isCompleted) async {
    await _firebaseService.updateTodoStatus(todoId, !isCompleted);
    _loadTodos();
  }

  Future<void> _deleteTodo(String todoId) async {
    try {
      print('Deleting todo with ID: $todoId');
      await _firebaseService.deleteTodo(todoId);
      print('Todo deleted successfully');
    } catch (e) {
      print('Error deleting todo: $e');
    }
    _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Todo App'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _loadTodos,
            child: Text('Refresh'),
          ),
          _isOffline
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'App is offline. Working in offline mode.',
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : Container(), // Empty container when not offline
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(labelText: 'New Todo'),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addTodo,
                  child: Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                Todo todo = _todos[index];
                return ListTile(
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text('${todo.id}'),
                  leading: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (bool? value) => _toggleTodoStatus(todo.id, todo.isCompleted),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteTodo(todo.id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
