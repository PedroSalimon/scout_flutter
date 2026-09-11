import 'package:flutter/material.dart';

class PlayerSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const PlayerSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Pesquisar jogador',
        hintText: 'Digite o nome do jogador',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          onPressed: onClear,
          icon: const Icon(Icons.close),
        ),
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}
