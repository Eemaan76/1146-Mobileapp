// todo_screen.dart

import 'package:flutter/material.dart';
import 'todo.dart';
import 'detail_screen.dart';

class TodosScreen extends StatelessWidget {
  TodosScreen({super.key});

  final List<Todo> todos = [
    Todo(
      title: "Morning Exercise",
      description: "30 minutes jogging and stretching",
    ),
    Todo(
      title: "Complete Assignment",
      description: "Finish Flutter UI task before evening",
    ),
    Todo(
      title: "Read a Book",
      description: "Read 20 pages of Atomic Habits",
    ),
    Todo(
      title: "Watch Tutorial",
      description: "Learn state management in Flutter",
    ),
    Todo(
      title: "Family Dinner",
      description: "Dinner with family at 8 PM",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Todos List")),
        backgroundColor: Colors.green,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];

          return ListTile(
            title: Text(todo.title),
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            leading: const Icon(Icons.task, color: Colors.green),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailScreen(todo: todo),
                ),
              );
            },
          );
        },
      ),
    );
  }
}