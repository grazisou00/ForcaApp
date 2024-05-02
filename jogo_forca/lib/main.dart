import 'package:flutter/material.dart';
import 'hangman/hangman_screen.dart';

void main() => runApp(HangmanGame());

class HangmanGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hangman Game',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Jogo da forca'),
        ),
        body: HangmanScreen(),
      ),
    );
  }
}
