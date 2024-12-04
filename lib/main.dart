import 'package:chess_game/gameboard.dart';
import 'package:flutter/material.dart';
import 'package:chess_game/game_history.dart';

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
          // Background Image with gradient overlay
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/background.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6), BlendMode.darken),
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
                    color: const Color.fromARGB(255, 255, 236, 236),
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.5,
                    shadows: [
                      Shadow(
                        blurRadius: 8.0,
                        color: Colors.black.withOpacity(0.7),
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2), // Spacing between the main title and subtitle
                Text(
                  "Multiplayer Chess Game",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 188, 228, 254),
                    fontSize: 18,
                    fontFamily: "Georgia", // Smaller font size
                    fontWeight: FontWeight.normal,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black.withOpacity(0.6),
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),// Space between title and buttons

                // New Game Button
                _buildMenuButton(
                  context,
                  "New Game",
                  const Color.fromARGB(255, 19, 84, 21).withOpacity(0.8),
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Gameboard()));
                  },
                ),

                SizedBox(height: 15), // Spacing between buttons

               
                // History Button
                _buildMenuButton(
                  context,
                  "History",
                  const Color.fromARGB(255, 143, 95, 25).withOpacity(0.8),
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GameListPage()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to create buttons with consistent styling
  Widget _buildMenuButton(
      BuildContext context, String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(250, 50), // Ensures uniform button size
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13.0), // Adjusted corner radius
        ),
        elevation: 10.0,
        shadowColor: Colors.black.withOpacity(0.5),
        side: BorderSide(color: Colors.white.withOpacity(0.7), width: 1.5),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18, // Slightly reduced font size
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Colors.white,
          shadows: [
            Shadow(
              blurRadius: 5.0,
              color: Colors.black.withOpacity(0.4),
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
    );
  }
}
