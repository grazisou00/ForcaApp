import 'package:flutter/material.dart';
import 'hangman_painter.dart';
import 'dart:math';

class HangmanScreen extends StatefulWidget {
  @override
  _HangmanScreenState createState() => _HangmanScreenState();
}

class _HangmanScreenState extends State<HangmanScreen> {
  final List<String> _words = ['FLUTTER', 'DESENVOLVIMENTO', 'PROGRAMAÇÃO']; // Lista de palavras
  final List<String> _hints = ['Framework para UI', 'Construção de software', 'Escrever código']; // Lista de dicas
  String _selectedWord = '';
  String _hint = '';
  String _maskedWord = '';
  int _tries = 6; // Número de tentativas permitidas
  List<String> _guessedLetters = [];
  TextEditingController _wordController = TextEditingController();
  bool _customWord = false;
  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    _pickRandomWord();
  }

  void _pickRandomWord() {
    final random = Random();
    final index = random.nextInt(_words.length);
    _selectedWord = _words[index];
    _hint = _hints[index];
    _maskedWord = _selectedWord.replaceAll(RegExp(r'\w'), '_');
    _customWord = false;
    _gameOver = false;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _gameOver
          ? _buildGameOverScreen()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Dica: $_hint'),
                SizedBox(height: 20),
                _buildHangman(),
                SizedBox(height: 20),
                Text(_maskedWord, style: TextStyle(fontSize: 24)),
                SizedBox(height: 20),
                if (!_customWord) _buildKeyboard(),
                if (_customWord) _buildWordInput(),
                SizedBox(height: 20),
                Text('Tentativas restantes: $_tries'),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _giveUp(),
                      child: Text('Desistir'),
                    ),
                    SizedBox(width: 20),
                    if (_tries == 0) _buildRevealButton(),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildGameOverScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _tries == 0 ? 'Você perdeu!' : 'Você venceu!',
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _resetGame(),
          child: Text('Jogar Novamente'),
        ),
      ],
    );
  }

  Widget _buildHangman() {
    return Container(
      width: 200,
      height: 200,
      child: CustomPaint(
        painter: HangmanPainter(_tries),
      ),
    );
  }

  Widget _buildKeyboard() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.0,
      runSpacing: 8.0,
      children: List.generate(26, (index) {
        final letter = String.fromCharCode('A'.codeUnitAt(0) + index);
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: ElevatedButton(
            onPressed: _guessedLetters.contains(letter) ? null : () => _guessLetter(letter),
            child: Text(letter),
          ),
        );
      }),
    );
  }

  Widget _buildRevealButton() {
    return ElevatedButton(
      onPressed: () {
        _showDialog('A palavra era:', _selectedWord);
      },
      child: Text('Revelar Palavra'),
    );
  }

  Widget _buildWordInput() {
    return Column(
      children: [
        TextField(
          controller: _wordController,
          decoration: InputDecoration(
            labelText: 'Insira a palavra secreta',
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (_wordController.text.isNotEmpty) {
              _selectedWord = _wordController.text.toUpperCase();
              _hint = 'Palavra Personalizada';
              _maskedWord = _selectedWord.replaceAll(RegExp(r'\w'), '_');
              _customWord = true;
              setState(() {});
            }
          },
          child: Text('Confirmar Palavra'),
        ),
      ],
    );
  }

  void _guessLetter(String letter) {
    setState(() {
      _guessedLetters.add(letter);
      if (_selectedWord.contains(letter)) {
        _updateMaskedWord(letter);
        if (_maskedWord == _selectedWord) {
          _gameOver = true;
        }
      } else {
        _tries--;
        if (_tries == 0) {
          _gameOver = true;
        }
      }
    });
  }

  void _updateMaskedWord(String letter) {
    for (int i = 0; i < _selectedWord.length; i++) {
      if (_selectedWord[i] == letter) {
        _maskedWord = _maskedWord.replaceRange(i, i + 1, letter);
      }
    }
  }

  void _giveUp() {
    setState(() {
      _gameOver = true;
    });
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: Text('Jogar Novamente'),
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      _tries = 6;
      _guessedLetters.clear();
      _wordController.clear();
      _pickRandomWord();
    });
  }

  @override
  void dispose() {
    _wordController.dispose();
    super.dispose();
  }
}
