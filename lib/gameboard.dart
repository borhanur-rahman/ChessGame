
import 'package:chess_game/components/piece.dart';
import 'package:chess_game/components/square.dart';
import 'package:chess_game/helper/helper_methods.dart';
import 'package:flutter/material.dart';


class Gameboard extends StatefulWidget {
  const Gameboard({super.key});

  @override
  State<Gameboard> createState() => _GameboardState();
}

class _GameboardState extends State<Gameboard> {

  //A 2D list representation the chess board
  //with each position possibly containing a chess piece
  late List<List<ChessPiece?>> board;

  //current selected piece on the board
  //if no piece is selected, this is null
  ChessPiece? selectedPiece;

  //The row index of the selected piece,nothing selected
  int selectedRow =-1;

  //The coloum index of the selected piece,nothing selected
  int selectedCol =-1;
  //A list of valid moves from the currently selected piece
  //each move is represent as a list with 2 element:row and col
  List<List<int>> validMoves =[];

  //to indicate whose turn it is
  bool isWhiteTurn =true;

  //initial position of the kings
  List<int> whiteKingPosition = [7,4];
  List<int> blackKingPosition = [0,4];

  bool checkStatus =false;
  // for checking king move 

  bool whiteKingIsMoved = false;
  bool blackKingIsMoved = false;
  // for checking rook move;
  bool whiteRightRook = false;
  bool whiteLeftRook = false;
  bool blackRightRook = false;
  bool blackLeftRook = false;
  

 



  @override
  void initState(){
    super.initState();
    _initializeBoard();
  }

  //INITIALiZE BOARD
  void _initializeBoard(){
    //initialize the board with nulls,meaning no piece
    List<List<ChessPiece?>> newBoard = 
         List.generate(8, (index)=>List.generate(8,(index)=>null));


    //place pawn
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

    board =newBoard;
  }
    //User selected a piece
  void pieceSelected(int row, int col){
   setState(() {
     if(selectedPiece == null && board[row][col] != null){
      if(board[row][col]!.isWhite == isWhiteTurn)
      {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }
     }
     //if there is a piece selected and user want to chose another
     else if(board[row][col] != null && selectedPiece!.isWhite == board[row][col]!.isWhite ){
          selectedPiece = board[row][col];
          selectedRow = row;
          selectedCol = col;
     }
    
     //if there is a piece selected and user taps on a square that is valid move there
     else if(selectedPiece != null && 
     validMoves.any((element)=> element[0] == row && element[1] == col)){
        movePiece(row, col);
     }
     //if a piece is selected , calculates its valid moves
     validMoves = calculateRealValidMoves(selectedRow,selectedCol,selectedPiece,true);
   }); 
  }

