import 'package:flutter/material.dart';
import 'package:chess_game/components/piece.dart';
import 'package:chess_game/components/square.dart';
import 'package:chess_game/database_service.dart';

class Gameboard extends StatefulWidget {
  final Map<String, dynamic> game;

  const Gameboard({Key? key, required this.game}) : super(key: key);

  @override
  State<Gameboard> createState() => _GameboardState();
}

class _GameboardState extends State<Gameboard> {
  List<Map<String, List<int>>> gameMoves = [];
  late List<List<ChessPiece?>> board;
  final databaseService = DatabaseService();
  int currentMoveIndex = -1;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
    _retrieveSpecificGame();
  }

  /// Initialize the board with pieces in their starting positions
  void _initializeBoard() {
    List<List<ChessPiece?>> newBoard =
        List.generate(8, (_) => List.generate(8, (_) => null));

    // Add pawns
   for(int i=0;i<8;i++){
      newBoard[1][i] = ChessPiece(
      type: ChessPieceType.pawn, 
      isWhite: false,
       white_imagePath:'images/white_pawn.png',
        black_imagePath:'images/black_pawn.png'
        ) ;
      newBoard[6][i] = ChessPiece(
      type: ChessPieceType.pawn, 
      isWhite: true,
       white_imagePath:'images/white_pawn.png',
        black_imagePath:'images/black_pawn.png'
        ) ;


    }

    //place rooks
      newBoard[0][0]=ChessPiece(
        type: ChessPieceType.rook,
         isWhite: false, 
         white_imagePath: 'images/white_rook.png', 
         black_imagePath:'images/black_rook.png'
         );

      newBoard[0][7]=ChessPiece(
        type: ChessPieceType.rook,
         isWhite: false, 
         white_imagePath: 'images/white_rook.png', 
         black_imagePath:'images/black_rook.png'
         );

      newBoard[7][0]=ChessPiece(
        type: ChessPieceType.rook,
         isWhite: true, 
         white_imagePath: 'images/white_rook.png', 
         black_imagePath:'images/black_rook.png'
         );

      newBoard[7][7]=ChessPiece(
        type: ChessPieceType.rook,
         isWhite: true, 
         white_imagePath: 'images/white_rook.png', 
         black_imagePath:'images/black_rook.png'
         );
    //place knight
      newBoard[0][1]=ChessPiece(
        type: ChessPieceType.knight,
         isWhite: false, 
         white_imagePath: 'images/white_knight.png', 
         black_imagePath:'images/black_knight.png'
         );

      newBoard[0][6]=ChessPiece(
        type: ChessPieceType.knight,
         isWhite: false, 
         white_imagePath: 'images/white_knight.png', 
         black_imagePath:'images/black_knight.png'
         );

      newBoard[7][1]=ChessPiece(
        type: ChessPieceType.knight,
         isWhite: true, 
         white_imagePath: 'images/white_knight.png', 
         black_imagePath:'images/black_knight.png'
         );

      newBoard[7][6]=ChessPiece(
        type: ChessPieceType.knight,
         isWhite: true, 
         white_imagePath: 'images/white_knight.png', 
         black_imagePath: 'images/black_knight.png'
         );

    //place bishops

      newBoard[0][2]=ChessPiece(
        type: ChessPieceType.bishop,
         isWhite: false, 
         white_imagePath: 'images/white_bishop.png', 
         black_imagePath: 'images/black_bishop.png'
         );

      newBoard[0][5]=ChessPiece(
        type: ChessPieceType.bishop,
         isWhite: false, 
          white_imagePath: 'images/white_bishop.png', 
         black_imagePath: 'images/black_bishop.png'
         );
      newBoard[7][2]=ChessPiece(
        type: ChessPieceType.bishop,
         isWhite: true, 
         white_imagePath: 'images/white_bishop.png', 
         black_imagePath: 'images/black_bishop.png'
         );

      newBoard[7][5]=ChessPiece(
        type: ChessPieceType.bishop,
         isWhite: true, 
          white_imagePath: 'images/white_bishop.png', 
         black_imagePath: 'images/black_bishop.png'
         );

    //place queen
      newBoard[0][3]=ChessPiece(
        type: ChessPieceType.queen,
         isWhite: false, 
         white_imagePath: 'images/white_queen.png', 
         black_imagePath: 'images/black_queen.png'
         );

      newBoard[7][3]=ChessPiece(
        type: ChessPieceType.queen,
         isWhite: true, 
          white_imagePath: 'images/white_queen.png', 
         black_imagePath: 'images/black_queen.png'
         );

    //place king
      newBoard[0][4]=ChessPiece(
        type: ChessPieceType.king,
         isWhite: false, 
         white_imagePath: 'images/white_king.png', 
         black_imagePath: 'images/black_king.png'
         );

      newBoard[7][4]=ChessPiece(
        type: ChessPieceType.king,
         isWhite: true, 
          white_imagePath: 'images/white_king.png', 
         black_imagePath: 'images/black_king.png'
         );

    // Add other pieces: rooks, knights, bishops, queen, king
    // ... Place your existing piece initialization logic here ...

    board = newBoard;
  }

  /// Retrieve specific game moves from the database
  Future<void> _retrieveSpecificGame() async {
    try {
      final moves = await databaseService.retrieveGame(widget.game['name']);
      setState(() {
        gameMoves = moves;
        currentMoveIndex = -1; // Reset move index after loading
      });
      print('Retrieved moves: $gameMoves');
    } catch (e) {
      print('Error retrieving game moves: $e');
    }
  }

  /// Apply moves to the board up to the given index
  void _applyMoves(int moveIndex) {
    if (moveIndex < 0 || moveIndex >= gameMoves.length) return;

    _initializeBoard(); // Reset the board

    for (int i = 0; i <= moveIndex; i++) {
      final move = gameMoves[i];
      final from = move['from']!;
      final to = move['to']!;

      // Move the piece
      board[to[0]][to[1]] = board[from[0]][from[1]];
      board[from[0]][from[1]] = null;
    }
  }

  /// Go backward in moves
  void _goBackward() {
    if (currentMoveIndex > 0) {
      setState(() {
        currentMoveIndex--;
        _applyMoves(currentMoveIndex);
      });
    }
  }

  /// Go forward in moves
  void _goForward() {
    if (currentMoveIndex < gameMoves.length - 1) {
      setState(() {
        currentMoveIndex++;
        _applyMoves(currentMoveIndex);
      });
    }
  }

   
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(),
    backgroundColor: Color(0xFF2B2D42), // Dark background color
    body: Column(
      children: [
        // Back Button at the Top
        Padding(
          padding: const EdgeInsets.only(top: 2.0, left: 16.0),  // Reduced top padding
          child: Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(null, color: Colors.white),
              iconSize: 28.0,
              tooltip: 'Go Back',
              onPressed: () {
               
              },
            ),
          ),
        ),

        // Game Name in the Center (Reduced Padding)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),  // Reduced vertical padding
          child: Text(
            widget.game['name'],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Chessboard with Scrollable View
        Expanded(
          flex: 6,  // Use more space for the chessboard
          child: SingleChildScrollView(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,  // Ensures the board stays square
                child: GridView.builder(
                  shrinkWrap: true, // Makes sure the GridView does not take up more space than needed
                  physics: NeverScrollableScrollPhysics(), // Disables scrolling inside GridView
                  itemCount: 8 * 8,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                  ),
                  itemBuilder: (context, index) {
                    int row = index ~/ 8;
                    int col = index % 8;
                    final piece = board[row][col];

                    return Square(
                      isWhite: (row + col) % 2 == 0,
                      piece: piece,
                      isSelected: false,
                      isValidMove: false,
                      onTap: () {}, // Optional: Handle square taps if needed
                    );
                  },
                ),
              ),
            ),
          ),
        ),

        // Navigation Options at the Bottom
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),  // Reduced vertical padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Backward Button
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                iconSize: 32.0,
                tooltip: 'Backward',
                onPressed: _goBackward,
              ),
              // Forward Button
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                iconSize: 32.0,
                tooltip: 'Forward',
                onPressed: _goForward,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}