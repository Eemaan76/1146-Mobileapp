import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isDark = false; // theme control

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // TERNARY OPERATOR
      theme: isDark ? ThemeData.dark() : ThemeData.light(),

      home: Scaffold(
        appBar: AppBar(
          title: Text("Task 1 of lab 6"),

          actions: [
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: () {
                setState(() {
                  isDark = !isDark; // toggle theme
                });
              },
            ),
          ],
        ),

        body: Center(
          child: Text("this is me eman from se a"),
        ),
      ),
    );
  }
}