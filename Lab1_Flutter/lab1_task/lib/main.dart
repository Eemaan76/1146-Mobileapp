// import 'package:flutter/material.dart';

// void main() {
//   runApp(const flutter());
// }

// class flutter extends StatelessWidget {
//   const flutter({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text ("flutetr 1 lab"),
//           backgroundColor: Colors.purple,
//         ),
//         body: const Center(
//           child: Text("my fisrt flutter app"),
//         ),
//       )
//     );
//   }
// }

//      import 'package:flutter/material.dart';

// void main() {
//   runApp(const flutter());
// }

// class flutter extends StatelessWidget {
//   const flutter({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: Text ("flutetr 1 lab"),
//           backgroundColor: Colors.amber,
//         ),
//         body: const Center(
//           child: Text("my fisrt flutter app"),
//         ),
//       )
//     );
//   }
// }
       
//      import 'package:flutter/material.dart';

// void main() {
//   runApp(const Flutter());
// }

// class Flutter extends StatelessWidget {
//   const Flutter({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: Text ("flutetr 1 lab"),
//           backgroundColor: Colors.purple,
//         ),
//         body: const Center(
//           child: Text("Eman Fatima"),
//         ),
//       )
//     );
//   }
// }
//  import 'package:flutter/material.dart';

// void main() {
//   runApp(const Flutter());
// }

// class Flutter extends StatelessWidget {
//   const Flutter({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: Text ("flutetr 1 lab"),
//           backgroundColor: Colors.purple,
//         ),
//                 body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: const [
//                 Icon(Icons.star),
//                 SizedBox(width: 10),
//                 Text("Eman Fatima"),
//               ],
//             ),
//             const SizedBox(height: 20),
//             const Text("Flutter Lab 1"),
//           ],
//         ),
//       ),
//     );
//   }
// }   
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: const Text("Flutter 1 Lab"),
//           backgroundColor: Colors.purple,
//         ),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: const [
//                 Icon(Icons.star),
//                 SizedBox(width: 10),
//                 Text("Eman Fatima"),
//               ],
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               "Flutter Lab 1",
//               style: TextStyle(fontSize: 18),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Image.asset('assets/pink.webp'),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Image.network('assets/pink.webp'),
//         ),
//       ),
//     );
//   }
// }import 'package:flutter/material.dart';import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Image.asset(
            'assets/pink.webp',
            width: 300,
          ),
        ),
      ),
    );
  }
}