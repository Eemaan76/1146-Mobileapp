import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  void playSound(int number) {
    final player = AudioCache(prefix: 'assets/');
    player.play('note$number.wav');
  }
  Widget keyButton(Color color, int number) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: TextButton(
          onPressed: () => playSound(number),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: Text(
                "Xylophone",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              keyButton(Colors.red, 1),
              keyButton(Colors.yellow, 2),
              keyButton(Colors.green, 3),
              keyButton(Colors.lightGreen, 4),
              keyButton(Colors.brown, 5),
              keyButton(Colors.blue, 6),
              keyButton(Colors.purple, 7),
            ],
          ),
        ),
      ),
    );
  }
}