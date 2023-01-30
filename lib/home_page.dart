import 'package:flutter/material.dart';

import 'alert_dialog.dart';

class Multiplayer extends StatefulWidget {
  const Multiplayer({super.key});

  @override
  State<Multiplayer> createState() => _MultiplayerState();
}

class _MultiplayerState extends State<Multiplayer> {
  TextStyle customText(
          {double fontSize = 16.0,
          FontWeight fontWeight = FontWeight.normal}) =>
      TextStyle(fontSize: fontSize, fontWeight: fontWeight);

  int _scoreX = 0;
  int _scoreO = 0;
  bool _turnO = true;
  int _filledBoxes = 0;
  final List<String> _xoList = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];

  Widget _playerTurn() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Text(
          _turnO ? "Turn of O" : "Turn of X",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _gameBoard() {
    return Expanded(
      flex: 3,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: 9,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              _tapped(index);
            },
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Center(
                  child: Text(
                _xoList[index],
                style: TextStyle(
                    color: _xoList[index] == "X" ? Colors.yellow : Colors.green,
                    fontSize: 40),
              )),
            ),
          );
        },
      ),
    );
  }

  Widget _pointsTable() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(
              20.0,
            ),
            child: Column(
              children: [
                Text('Player X',
                    style: TextStyle(
                        fontSize: 22,
                        color: _turnO ? Colors.white : Colors.green,
                        fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 20,
                ),
                Text(_scoreX.toString(),
                    style: TextStyle(
                        fontSize: 22,
                        color: _turnO ? Colors.white : Colors.green,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(
              20.0,
            ),
            child: Column(
              children: [
                Text('Player O',
                    style: TextStyle(
                        fontSize: 22,
                        color: _turnO ? Colors.green : Colors.white,
                        fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 20,
                ),
                Text(_scoreO.toString(),
                    style: TextStyle(
                        fontSize: 22,
                        color: _turnO ? Colors.green : Colors.white,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _tapped(int index) {
    setState(
      () {
        if (_turnO && _xoList[index] == '') {
          _xoList[index] = 'O';
          _filledBoxes += 1;
        } else if (!_turnO && _xoList[index] == '') {
          _xoList[index] = 'X';
          _filledBoxes += 1;
        }
        _turnO = !_turnO;
        _checkTheWinner();
      },
    );
  }

  void _checkTheWinner() {
    //1. satır
    if (_xoList[0] == _xoList[1] &&
        _xoList[0] == _xoList[2] &&
        _xoList[0] != '') {
      _showAlertDialog("Winner", _xoList[0]);
    }

    //2. satır
    if (_xoList[3] == _xoList[4] &&
        _xoList[3] == _xoList[5] &&
        _xoList[3] != '') {
      _showAlertDialog("Winner", _xoList[3]);
    }

    //3. satır
    if (_xoList[6] == _xoList[7] &&
        _xoList[6] == _xoList[8] &&
        _xoList[6] != '') {
      _showAlertDialog("Winner", _xoList[6]);
    }

    //1. sütun
    if (_xoList[0] == _xoList[3] &&
        _xoList[0] == _xoList[6] &&
        _xoList[0] != '') {
      _showAlertDialog("Winner", _xoList[0]);
    }

    //2. sütun
    if (_xoList[1] == _xoList[4] &&
        _xoList[1] == _xoList[7] &&
        _xoList[1] != '') {
      _showAlertDialog("Winner", _xoList[1]);
    }

    //3. sütun
    if (_xoList[2] == _xoList[5] &&
        _xoList[2] == _xoList[8] &&
        _xoList[2] != '') {
      _showAlertDialog("Winner", _xoList[2]);
    }

    //1. çapraz
    if (_xoList[0] == _xoList[4] &&
        _xoList[0] == _xoList[8] &&
        _xoList[0] != '') {
      _showAlertDialog("Winner", _xoList[0]);
    }

    //2. çapraz
    if (_xoList[2] == _xoList[4] &&
        _xoList[2] == _xoList[6] &&
        _xoList[2] != '') {
      _showAlertDialog("Winner", _xoList[2]);
    }

    //beraberlik
    if (_filledBoxes == 9) return _showAlertDialog("Draw", '');
  }

  void _showAlertDialog(String title, String winner) {
    showAlertDialog(
        context: context,
        title: title,
        content: winner == ''
            ? 'The match ended in a draw'
            : 'The winner is ${winner.toUpperCase()}',
        defaultActionText: 'OK',
        onOkPressed: () {
          _clearBoard();
          Navigator.of(context).pop();
        });

    if (winner == 'O') {
      _scoreO += 1;
    } else if (winner == 'X') {
      _scoreX += 1;
    }
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        _xoList[i] = '';
      }
    });

    _filledBoxes = 0;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey[900],
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _clearBoard();
              },
            )
          ],
          title: Text(
            'Tic Tac Toe',
            style: customText(fontSize: 20.0, fontWeight: FontWeight.w800),
          ),
        ),
        backgroundColor: Colors.grey[900],
        body: Column(
          children: [
            _pointsTable(),
            _gameBoard(),
            _playerTurn(),
          ],
        ),
      ),
    );
  }
}
