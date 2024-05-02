

import 'package:flutter/material.dart';
import 'body_part.dart';


class HangmanPainter extends CustomPainter {
  List<BodyPart> _bodyParts = [];


  HangmanPainter(this._bodyParts);

  @override
  void paint(Canvas canvas, Size size) {
  final Paint paint = Paint()
    ..color = Colors.black
    ..strokeWidth = 3.0
    ..style = PaintingStyle.stroke;

  final double width = size.width;
  final double height = size.height;

  canvas.drawLine(Offset(0, height), Offset(width, height), paint); 
  canvas.drawLine(Offset(width / 2, height), Offset(width / 2, 0), paint);
  canvas.drawLine(Offset(width / 2, 0), Offset(width * 0.75, 0), paint);

  
  if (_bodyParts.contains(BodyPart.head)) {
    canvas.drawCircle(Offset(width * 0.75, height * 0.15), 20.0, paint);
  }
  if (_bodyParts.contains(BodyPart.body)) {
    canvas.drawLine(Offset(width * 0.75, height * 0.25), Offset(width * 0.75, height * 0.65), paint);
  }
  if (_bodyParts.contains(BodyPart.rightArm)) {
    canvas.drawLine(Offset(width * 0.75, height * 0.40), Offset(width * 0.85, height * 0.50), paint);
  }
  if (_bodyParts.contains(BodyPart.leftArm)) {
    canvas.drawLine(Offset(width * 0.75, height * 0.40), Offset(width * 0.65, height * 0.50), paint);
  }
  if (_bodyParts.contains(BodyPart.rightLeg)) {
    canvas.drawLine(Offset(width * 0.75, height * 0.65), Offset(width * 0.85, height * 0.80), paint);
  }
  if (_bodyParts.contains(BodyPart.leftLeg)) {
    canvas.drawLine(Offset(width * 0.75, height * 0.65), Offset(width * 0.65, height * 0.80), paint);
  }
}


  @override
  bool shouldRepaint(HangmanPainter oldDelegate) {
    return oldDelegate._bodyParts != _bodyParts;
  }
}
