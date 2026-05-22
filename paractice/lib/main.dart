import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // Theme change krny k liye
  bool isDark = false;

  // Schedule data
  List<Map<String, String>> classes = [
    {
      "time": "8:00 - 9:30 AM",
      "subject": "Flutter Development",
      "room": "Room 201"
    },
    {
      "time": "10:00 - 11:30 AM",
      "subject": "Data Science",
      "room": "Room 105"
    },
    {
      "time": "12:00 - 1:30 PM",
      "subject": "AI",
      "room": "Room 301"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      // Dark or light mode
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),

      home: Scaffold(
        appBar: AppBar(
          title: Text("My Schedule"),

          actions: [
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
              ),

              onPressed: () {
                setState(() {
                  isDark = !isDark;
                });
              },
            )
          ],
        ),

        body: Padding(
          padding: EdgeInsets.all(16),

          child: Column(
            children: classes.map((item) {

              return Column(
                children: [

                  Card(
                    elevation: 5,

                    child: Padding(
                      padding: EdgeInsets.all(16),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            item["time"]!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 10),

                          Text(
                            item["subject"]!,
                            style: TextStyle(fontSize: 16),
                          ),

                          SizedBox(height: 10),

                          Text(
                            item["room"]!,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 15),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}