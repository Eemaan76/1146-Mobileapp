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
        backgroundColor: Colors.blueGrey,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [

                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    margin: const EdgeInsets.all(25),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    color: Colors.orange,
                    child: const Center(
                      child: Text('My NAME IS EMAN'),
                    ),
                  ),
                ),

                Divider(
                  thickness: 2,
                  color: Colors.black,
                ),

                Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                    Icon(Icons.favorite, size: 40, color: Colors.blue),
                      SizedBox(height: 60),
                      Icon(Icons.thumb_up, size: 40, color: Colors.deepOrangeAccent),
                      SizedBox(height: 60),
                      Icon(Icons.share, size: 40 ,color: Colors.deepPurple),
                    ],
                  ),
                ),

                Divider(
                  thickness: 2,
                  color: Colors.black,
                ),
                Container(
                  height:100,
                  color:Colors.grey,
                  child:Row(
                    mainAxisAlignment:MainAxisAlignment.center,
                      crossAxisAlignment:CrossAxisAlignment.stretch,
                      children:const[
                        Icon(Icons.volume_up,size:40 ,color: Colors.amber),
                          Icon(Icons.bluetooth,size:40 ,color: Color.fromARGB(255, 7, 255, 85) ),
                              Icon(Icons.wifi,size:40,color: Color.fromARGB(255, 230, 7, 255)),
                        ],
                        ),
                      ),
                      Divider(
                  thickness: 2,
                  color: Colors.black,
                ),
                  Container(
              height: 100,
              width: double.infinity,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: 80,
                  color: Colors.red,
                ),
                Container(
                  height: 50,
                  width: 80,
                  color: Colors.green,
                ),
              ],
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}