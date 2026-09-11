import 'package:flutter/material.dart';

class PlayerStat extends StatelessWidget {
  final String label;
  final int value;

  const PlayerStat({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }
}
