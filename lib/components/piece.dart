enum ChessPieceType {pawn,rook,knight,bishop,queen,king}
class ChessPiece{
  final ChessPieceType type;
  final bool isWhite;
  final white_imagePath;
  final black_imagePath;
  ChessPiece({
    required this.type ,
    required this.isWhite, 
    required this.white_imagePath,
    required this.black_imagePath,
    });
}