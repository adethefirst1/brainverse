import 'package:flutter/material.dart';

class CrosswordScreen extends StatelessWidget {
  const CrosswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crossword")),
      body: const Center(
        child: Text("Crossword Coming Soon", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
