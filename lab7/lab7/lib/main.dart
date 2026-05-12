import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureSliderApp(),
    );
  }
}

class GestureSliderApp extends StatefulWidget {
  const GestureSliderApp({super.key});

  @override
  State<GestureSliderApp> createState() => _GestureSliderAppState();
}

class _GestureSliderAppState extends State<GestureSliderApp> {

  // ---------------- Phase 1 ----------------
  Color boxColor = Colors.blue;
  double borderRadius = 0;

  final Color initialColor = Colors.blue;
  final double initialRadius = 0;

  // ---------------- Phase 2 ----------------
  double sliderValue = 50;

  // ---------------- Phase 3 ----------------
  double red = 100;
  double green = 100;
  double blue = 100;
  double boxSize = 150;

  // Generate random color
  Color getRandomColor() {
    return Color.fromARGB(
      255,
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextInt(256),
    );
  }

  // Convert RGB to HEX
  String getHexColor() {
    return '#'
        '${red.toInt().toRadixString(16).padLeft(2, '0')}'
        '${green.toInt().toRadixString(16).padLeft(2, '0')}'
        '${blue.toInt().toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {

    Color mixedColor = Color.fromRGBO(
      red.toInt(),
      green.toInt(),
      blue.toInt(),
      1,
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Gesture + Slider App")),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // ================= Phase 1 =================
            const SizedBox(height: 20),

            GestureDetector(
              onTap: () {
                setState(() {
                  boxColor = getRandomColor();
                });
              },

              onDoubleTap: () {
                setState(() {
                  borderRadius = borderRadius == 0 ? 100 : 0;
                });
              },

              onLongPress: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Resetting...")),
                );

                setState(() {
                  boxColor = initialColor;
                  borderRadius = initialRadius;
                });
              },

              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ================= Phase 2 =================
            Text("Value: ${sliderValue.toInt()}",
                style: const TextStyle(fontSize: 18)),

            Slider(
              min: 0,
              max: 100,
              divisions: 10,
              value: sliderValue,
              label: sliderValue.toString(),
              onChanged: (value) {
                setState(() {
                  sliderValue = value;
                });
              },
            ),

            CupertinoSlider(
              min: 0,
              max: 100,
              value: sliderValue,
              onChanged: (value) {
                setState(() {
                  sliderValue = value;
                });
              },
            ),

            const SizedBox(height: 40),

            // ================= Phase 3 =================
            const Text("Mood & Color Mixer",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            const SizedBox(height: 20),

            // RGB Sliders
            buildSlider("Red", red, (val) {
              setState(() => red = val);
            }),

            buildSlider("Green", green, (val) {
              setState(() => green = val);
            }),

            buildSlider("Blue", blue, (val) {
              setState(() => blue = val);
            }),

            const SizedBox(height: 20),

            // Preview Box with GestureDetector
            GestureDetector(
              onLongPress: () {
                print("HEX: ${getHexColor()}");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Copied: ${getHexColor()}")),
                );
              },

              onHorizontalDragUpdate: (details) {
                setState(() {
                  boxSize += details.delta.dx;
                  boxSize = boxSize.clamp(50, 300);
                });
              },

              child: Container(
                width: boxSize,
                height: boxSize,
                color: mixedColor,
                alignment: Alignment.center,
                child: Text(
                  getHexColor(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Reusable slider widget
  Widget buildSlider(String label, double value, Function(double) onChanged) {
    return Column(
      children: [
        Text("$label: ${value.toInt()}"),
        Slider(
          min: 0,
          max: 255,
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}