import 'package:chess_game/components/piece.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece?piece;
  final bool isSelected;
  final bool isValidMove;
  final void Function()? onTap;
  

  const Square({
    super.key,
    required this.isWhite,
    required this.piece,
    required this.isSelected,
    required this.isValidMove,
    required this.onTap,

    });

  @override
  Widget build(BuildContext context) {

    Color? squareColor;

    //if selected, square is green
    if(isSelected){
      squareColor =const Color.fromARGB(205, 163, 176, 233);
      
    }
    else if(isValidMove){
      squareColor =  const Color.fromARGB(230, 147, 87, 87); 
    }

    //otherwise ,it's white or black
    else{
      squareColor = isWhite? const Color.fromARGB(255, 235, 233, 233):const Color.fromARGB(198, 14, 116, 79);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
       
        color: squareColor,
        margin: EdgeInsets.all(isValidMove? 8:0),
        child:  piece!=null? Image.asset(
          
          piece!.isWhite? piece!.white_imagePath:piece!.black_imagePath,
          )
          :null,
      ),
    );
  }
}