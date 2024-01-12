import 'package:firebase_todo_app/models/todo_model.dart';
import 'package:firebase_todo_app/services/firebase_service.dart';
import 'package:flutter/material.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  TextEditingController _todoController = TextEditingController();
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    List<Todo> todos = await _firebaseService.getTodos();
    setState(() {
      _todos = todos;
    });
  }

  Future<void> _addTodo() async {
    String title = _todoController.text.trim();
    if (title.isNotEmpty) {
      Todo newTodo = Todo(id: DateTime.now().millisecondsSinceEpoch.toString(), title: title, isCompleted: false);
      await _firebaseService.addTodo(newTodo);
      _loadTodos();
      _todoController.clear();
    }
  }

  Future<void> _toggleTodoStatus(String todoId, bool isCompleted) async {
    await _firebaseService.updateTodoStatus(todoId, !isCompleted);
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
          ElevatedButton(onPressed: () => {
            _loadTodos()
          }, child: Text('Refresh')),
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
                  title: Text(todo.title),
                  leading: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (bool? value) => _toggleTodoStatus(todo.id, todo.isCompleted),
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
