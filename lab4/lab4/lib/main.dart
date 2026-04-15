// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: SafeScaffold());
//   }
// }

// class SafeScaffold extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 67, 251, 64),
//         centerTitle: true,
//         title: Text(
//           "Eemaan fatima",
//           style: TextStyle(color: Colors.deepPurple),
//         ),
//       ),
//       body: SafeArea(
//         child: Container(
//           color: Colors.lightBlue[50],
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: 20), // spacing from top

//               Container(
//                 margin: EdgeInsets.all(20.0),
//                 child: CircleAvatar(
//                   radius: 55,
//                   backgroundImage: NetworkImage(
//                     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfekvepoZPv2-Qz1Zl5osfxLFILaA77fD8Ug&s',
//                   ),
//                 ),
//               ),

//               SizedBox(height: 10), // spacing after image

//               Center(
//                 child: Text(
//                   "Hello from 1146",
//                   style: TextStyle(
//                     fontSize: 22,
//                     color: const Color.fromARGB(255, 54, 130, 244),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),

//               SizedBox(height: 10), // spacing

//               Text(
//                 "Softwrae enginner",
//                 style: TextStyle(fontSize: 18, color: Colors.green),
//               ),

//               SizedBox(height: 20), // spacing before row

//               Row(
//                 children: [
//                   Expanded(
//                     flex: 2,
//                     child: Container(
//                       height: 100,
//                       color: Colors.redAccent,
//                       child: Center(
//                         child: Text(
//                           " To enhance my skills in mobile app development using Flutter, creating responsive and visually appealing user interfaces, and building efficient applications that provide a smooth user experience. I aim to apply my knowledge practically and continuously learn new technologies to grow as a competent software developer.",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ),

//                   SizedBox(width: 30), // spacing between containers

//                   Expanded(
//                     flex: 1,
//                     child: Container(
//                       height: 100,
//                       color: Colors.blueAccent,
//                       child: Center(
//                         child: Text(
//                           "I am currently pursuing my studies in Computer Science at [Your College/University Name], where I have gained foundational knowledge in programming, data structures, and software development. During my coursework, I have also explored mobile app development through hands-on projects and practical assignments.",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               SizedBox(height: 20), // bottom spacing
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SafeScaffold());
  }
}
class SafeScaffold extends StatefulWidget {
  @override
  _SafeScaffoldState createState() => _SafeScaffoldState();
}
class _SafeScaffoldState extends State<SafeScaffold> {
  bool isFollowed = false;
  int score = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 67, 251, 64),
        centerTitle: true,
        title: Text(
          "Eemaan fatima",
          style: TextStyle(color: Colors.deepPurple),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.lightBlue[50],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.all(20.0),
                child: CircleAvatar(
                  radius: 55,
                  backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfekvepoZPv2-Qz1Zl5osfxLFILaA77fD8Ug&s',
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  "Hello from 1146",
                  style: TextStyle(
                    fontSize: 22,
                    color: const Color.fromARGB(255, 54, 130, 244),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Softwrae enginner",
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
              SizedBox(height: 20),
              /// Follow Button
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isFollowed = !isFollowed;
                  });
                },
                child: Text(isFollowed ? "Unfollow" : "Follow"),
              ),
              SizedBox(height: 20),
              /// Card for Score (Task 8)
              Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: ListTile(
                  leading: Icon(Icons.favorite, color: Colors.red),
                  title: Text("Likes"),
                  subtitle: Text("Total Likes: $score"),
                  trailing: IconButton(
                    icon: Icon(Icons.thumb_up),
                    onPressed: () {
                      setState(() {
                        score++;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}