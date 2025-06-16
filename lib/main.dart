import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int boardSize = 4;
  int winValue = 1024;
  List<List<int>> board = [];
  int movimentos = 0;
  String status = "";

  @override
  void initState() {
    super.initState();
    _resetBoard();
  }

  void _resetBoard() {
    board = List.generate(boardSize, (_) => List.filled(boardSize, 0));
    movimentos = 0;
    status = "";
    _addRandomTile();
  }

  void _addRandomTile() {
    List<Point<int>> empty = [];
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] == 0) {
          empty.add(Point(i, j));
        }
      }
    }
    if (empty.isNotEmpty) {
      final pos = empty[Random().nextInt(empty.length)];
      board[pos.x][pos.y] = 1;
    }
  }

  void _checkStatus() {
    bool hasZero = board.any((row) => row.contains(0));
    bool canMerge = false;

    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize - 1; j++) {
        if (board[i][j] == board[i][j + 1] || board[j][i] == board[j + 1][i]) {
          canMerge = true;
          break;
        }
      }
    }

    bool hasWin = board.any((row) => row.contains(winValue));

    if (hasWin) {
      status = "VOCÊ GANHOU";
    } else if (!hasZero && !canMerge) {
      status = "VOCÊ PERDEU";
    } else {
      status = "";
    }
  }

  void _move(Function mover) {
    setState(() {
      bool moved = mover();
      if (moved) {
        movimentos++;
        _addRandomTile();
        _checkStatus();
      }
    });
  }

  bool _moveLeft() {
    bool moved = false;
    for (int i = 0; i < boardSize; i++) {
      List<int> newRow = List.filled(boardSize, 0);
      int pos = 0;
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] != 0) {
          if (newRow[pos] == 0) {
            newRow[pos] = board[i][j];
          } else if (newRow[pos] == board[i][j]) {
            newRow[pos] *= 2;
            pos++;
          } else {
            pos++;
            newRow[pos] = board[i][j];
          }
        }
      }
      if (board[i].toString() != newRow.toString()) moved = true;
      board[i] = newRow;
    }
    return moved;
  }

  bool _moveRight() {
    bool moved = false;
    for (int i = 0; i < boardSize; i++) {
      List<int> row = board[i].reversed.toList();
      List<int> newRow = List.filled(boardSize, 0);
      int pos = 0;
      for (int j = 0; j < boardSize; j++) {
        if (row[j] != 0) {
          if (newRow[pos] == 0) {
            newRow[pos] = row[j];
          } else if (newRow[pos] == row[j]) {
            newRow[pos] *= 2;
            pos++;
          } else {
            pos++;
            newRow[pos] = row[j];
          }
        }
      }
      newRow = newRow.reversed.toList();
      if (board[i].toString() != newRow.toString()) moved = true;
      board[i] = newRow;
    }
    return moved;
  }

  bool _moveUp() {
    bool moved = false;
    for (int col = 0; col < boardSize; col++) {
      List<int> column = List.generate(boardSize, (row) => board[row][col]);
      List<int> newCol = List.filled(boardSize, 0);
      int pos = 0;
      for (int i = 0; i < boardSize; i++) {
        if (column[i] != 0) {
          if (newCol[pos] == 0) {
            newCol[pos] = column[i];
          } else if (newCol[pos] == column[i]) {
            newCol[pos] *= 2;
            pos++;
          } else {
            pos++;
            newCol[pos] = column[i];
          }
        }
      }
      for (int row = 0; row < boardSize; row++) {
        if (board[row][col] != newCol[row]) moved = true;
        board[row][col] = newCol[row];
      }
    }
    return moved;
  }

  bool _moveDown() {
    bool moved = false;
    for (int col = 0; col < boardSize; col++) {
      List<int> column =
      List.generate(boardSize, (row) => board[row][col]).reversed.toList();
      List<int> newCol = List.filled(boardSize, 0);
      int pos = 0;
      for (int i = 0; i < boardSize; i++) {
        if (column[i] != 0) {
          if (newCol[pos] == 0) {
            newCol[pos] = column[i];
          } else if (newCol[pos] == column[i]) {
            newCol[pos] *= 2;
            pos++;
          } else {
            pos++;
            newCol[pos] = column[i];
          }
        }
      }
      newCol = newCol.reversed.toList();
      for (int row = 0; row < boardSize; row++) {
        if (board[row][col] != newCol[row]) moved = true;
        board[row][col] = newCol[row];
      }
    }
    return moved;
  }

  Color _getColor(int value) {
    switch (value) {
      case 1:
        return Colors.grey[300]!;
      case 2:
        return Colors.lightBlue[200]!;
      case 4:
        return Colors.blue[300]!;
      case 8:
        return Colors.green[300]!;
      case 16:
        return Colors.yellow[300]!;
      case 32:
        return Colors.orange[300]!;
      case 64:
        return Colors.deepOrange[300]!;
      case 128:
        return Colors.purple[300]!;
      case 256:
        return Colors.pink[300]!;
      case 512:
        return Colors.red[300]!;
      case 1024:
        return Colors.teal[300]!;
      case 2048:
        return Colors.amber[400]!;
      case 4096:
        return Colors.black;
      default:
        return Colors.white;
    }
  }

  Widget _cell(int value) {
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(),
        color: _getColor(value),
      ),
      child: Center(
        child: Text(
          value == 0 ? "" : "$value",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Título e contador
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Jogo 2048     --",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 20),
                  Text("Movimentos: $movimentos"),
                ],
              ),
              const SizedBox(height: 10),

              // Status
              Text(
                status,
                style: TextStyle(
                  fontSize: 16,
                  color: status.contains("GANHOU")
                      ? Colors.green
                      : status.contains("PERDEU")
                      ? Colors.red
                      : Colors.black,
                ),
              ),
              const SizedBox(height: 10),

              // Botões de nível
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        boardSize = 4;
                        winValue = 1024;
                        _resetBoard();
                      });
                    },
                    child: const Text("Fácil"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        boardSize = 5;
                        winValue = 2048;
                        _resetBoard();
                      });
                    },
                    child: const Text("Médio"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        boardSize = 6;
                        winValue = 4096;
                        _resetBoard();
                      });
                    },
                    child: const Text("Difícil"),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Tabuleiro + Botões
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tabuleiro
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      color: Colors.grey[200],
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: board.map((row) {
                        return Row(
                          children: row.map((val) => _cell(val)).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Botões
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_upward),
                        onPressed: () => _move(_moveUp),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => _move(_moveLeft),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () => _move(_moveRight),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_downward),
                        onPressed: () => _move(_moveDown),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
