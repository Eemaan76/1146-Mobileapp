import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}class _MyAppState extends State<MyApp> {
  bool isDark = false;
 List<Map<String, String>> classes = [
  {
    "time":"12:00-1:00 p.m",
    "subject" :"OOP",
    "room": "401",
  },
   {
    "time":"1:00-3:00 p.m",
    "subject" :"OOP",
    "room": "lab3",
  },
   {
    "time":"4:00-6:00 p.m",
    "subject" :"DB",
    "room": "7",
  }
    ];
@override 
Widget build(BuildContext context  ){
  return MaterialApp(
  themeMode:isDark ? ThemeMode.dark:ThemeMode.light,
  theme:ThemeData.light(),
  darkTheme:ThemeData.dark(),
home:Scaffold(
  appBar: AppBar(
    title: const Text('My schedule'),
  ),
body: Padding(
padding: const EdgeInsets.all(10),
child: Column(
children: [
Align(
alignment: Alignment.topLeft,
 child: IconButton(
icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
onPressed: () {
setState(() {
isDark = !isDark;
});
},
),
),
const SizedBox(height: 4),
...classes.map((item) {
return Column(
 children: [
Card(
elevation: 10,
child: Padding(
padding: const EdgeInsets.all(10),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text( item["time"]!,
style: TextStyle( fontSize: 10,),
),
SizedBox( height: 12),
Text( item["subject"]!,
style: TextStyle( fontSize: 10,),
),
SizedBox( height: 12),
Text( item["room"]!,
style: TextStyle( fontSize: 10,),
),
SizedBox( height: 12),
],
),
),
),
 const SizedBox(height: 10),
]
 );
 }
 ).toList(),
],
 ),
 
 )
 
 ),
 );
 } }