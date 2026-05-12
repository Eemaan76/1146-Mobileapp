
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        isDark: isDark,
        onChanged: (value) {
          setState(() {
            isDark = value;
          });
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final bool isDark;
  final Function(bool) onChanged;

  HomeScreen({required this.isDark, required this.onChanged});

  final List<Map<String, dynamic>> products = [
    {"name": "Shoes", "price": "\$50"},
    {"name": "Watch", "price": "\$70"},
    {"name": "Bag", "price": "\$40"},
    {"name": "Phone", "price": "\$300"},
    {"name": "Laptop", "price": "\$600"},
    {"name": "Headphones", "price": "\$45"},
    {"name": "Camera", "price": "\$250"},
    {"name": "T-Shirt", "price": "\$20"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            Icon(Icons.menu),
            Icon(Icons.search),
          ],
        ),
        title: Text('Product App'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              'https://via.placeholder.com/150',
            ),
          ),
          SizedBox(height: 10),
          Column(
            children: [
              Text(
                'Ali Khan',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('alikhan@gmail.com'),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            'https://via.placeholder.com/150',
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(products[index]['name']),
                            Text(products[index]['price']),
                          ],
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            print(products[index]['name']);
                          },
                          child: Text('Add to Wishlist'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Dark Mode'),
                Switch(
                  value: isDark,
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


