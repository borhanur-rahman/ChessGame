import 'package:flutter/material.dart';
import 'package:chess_game/database_service.dart';

class GameDetailPage extends StatelessWidget {
  final Map<String, dynamic> game;
   

  const GameDetailPage({Key? key, required this.game}) : super(key: key);
  

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game: ${game['name']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Game Name: ${game['name']}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Move History: ${game['moveHistory']}',
              style: const TextStyle(fontSize: 16),
            ),
            // Add more game details here as needed
          ],
        ),
      ),
    );
  }
}






