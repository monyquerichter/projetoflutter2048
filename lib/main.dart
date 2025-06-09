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
  List<List<int>> board = List.generate(4, (_) => List.filled(4, 0));
  int movimentos = 0;
  String status = "";

  @override
  void initState() {
    super.initState();
    _addRandomTile();
    _addRandomTile();
  }

  void _addRandomTile() {
    List<Point<int>> empty = [];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (board[i][j] == 0) {
          empty.add(Point(i, j));
        }
      }
    }
    if (empty.isNotEmpty) {
      final pos = empty[Random().nextInt(empty.length)];
      board[pos.x][pos.y] = Random().nextBool() ? 2 : 4;
    }
  }

  void _checkStatus() {
    bool hasZero = board.any((row) => row.contains(0));
    bool canMerge = false;

    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == board[i][j + 1] ||
            board[j][i] == board[j + 1][i]) {
          canMerge = true;
          break;
        }
      }
    }

    bool has2048 = board.any((row) => row.contains(2048));

    if (has2048) {
      status = "Você venceu!";
    } else if (!hasZero && !canMerge) {
      status = "Você perdeu!";
    } else {
      status = "";
    }
  }

  void _moveLeft() {
    setState(() {
      bool moved = false;
      for (int i = 0; i < 4; i++) {
        List<int> newRow = List.filled(4, 0);
        int pos = 0;
        for (int j = 0; j < 4; j++) {
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
      if (moved) {
        movimentos++;
        _addRandomTile();
        _checkStatus();
      }
    });
  }

  void _moveRight() {
    setState(() {
      bool moved = false;
      for (int i = 0; i < 4; i++) {
        List<int> row = board[i].reversed.toList();
        List<int> newRow = List.filled(4, 0);
        int pos = 0;
        for (int j = 0; j < 4; j++) {
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
      if (moved) {
        movimentos++;
        _addRandomTile();
        _checkStatus();
      }
    });
  }

  void _moveUp() {
    setState(() {
      bool moved = false;
      for (int col = 0; col < 4; col++) {
        List<int> column = List.generate(4, (row) => board[row][col]);
        List<int> newCol = List.filled(4, 0);
        int pos = 0;
        for (int i = 0; i < 4; i++) {
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
        for (int row = 0; row < 4; row++) {
          if (board[row][col] != newCol[row]) moved = true;
          board[row][col] = newCol[row];
        }
      }
      if (moved) {
        movimentos++;
        _addRandomTile();
        _checkStatus();
      }
    });
  }

  void _moveDown() {
    setState(() {
      bool moved = false;
      for (int col = 0; col < 4; col++) {
        List<int> column = List.generate(4, (row) => board[row][col]).reversed.toList();
        List<int> newCol = List.filled(4, 0);
        int pos = 0;
        for (int i = 0; i < 4; i++) {
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
        for (int row = 0; row < 4; row++) {
          if (board[row][col] != newCol[row]) moved = true;
          board[row][col] = newCol[row];
        }
      }
      if (moved) {
        movimentos++;
        _addRandomTile();
        _checkStatus();
      }
    });
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
                  color: status.contains("venceu") ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 10),

              // Botões de nível (sem função por enquanto)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: () {}, child: const Text("Fácil")),
                  const SizedBox(width: 10),
                  ElevatedButton(onPressed: () {}, child: const Text("Médio")),
                  const SizedBox(width: 10),
                  ElevatedButton(onPressed: () {}, child: const Text("Difícil")),
                ],
              ),
              const SizedBox(height: 30),

              // Tabuleiro e botões de seta
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
                          children: row.map((value) {
                            return _cell(value == 0 ? "" : "$value");
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Botões de seta
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_upward),
                        onPressed: _moveUp,
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: _moveLeft,
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: _moveRight,
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_downward),
                        onPressed: _moveDown,
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

  Widget _cell(String text) {
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(),
        color: Colors.white,
      ),
      child: Center(child: Text(text)),
    );
  }
}