
import 'package:flutter/material.dart';
import 'hangman_painter.dart';
import 'dart:math';
import 'body_part.dart';

class HangmanScreen extends StatefulWidget {
  @override
  _HangmanScreenState createState() => _HangmanScreenState();
}

class _HangmanScreenState extends State<HangmanScreen> {
  final List<String> _words = ['FLUTTER', 'DESENVOLVIMENTO', 'PROGRAMAÇÃO', 'ALGORITMO', 'FUNÇÃO', 'LOOP', 'ARRAY', 'COMPILADOR', 'DEBUGAR', 'RECURSIVIDADE'];
  final List<String> _hints = ['Framework para UI', 'Construção de software', 'Escrever código','Conjunto de passos sequenciais para resolver um problema', 'bloco de código reutilizável que realiza uma tarefa específica', 'Uma estrutura de controle que repete um bloco de código até que uma condição seja atendida', 'estrutura de dados que armazena uma coleção de elementos do mesmo tipo', 'Programa que traduz código-fonte em linguagem de programação para código de máquina', 'Processo de identificar e corrigir erros em um programa', 'conceito em programação onde uma função chama a si mesma repetidamente até atingir uma condição de parada' ];
  String _selectedWord = '';
  String _maskedWord = '';
  int _tries = 6;
  List<String> _guessedLetters = [];
  TextEditingController _wordController = TextEditingController();
  bool _customWord = false;
  bool _gameOver = false;
  List<BodyPart> _bodyParts = [];
  List<int> _bodyPartsShown = [];
  bool _showHint = false;

  List<Widget> _buildAlphabetButtons() {
    return List.generate(26, (index) {
      final letter = String.fromCharCode('A'.codeUnitAt(0) + index);
      return _buildButton(letter);
    });
  }

  List<Widget> _buildSpecialCharacterButtons(List<String> characters) {
    return characters.map((char) => _buildButton(char)).toList();
  }

  final List<BodyPart> _bodyPartsList = [
    BodyPart.head,
    BodyPart.body,
    BodyPart.leftArm,
    BodyPart.rightArm,
    BodyPart.leftLeg,
    BodyPart.rightLeg,
  ];

  @override
  void initState() {
    super.initState();
    _pickRandomWord();
    _bodyPartsShown.clear();
  }

  void _pickRandomWord() {
    final random = Random();
    final index = random.nextInt(_words.length);
    _selectedWord = _words[index];
    _maskedWord = '';
    for (int i = 0; i < _selectedWord.length; i++) {
      if (_selectedWord[i].toUpperCase().contains(RegExp(r'[A-ZÇÃÕÊ]'))) {
        _maskedWord += '_';
      } else {
        _maskedWord += _selectedWord[i];
      }
    }

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
                if (_showHint) _buildHint(),
                const SizedBox(height: 20),
                _buildHangman(),
                const SizedBox(height: 20),
                Text(_maskedWord, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                if (!_customWord) _buildKeyboard(),
                if (_customWord) _buildWordInput(),
                const SizedBox(height: 20),
                Text('Tentativas restantes: $_tries'),
                const SizedBox(height: 20),
                if (_tries == 0) _buildRevealButton(),
              ],
            ),
    );
  }

  Widget _buildGameOverScreen() {
    String message = _tries == 0 ? 'Você perdeu!' : _gameOver ? 'Você venceu!' : 'Você desistiu!';
    if (_gameOver) {
      _maskedWord = message; 
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _resetGame(),
          child: const Text('Jogar Novamente'),
        ),
      ],
    );
  }

  Widget _buildButton(String text) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: _guessedLetters.contains(text) ? null : () => _guessLetter(text),
        child: Text(text),
      ),
    );
  }

  Widget _buildHangman() {
    return Container(
      width: 200,
      height: 200,
      child: CustomPaint(
        painter: HangmanPainter(_bodyParts),
      ),
    );
  }

  Widget _buildKeyboard() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        ..._buildAlphabetButtons(),
        ..._buildSpecialCharacterButtons(['Ç', 'Ã', 'Õ', 'Ê']), // Adiciona botões para caracteres especiais
      ],
    );
  }

  Widget _buildRevealButton() {
    return ElevatedButton(
      onPressed: () {
        _showDialog('A palavra era:', _selectedWord);
      },
      child: const Text('Revelar Palavra'),
    );
  }

  Widget _buildHint() {
    return Text(
      'Dica: ${_hints[_words.indexOf(_selectedWord)]}',
      style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
    );
  }

  Widget _buildWordInput() {
    return Column(
      children: [
        TextField(
          controller: _wordController,
          decoration: const InputDecoration(
            labelText: 'Insira a palavra secreta',
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (_wordController.text.isNotEmpty) {
              _selectedWord = _wordController.text.toUpperCase();
              _maskedWord = _selectedWord.replaceAll(RegExp(r'\w'), '_');
              _customWord = true;
              setState(() {});
            }
          },
          child: const Text('Confirmar Palavra'),
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
        if (!_bodyPartsShown.contains(_tries)) {
          _bodyParts.add(_bodyPartsList[6 - _tries]);
          _bodyPartsShown.add(_tries);
        }
        _tries--;
        if (_tries == 2 && !_gameOver && !_showHint) {
          _showHint = true;
        }
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
              child: const Text('Jogar Novamente'),
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
      _bodyParts.clear();
      _bodyPartsShown.clear();
      _pickRandomWord();
      _showHint = false;
    });
  }

  @override
  void dispose() {
    _wordController.dispose();
    super.dispose();
  }
}
