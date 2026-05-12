// main.dart

import 'package:flutter/material.dart';
import 'first_route.dart';
import 'todos_screen.dart';

void main() {
  runApp(const Application10());
}

class Application10 extends StatelessWidget {
  const Application10({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainMenu(),
    );
  }
}

// ================= MAIN MENU =================

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),

      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF6C63FF),

        title: const Text(
          "Lab - 10: Menu",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(18),

        children: [

          // ---------------- FIRST ROUTE CARD ----------------

          Container(
            margin: const EdgeInsets.only(bottom: 18),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),

              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),

                leading: Container(
                  padding: const EdgeInsets.all(10),

                  decoration: BoxDecoration(
                    color: const Color(0xFFEAE7FF),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: const Icon(
                    Icons.explore,
                    color: Color(0xFF6C63FF),
                  ),
                ),

                title: const Text(
                  "First Route",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),

                subtitle: const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    "Navigation + Hero Animation",
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.black54,
                    ),
                  ),
                ),

                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Color(0xFFFF6584),
                ),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FirstRoute(),
                    ),
                  );
                },
              ),
            ),
          ),

          // ---------------- TODOS SCREEN CARD ----------------

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.10),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),

              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),

                leading: Container(
                  padding: const EdgeInsets.all(10),

                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE6EC),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: const Icon(
                    Icons.list_alt,
                    color: Color(0xFFFF6584),
                  ),
                ),

                title: const Text(
                  "Todos Screen",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),

                subtitle: const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    "Passing Data Between Screens",
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.black54,
                    ),
                  ),
                ),

                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Color(0xFF6C63FF),
                ),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TodosScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}