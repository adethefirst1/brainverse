import 'package:flutter/material.dart';

class WordWipeScreen extends StatelessWidget {
  const WordWipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Word Wipe")),
      body: const Center(
        child: Text("Word Wipe Coming Soon", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
