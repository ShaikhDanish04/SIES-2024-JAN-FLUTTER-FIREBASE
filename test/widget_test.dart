// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_todo_app/firebase_options.dart';
import 'package:firebase_todo_app/services/firebase_service.dart';
import 'package:firebase_todo_app/views/pages/todo_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:firebase_todo_app/main.dart';
import 'package:firebase_todo_app/models/todo_model.dart';
import 'package:firebase_todo_app/services/firebase_service.dart';

void main() async {
  test('Test Todo model', () {
    Todo todo = Todo(id: '1', title: 'Test Todo', isCompleted: false);

    // Verify Todo properties
    expect(todo.id, '1');
    expect(todo.title, 'Test Todo');
    expect(todo.isCompleted, false);

    // Test Todo serialization
    Map<String, dynamic> todoMap = todo.toMap();
    Todo deserializedTodo = Todo.fromMap(todoMap);

    // Manually compare the properties
    expect(deserializedTodo.id, todo.id);
    expect(deserializedTodo.title, todo.title);
    expect(deserializedTodo.isCompleted, todo.isCompleted);
  });

  testWidgets('Test adding a new Todo with empty title', (WidgetTester tester) async {
    await tester.pumpWidget(TodoScreen());

    // Simulate user interaction
    await tester.enterText(find.byType(TextField), 'Add');
    await tester.tap(find.byType(ElevatedButton));

    // Wait for the widget to rebuild
    await tester.pump();

    // Verify that the Todo was not added
    expect(find.text(''), findsNothing);
  });
}
