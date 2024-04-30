import 'package:flutter/material.dart';

class HangmanPainter extends CustomPainter {
  final int _tries;

  HangmanPainter(this._tries);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final double width = size.width;
    final double height = size.height;
     switch (_tries) {
      case 6:
        // Base
        canvas.drawLine(Offset(0, height), Offset(width, height), paint);
        // Poste vertical
        canvas.drawLine(Offset(width / 2, height), Offset(width / 2, 0), paint);
        // Trave horizontal
        canvas.drawLine(Offset(width / 2, 0), Offset(width * 0.75, 0), paint);
        break;
      case 5:
        // Cabeça
        canvas.drawCircle(Offset(width * 0.75, height * 0.15), 20.0, paint);
        break;
      case 4:
        // Corpo
        canvas.drawLine(Offset(width * 0.75, height * 0.35), Offset(width * 0.75, height * 0.65), paint);
        break;
      case 3:
        // Braço esquerdo
        canvas.drawLine(Offset(width * 0.75, height * 0.40), Offset(width * 0.65, height * 0.50), paint);
        break;
      case 2:
        // Braço direito
        canvas.drawLine(Offset(width * 0.75, height * 0.40), Offset(width * 0.85, height * 0.50), paint);
        break;
      case 1:
        // Perna esquerda
        canvas.drawLine(Offset(width * 0.75, height * 0.65), Offset(width * 0.65, height * 0.80), paint);
        break;
      case 0:
        // Perna direita
        canvas.drawLine(Offset(width * 0.75, height * 0.65), Offset(width * 0.85, height * 0.80), paint);
        break;
    }
  }

  @override
  bool shouldRepaint(HangmanPainter oldDelegate) {
    return oldDelegate._tries != _tries;
  }
}
