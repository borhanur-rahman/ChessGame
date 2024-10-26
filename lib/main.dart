import 'package:chess_game/gameboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chess Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:AssetImage("images/background.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.darken),
              ),
            ),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Chess Game Title
                Text(
                  "Chess Master",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50), // Space between title and buttons

                // New Game Button
                _buildMenuButton(context, "New Game", const Color.fromARGB(255, 15, 126, 72), () {
                  Navigator.push(
                    context,
                     MaterialPageRoute(builder: (context)=>const Gameboard()));
                }),

                SizedBox(height: 20), // Spacing between buttons

                // Continue Button
                _buildMenuButton(context, "Continue", const Color.fromARGB(255, 57, 112, 208), () {
                  // Add your functionality for Continue
                }),

                SizedBox(height: 20), // Spacing between buttons

                // History Button
                _buildMenuButton(context, "History", const Color.fromARGB(255, 164, 110, 40),() {
                  // Add your functionality for History
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to create a button with styling
  Widget _buildMenuButton(BuildContext context, String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        shadowColor: Colors.black,
        elevation: 10.0,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: Colors.white,
        ),
      ),
    );
  }
}
