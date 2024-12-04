import 'dart:convert';  // For json encoding/decoding
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  // Initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chess_games.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(''' 
          CREATE TABLE games (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            moves TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // Save a game
  Future<void> saveGame(String name, List<Map<String, List<int>>> moves) async {
    final db = await database;
    final movesJson = json.encode(moves);  // Using json encoding for moves
    await db.insert('games', {'name': name, 'moves': movesJson});
  }

  // Retrieve all games
  Future<List<Map<String, dynamic>>> retrieveGames() async {
    final db = await database;
    return await db.query('games');
  }
// Retrieve a specific game
Future<List<Map<String, List<int>>>> retrieveGame(String name) async {
  final db = await database;
  final result = await db.query('games', where: 'name = ?', whereArgs: [name]);
  if (result.isNotEmpty) {
    final movesString = result.first['moves'] as String;

    // Decode the moves and explicitly map to the correct type
    final List<dynamic> decodedMoves = json.decode(movesString);

    return decodedMoves.map<Map<String, List<int>>>((move) {
      return {
        'from': List<int>.from(move['from']), // Explicit conversion to List<int>
        'to': List<int>.from(move['to']),   // Explicit conversion to List<int>
      };
    }).toList();
  }
  return [];
}


  // Delete a game
  Future<void> deleteGame(String name) async {
    final db = await database;
    await db.delete('games', where: 'name = ?', whereArgs: [name]);
  }

  // Close the database
  Future<void> closeDB() async {
    final db = await database;
    await db.close();
  }
}