  //calculate raw valid moves
  List<List<int>>calculateRawValidMoves_(int row,int col,ChessPiece? piece){
     List<List<int>> candidateMoves =[];

     if(piece == null ){
      return [];
     }

     //different direction based on their color
     int direction = piece.isWhite? -1:1;

     switch (piece.type){
      case ChessPieceType.pawn:
      //move forword
        if(isInBoard(row + direction, col)&& board[row+direction][col]==null){
          candidateMoves.add([row +direction,col]);
        }
      //two moves if in initial position
      if((row == 1 && !piece.isWhite)||(row==6 && piece.isWhite)){
        if(isInBoard(row+ 2 * direction, col)&& board[row + 2 * direction][col]==null&&board[row + direction][col]==null){
          candidateMoves.add([row + 2 * direction, col]);
        }
      }

      //kill diagonaly

      if(isInBoard(row + direction, col-1)&& 
      board[row +direction][col-1]!=null &&
      board[row +direction][col-1]!.isWhite != piece.isWhite){
        candidateMoves.add([row +direction , col-1]);

      }
 
      if(isInBoard(row + direction, col+1)&& 
      board[row +direction][col+1]!=null &&
      board[row +direction][col+1]!.isWhite != piece.isWhite){
        candidateMoves.add([row +direction , col+1]);

      }


        break;
      case ChessPieceType.rook:

      //horizontal and vertical directions
      var directions = [
          [-1,0],
          [1,0],
          [0,-1],
          [0,1],

      ];
      for(var direction in directions){
        var i=1;
        while(true){
          var newRow = row + i * direction[0];
          var newCol = col + i * direction[1];
          if(!isInBoard(newRow, newCol)){
            break;
          }
          if(board[newRow][newCol]!=null){
            if(board[newRow][newCol]!.isWhite != piece.isWhite){
              candidateMoves.add([newRow,newCol]);//kill
            }
            break;
          }
          candidateMoves.add([newRow,newCol]);
          i++;
        }
      }
        break;
      case ChessPieceType.knight:

      //all eight possible L shapes the night can move
      var knightMoves = [
        [-2,-1],
        [-2,1],
        [-1,-2],
        [-1,2],
        [1,-2],
        [1,2],
        [2,-1],
        [2,1]
      ];

      for(var move in knightMoves){
        var newRow = row + move[0];
        var newCol = col + move[1];
        if(!isInBoard(newRow, newCol)){
          continue;
        }
        if(board[newRow][newCol] != null){
          if(board[newRow][newCol]!.isWhite != piece.isWhite){
            candidateMoves.add([newRow,newCol]);
          }
          continue;
        }
        candidateMoves.add([newRow,newCol]);
      }
        break;
      case ChessPieceType.bishop:

      //diagonal direction
      var directions = [
        [-1,-1],
        [-1,1],
        [1,-1],
        [1,1],
      ];
        for(var direction in directions){
          var i=1;
          while(true){
            var newRow = row + i* direction[0];
            var newCol = col + i* direction[1];
            if(!isInBoard(newRow, newCol)){
              break;
            }
            if(board[newRow][newCol]!=null){
              if(board[newRow][newCol]!.isWhite != piece.isWhite){
                candidateMoves.add([newRow,newCol]);
              }
              break;
            }
            candidateMoves.add([newRow ,newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.queen:
      // queen moves eight directions
       var directions =[
        [-1,0],
        [1,0],
        [0,-1],
        [0,1],
        [-1,-1],
        [-1,1],
        [1,-1],
        [1,1]
       ];
       for(var direction in directions){
        var i=1;
        while(true){
         var newRow = row + i* direction[0];
         var newCol = col + i* direction[1]; 
         if(!isInBoard(newRow, newCol)){
          break;
         }
         if(board[newRow][newCol]!=null){
          if(board[newRow][newCol]!.isWhite != piece.isWhite){
            candidateMoves.add([newRow,newCol]);
          }
          break;
         }
          candidateMoves.add([newRow,newCol]);
          i++;
        }
       }
        break;
      case ChessPieceType.king:
      
      // king moves eight directions
       var directions =[
        [-1,0],
        [1,0],
        [0,-1],
        [0,1],
        [-1,-1],
        [-1,1],
        [1,-1],
        [1,1]
       ];
        
       for(var direction in directions){
        var newRow = row + direction[0];
        var newCol = col + direction[1];
        if(!isInBoard(newRow,newCol)){
          continue;
        }
        if(board[newRow][newCol]!=null){
          if(board[newRow][newCol]!.isWhite != piece.isWhite){
            candidateMoves.add([newRow,newCol]);
          }
          continue;
        }
         candidateMoves.add([newRow,newCol]);

       }
      
       //add castle move 
      
       
     
        break;
      default:
     }
     return candidateMoves;
  }
 // for enhance real move calculatin
  List<List<int>>calculateRawValidMoves(int row,int col,ChessPiece? piece){
     List<List<int>> candidateMoves =[];

     if(piece == null ){
      return [];
     }

     //different direction based on their color
     int direction = piece.isWhite? -1:1;

     switch (piece.type){
      case ChessPieceType.pawn:
      //move forword
        if(isInBoard(row + direction, col)&& board[row+direction][col]==null){
          candidateMoves.add([row +direction,col]);
        }
      //two moves if in initial position
      if((row == 1 && !piece.isWhite)||(row==6 && piece.isWhite)){
        if(isInBoard(row+ 2 * direction, col)&& board[row + 2 * direction][col]==null&&board[row + direction][col]==null){
          candidateMoves.add([row + 2 * direction, col]);
        }
      }

      //kill diagonaly

      if(isInBoard(row + direction, col-1)&& 
      board[row +direction][col-1]!=null &&
      board[row +direction][col-1]!.isWhite != piece.isWhite){
        candidateMoves.add([row +direction , col-1]);

      }
 
      if(isInBoard(row + direction, col+1)&& 
      board[row +direction][col+1]!=null &&
      board[row +direction][col+1]!.isWhite != piece.isWhite){
        candidateMoves.add([row +direction , col+1]);

      }


        break;
      case ChessPieceType.rook:

      //horizontal and vertical directions
      var directions = [
          [-1,0],
          [1,0],
          [0,-1],
          [0,1],

      ];
      for(var direction in directions){
        var i=1;
        while(true){
          var newRow = row + i * direction[0];
          var newCol = col + i * direction[1];
          if(!isInBoard(newRow, newCol)){
            break;
          }
          if(board[newRow][newCol]!=null){
            if(board[newRow][newCol]!.isWhite != piece.isWhite){
              candidateMoves.add([newRow,newCol]);//kill
            }
            break;
          }
          candidateMoves.add([newRow,newCol]);
          i++;
        }
      }
        break;
      case ChessPieceType.knight:

      //all eight possible L shapes the night can move
      var knightMoves = [
        [-2,-1],
        [-2,1],
        [-1,-2],
        [-1,2],
        [1,-2],
        [1,2],
        [2,-1],
        [2,1]
      ];

      for(var move in knightMoves){
        var newRow = row + move[0];
        var newCol = col + move[1];
        if(!isInBoard(newRow, newCol)){
          continue;
        }
        if(board[newRow][newCol] != null){
          if(board[newRow][newCol]!.isWhite != piece.isWhite){
            candidateMoves.add([newRow,newCol]);
          }
          continue;
        }
        candidateMoves.add([newRow,newCol]);
      }
        break;
      case ChessPieceType.bishop:

      //diagonal direction
      var directions = [
        [-1,-1],
        [-1,1],
        [1,-1],
        [1,1],
      ];
        for(var direction in directions){
          var i=1;
          while(true){
            var newRow = row + i* direction[0];
            var newCol = col + i* direction[1];
            if(!isInBoard(newRow, newCol)){
              break;
            }
            if(board[newRow][newCol]!=null){
              if(board[newRow][newCol]!.isWhite != piece.isWhite){
                candidateMoves.add([newRow,newCol]);
              }
              break;
            }
            candidateMoves.add([newRow ,newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.queen:
      // queen moves eight directions
       var directions =[
        [-1,0],
        [1,0],
        [0,-1],
        [0,1],
        [-1,-1],
        [-1,1],
        [1,-1],
        [1,1]
       ];
       for(var direction in directions){
        var i=1;
        while(true){
         var newRow = row + i* direction[0];
         var newCol = col + i* direction[1]; 
         if(!isInBoard(newRow, newCol)){
          break;
         }
         if(board[newRow][newCol]!=null){
          if(board[newRow][newCol]!.isWhite != piece.isWhite){
            candidateMoves.add([newRow,newCol]);
          }
          break;
         }
          candidateMoves.add([newRow,newCol]);
          i++;
        }
       }
        break;
      case ChessPieceType.king:
      
      // king moves eight directions
       var directions =[
        [-1,0],
        [1,0],
        [0,-1],
        [0,1],
        [-1,-1],
        [-1,1],
        [1,-1],
        [1,1]
       ];
        
       for(var direction in directions){
        var newRow = row + direction[0];
        var newCol = col + direction[1];
        if(!isInBoard(newRow,newCol)){
          continue;
        }
        if(board[newRow][newCol]!=null){
          if(board[newRow][newCol]!.isWhite != piece.isWhite){
            candidateMoves.add([newRow,newCol]);
          }
          continue;
        }
         candidateMoves.add([newRow,newCol]);

       }
      
       //add castle move 
        if(!isKingInCheck_(piece.isWhite)){
          if(!whiteKingIsMoved && piece.isWhite){
            //for right castle
            if(!whiteRightRook && board[7][6]==null && board[7][5]==null){
              candidateMoves.add([7,6]);
            }
            if(!whiteLeftRook && board[7][1]==null && board[7][2]==null && board[7][3]==null){
              candidateMoves.add([7,2]);
            }
          }
          if(!piece.isWhite && !blackKingIsMoved){

            //for right castle
            if(!blackRightRook && board[0][6]==null && board[0][5]==null){
              candidateMoves.add([0,6]);
            }
            if(!blackLeftRook && board[0][1]==null && board[0][2]==null && board[0][3]==null){
              candidateMoves.add([0,2]);
            }

          }


        }
       
     
        break;
      default:
     }
     return candidateMoves;
  }
 
  //claculate real valid moves
  List<List<int>> calculateRealValidMoves(
    int row , int col, ChessPiece? piece , bool checkSimulation){
      List<List<int>>realValidMoves = [];
       List<List<int>>candidateMoves = calculateRawValidMoves(row, col, piece);
        //after generating all candidate moves, filter out any that would result in a check
        if(checkSimulation){
          for(var move in candidateMoves){
            int endRow = move[0];
            int endCol = move[1];

            //this will simulate the future move to see if it's safe
            if(simulatedMoveIsSafe(piece!,row ,col ,endRow ,endCol)){
              realValidMoves.add(move);
            }
          }
        }
        else {
          realValidMoves = candidateMoves;
        }
        return realValidMoves;
      }
  //move piece
  void movePiece(int newRow , int newCol){
    //check if the piece being moved in a king
    if(selectedPiece!.type == ChessPieceType.king){

       if(!selectedPiece!.isWhite){
      int besideKing =(blackKingPosition[1]-newCol);
      if(besideKing<0){
        board[0][5]=board[0][7];
        board[0][7]=null;
      }
      else{
        board[0][3]=board[0][0];
        board[0][0]=null;
      }
      

    }
     if(selectedPiece!.isWhite){
      int besideKing =(whiteKingPosition[1]-newCol);
      if(besideKing<0){
        board[7][5]=board[7][7];
        board[7][7]=null;
      }
      else{
        board[7][3]=board[7][0];
        board[7][0]=null;
      }
      

    }

      if(selectedPiece!.isWhite){
        whiteKingPosition = [newRow, newCol];
        whiteKingIsMoved =true;
      }
      else{
        blackKingPosition = [newRow ,newCol];
        blackKingIsMoved = true;
      }
      //white rook castle 
   
    }


    // to save the rook move

    if(selectedPiece!.type == ChessPieceType.rook){
      if(selectedPiece!.isWhite && !whiteKingIsMoved){
        if(selectedCol == 0 && !whiteLeftRook){
            whiteLeftRook = true;
        }
        if(selectedCol == 7 && !whiteRightRook){
          whiteRightRook = true;
        }
          
      }
      else{
         if(selectedCol == 0 && !blackLeftRook){
            blackLeftRook = true;
        }
        if(selectedCol == 7 && !blackRightRook){
          blackRightRook = true;
        }
      }
    }
    
    //move the piece and clear the old position
    board[newRow][newCol]= selectedPiece;
    board[selectedRow][selectedCol]=null;


    //promotion of pawn at 8'th rank
    if(selectedPiece!.type == ChessPieceType.pawn){
      if((selectedPiece!.isWhite && newRow ==0)||(!selectedPiece!.isWhite&& newRow==7)){
        showPromotionDialog(newRow,newCol,selectedPiece!.isWhite);
      }
    }

    //see if any kings are under attack

    if(isKingInCheck(!isWhiteTurn)){
      checkStatus = true;
    }
    else{
      checkStatus = false;
    }

    //clear selection 
    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });
    //check if it's check mate
    if(isCheckMate(!isWhiteTurn)){
      showDialog(context: context,
       builder: (context)=>AlertDialog(
        title: const Text("CHECK MATE"),
        actions: [
          //play again button
          TextButton(onPressed: resetGame, child: const Text('Play agian')),
        ],
       ));
    }

    //change turn
    isWhiteTurn = !isWhiteTurn;
  }
  //is king in check
  bool isKingInCheck(bool isWhiteKing){
    List<int> kingPosition = isWhiteKing? whiteKingPosition:blackKingPosition;

    //check if any enemy piece can attack the king
    for(int i=0;i<8;i++){
      for(int j=0;j<8;j++){
        if(board[i][j]==null || board[i][j]!.isWhite == isWhiteKing){
          continue;
        }
        List<List<int>> pieceValidMoves =
         calculateRealValidMoves(i, j, board[i][j],false);
         //check if the King's position is in this piece's valid moves
         if(pieceValidMoves.any((move)=>
              move[0]==kingPosition[0] && move[1]==kingPosition[1])){
                return true;
              }
      }
    
    }
    return false;
  }
// for enhance Raw move calculation
bool isKingInCheck_(bool isWhiteKing){
    List<int> kingPosition = isWhiteKing? whiteKingPosition:blackKingPosition;

    //check if any enemy piece can attack the king
    for(int i=0;i<8;i++){
      for(int j=0;j<8;j++){
        if(board[i][j]==null || board[i][j]!.isWhite == isWhiteKing){
          continue;
        }
        List<List<int>> pieceValidMoves =
         calculateRawValidMoves_(i, j, board[i][j]);
         //check if the King's position is in this piece's valid moves
         if(pieceValidMoves.any((move)=>
              move[0]==kingPosition[0] && move[1]==kingPosition[1])){
                return true;
              }
      }
    
    }
    return false;
  }
//sumulate a future move to see if it's safe(doesn't put your own king under attack)
  bool simulatedMoveIsSafe(
    ChessPiece piece, int startRow , int startCol , int endRow ,int endCol){
      //save the current board state
      ChessPiece? originalDestinationPiece = board[endRow][endCol];

      //if the piece is king , save it's current position and update to the new one
      List<int>? originalKingPosition;
      if(piece.type == ChessPieceType.king){
        originalKingPosition = piece.isWhite? whiteKingPosition : blackKingPosition;

        //update the king position
        if(piece.isWhite){
          whiteKingPosition = [endRow,endCol];

        } else{
          blackKingPosition = [endRow,endCol];
        }
      }
      //simulate the move
      board[endRow][endCol]=piece;
      board[startRow][startCol]=null;

      //check if our own king is under attack
      bool kingInCheck =isKingInCheck(piece.isWhite);

      //restore board and original state
      board[startRow][startCol] = piece;
      board[endRow][endCol] = originalDestinationPiece;

      //if the piece was the king, restore it original position
      if(piece.type == ChessPieceType.king){
        if(piece.isWhite){
          whiteKingPosition = originalKingPosition!;
        } else{
          blackKingPosition = originalKingPosition!;
        }
      }
      // if king is in check=true , mean it's not a safe move
      return !kingInCheck;
  }
  
  // is it check_mate?
  bool  isCheckMate(bool isWhiteKing){
    //if the king is not in check, then it's not checkmate
      if(!isKingInCheck(isWhiteKing)){
        return false;
      }
    //if there at least one legal move for any of the player's pieces, then it's not checkmate
      for(int i=0; i<8; i++){
        for(int j=0; j<8; j++){
          if(board[i][j] == null || board[i][j]!.isWhite !=isWhiteKing){
            continue;
          }
          List<List<int>> pieceValidMoves = 
                calculateRealValidMoves(i, j, board[i][j], true); 

                //if this has any valid moves , then it's not checkmate
                if(pieceValidMoves.isNotEmpty){
                  return false;
                }
        }
      }
    //if none of the above condition are met, then there are no legal moves left to make
    //it's check mate
    return true;
  }
//promote the pawn
void promotePawn(int row,int col,String selectedPiece,bool isWhite){
  switch(selectedPiece){
    case 'queen':
    //replace with queen
    board[row][col]=ChessPiece(
        type: ChessPieceType.queen,
         isWhite: isWhite, 
         white_imagePath: 'images/white_queen.png', 
         black_imagePath:'images/black_queen.png'
         );
    break;
    case 'rook':
    //replace with rook
    
    board[row][col]=ChessPiece(
        type: ChessPieceType.rook,
         isWhite: isWhite, 
         white_imagePath: 'images/white_rook.png', 
         black_imagePath:'images/black_rook.png'
         );
    break;
    case 'bishop':
   
     //replace with bishop
    board[row][col]=ChessPiece(
        type: ChessPieceType.bishop,
         isWhite: isWhite, 
         white_imagePath: 'images/white_bishop.png', 
         black_imagePath:'images/black_bishop.png'
         );
    break;
    case 'knight':
    //replace with knight
   
    board[row][col]=ChessPiece(
        type: ChessPieceType.knight,
         isWhite: isWhite, 
         white_imagePath: 'images/white_knight.png', 
         black_imagePath:'images/black_knight.png'
         );
    break;

  }
  //trigger a redraw of the board to reflect the change
  setState(() {
    
  });

}

  void resetGame(){
    Navigator.pop(context);
    _initializeBoard();
    checkStatus =false;
     whiteKingPosition = [7,4];
     blackKingPosition = [0,4];
    isWhiteTurn= true;
    setState(() {
      
    });
  }
 //dialog box for promotion pawn
 Future<void> showPromotionDialog(int row,int col, bool isWhite)async{
  //show dialog and await user's choise
  String? selectedPiece = await showDialog<String>(
    context: context,
     builder: (BuildContext context){
      return AlertDialog(
       
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:Image.asset(
                isWhite? "images/white_queen.png":"images/black_queen.png",
              ),
              onTap: (){
                Navigator.pop(context,'queen');
              },
            ),
             ListTile(
              leading: Image.asset(
                isWhite? "images/white_rook.png":"images/black_rook.png",
              ),
              onTap: (){
                Navigator.pop(context,'rook');
              },
            ),
             ListTile(
              leading: Image.asset(
                isWhite? "images/white_bishop.png":"images/black_bishop.png",
              ),
              onTap: (){
                Navigator.pop(context,'bishop');
              },
            ),
             ListTile(
              leading: Image.asset(
                isWhite? "images/white_knight.png":"images/black_knight.png",
              ),
              onTap: (){
                Navigator.pop(context,'knight');
              },
            ),
          ],
        ),
      );
     }
     );
     if(selectedPiece != null){
      promotePawn(row, col, selectedPiece, isWhite);

     }
 }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
     
      body: Column(
        children: [
          Expanded(child: Container()),
          Text(checkStatus? "check":""),
          //white pieces taken
          Expanded(
            flex: 6,
            child: GridView.builder(
              itemCount:8*8,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
               const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8), 
               itemBuilder: (context,index){
                int row = index~/8;
                int col = index % 8;
            
                //check if this square is selected
                bool isSelected = selectedRow == row && selectedCol == col;
            
                //check if this square is a valid move
                bool isValidMove =false;
                for(var position in validMoves){
                  if(position[0]== row && position[1]==col){
                    isValidMove = true;
                  }
                }
               
               return Square(
                isWhite: isWhite(index),
                piece:board[row][col] ,
                isSelected: isSelected,
                isValidMove: isValidMove,
                onTap:()=> pieceSelected(row,col),
                );
                
               }
               ),
          ),
             //black pieces taken
               Expanded(child: Container()),
        ],
      ),
    );
  }
}