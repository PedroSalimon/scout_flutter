import 'package:flutter/material.dart';

class PlayerForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController matchesController;
  final TextEditingController goalsController;
  final TextEditingController assistsController;

  final List<String> positions;
  final String selectedPosition;

  final bool isEditing;

  final ValueChanged<String> onPositionChanged;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const PlayerForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.matchesController,
    required this.goalsController,
    required this.assistsController,
    required this.positions,
    required this.selectedPosition,
    required this.isEditing,
    required this.onPositionChanged,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nome do jogador',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Informe o nome';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: selectedPosition,
            decoration: const InputDecoration(
              labelText: 'Posição',
              border: OutlineInputBorder(),
            ),
            items: positions
                .map(
                  (position) =>
                      DropdownMenuItem(value: position, child: Text(position)),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                onPositionChanged(value);
              }
            },
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _NumberField(
                  controller: matchesController,
                  label: 'Jogos',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _NumberField(controller: goalsController, label: 'Gols'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _NumberField(
                  controller: assistsController,
                  label: 'Assist.',
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onSave,
              icon: Icon(isEditing ? Icons.save : Icons.add),
              label: Text(
                isEditing ? 'Salvar alterações' : 'Cadastrar jogador',
              ),
            ),
          ),

          if (isEditing)
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: onCancel,
                child: const Text('Cancelar edição'),
              ),
            ),
        ],
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const _NumberField({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Obrigatório';
        }

        final number = int.tryParse(value);

        if (number == null || number < 0) {
          return 'Inválido';
        }

        return null;
      },
    );
  }
}
