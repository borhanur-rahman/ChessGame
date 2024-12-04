import 'package:flutter/material.dart';
import 'package:chess_game/database_service.dart';
import 'package:chess_game/gameDetailPage.dart';

class GameListPage extends StatefulWidget {
  @override
  _GameListPageState createState() => _GameListPageState();
}

class _GameListPageState extends State<GameListPage> {
  final DatabaseService _databaseService = DatabaseService();
  List<Map<String, dynamic>> _games = [];

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  /// Load games from the database and update the state
  Future<void> _loadGames() async {
    final games = await _databaseService.retrieveGames();
    setState(() {
      _games = games;
    });
  }

  /// Delete a game and refresh the list
  Future<void> _deleteGame(String name) async {
    await _databaseService.deleteGame(name);
    await _loadGames(); // Refresh the list after deletion
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF2B2D42), // Light-dark background
    body: Stack(
      children: [
        Column(
          children: [
            // Title bar with a greenish gradient and back arrow in the center
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24.0), // Increased height for title bar
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color.fromARGB(255, 26, 119, 31), Color.fromARGB(255, 67, 159, 72)], // Green gradient
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 57, 57, 57).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Saved Games',
                      style: TextStyle(
                        fontSize: 26, // Slightly larger font
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 217, 216, 216),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16.0,
                  top: 0.0,
                  bottom: 0.0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),

            // Game List or empty message
            Expanded(
              child: _games.isEmpty
                  ? const Center(
                      child: Text(
                        'No games found.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      itemCount: _games.length,
                      itemBuilder: (context, index) {
                        final game = _games[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 16.0), // Reduced margin for compact look
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: const Color.fromARGB(255, 98, 163, 210), // Light grey background
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 16.0), // Smaller padding for compact height
                            leading: Container(
                              padding: const EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 242, 246, 242).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.videogame_asset_rounded,
                                color: Color.fromARGB(255, 10, 31, 51),
                                size: 20, // Slightly smaller icon
                              ),
                            ),
                            title: Text(
                              game['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: const Text(
                              'Tap to view details',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                color: const Color.fromARGB(255, 135, 30, 30)
                                    .withOpacity(0.8),
                                size: 22,
                              ),
                              tooltip: 'Delete Game',
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: const Color(0xFF3E4A59), // Dark background for the dialog
                                    title: const Text(
                                      'Delete Game',
                                      style: TextStyle(
                                        color: Colors.white, // White text for the title
                                      ),
                                    ),
                                    content: Text(
                                      'Are you sure you want to delete "${game['name']}"?',
                                      style: const TextStyle(
                                        color: Colors.white, // White text for the content
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.white), // White text for Cancel button
                                        ),
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(255, 188, 73, 73), // Red background
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        ),
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.white), // White text for Delete button
                                        ),
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  await _deleteGame(game['name']);
                                }
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Gameboard(game: game),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ],
    ),
  );
}
}