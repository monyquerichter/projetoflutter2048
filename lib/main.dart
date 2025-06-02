import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulação de estado (apenas visual por enquanto)
    String status = "Você perdeu!"; // ou: "Você venceu!"
    int movimentos = 2;

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Linha: Título como texto e contador de movimentos
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

              // Mensagem de vitória ou derrota
              Text(
                status,
                style: TextStyle(
                  fontSize: 16,
                  color: status.contains("venceu") ? Colors.green : Colors.red,
                ),
              ),

              const SizedBox(height: 10),

              // Botões de nível
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

              // Tabuleiro e setas ao lado
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
                      children: [
                        Row(
                          children: [
                            _cell(""), _cell(""), _cell(""), _cell(""),
                          ],
                        ),
                        Row(
                          children: [
                            _cell(""), _cell(""), _cell("1"), _cell(""),
                          ],
                        ),
                        Row(
                          children: [
                            _cell(""), _cell(""), _cell(""), _cell(""),
                          ],
                        ),
                        Row(
                          children: [
                            _cell(""), _cell(""), _cell(""), _cell("1"),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Botões de seta
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_upward),
                        onPressed: () {},
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_downward),
                        onPressed: () {},
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

  static Widget _cell(String text) {
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



