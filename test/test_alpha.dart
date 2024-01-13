import 'dart:js_util';

import 'package:firebase_todo_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
// Example function to test
  int add(int a, int b) {
    return a + b;
  }

// Unit Test
  test('Addition of two numbers', () {
    expect(add(2, 3), equals(5));
  });
}

class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => print('Button Pressed'),
      child: Text('Press Me'),
    );
  }
}

// void main() {
//   // Widget to test

// // Widget Test
//   testWidgets('Renders a button', (WidgetTester tester) async {
//     await tester.pumpWidget(MyButton());
//     expect(find.text('Press Me'), findsOneWidget);
//   });
// }

// Integration Test
// void main() {
//   testWidgets('Navigate from home to profile screen', (WidgetTester tester) async {
//     await tester.pumpWidget(MyApp());
//     await tester.tap(find.byKey(homeButtonKey));
//     await tester.pumpAndSettle();
//     expect(find.byKey(profileScreenKey), findsOneWidget);
//   });
// }
