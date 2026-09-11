import 'package:flutter/material.dart';

import '../components/expandable_section.dart';
import '../models/player.dart';
import '../repositories/player_repository.dart';
import '../widgets/player_card.dart';
import '../widgets/player_form.dart';
import '../widgets/player_search_field.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  final PlayerRepository _repository = PlayerRepository();

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _matchesController = TextEditingController();

  final _goalsController = TextEditingController();

  final _assistsController = TextEditingController();

  final _searchController = TextEditingController();

  final List<String> _positions = [
    'Goleiro',
    'Zagueiro',
    'Lateral',
    'Volante',
    'Meia',
    'Atacante',
  ];

  String _selectedPosition = 'Goleiro';

  List<Player> _players = [];

  Player? _editingPlayer;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _loadPlayers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _matchesController.dispose();
    _goalsController.dispose();
    _assistsController.dispose();
    _searchController.dispose();

    super.dispose();
  }

  Future<void> _loadPlayers() async {
    setState(() {
      _isLoading = true;
    });

    final players = await _repository.getAll();

    setState(() {
      _players = players;
      _isLoading = false;
    });
  }

  Future<void> _searchPlayers(String value) async {
    if (value.trim().isEmpty) {
      await _loadPlayers();
      return;
    }

    final players = await _repository.searchByName(value.trim());

    setState(() {
      _players = players;
    });
  }

  Future<void> _savePlayer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final player = Player(
      id: _editingPlayer?.id,
      name: _nameController.text.trim(),
      position: _selectedPosition,
      matches: int.parse(_matchesController.text),
      goals: int.parse(_goalsController.text),
      assists: int.parse(_assistsController.text),
    );

    if (_editingPlayer == null) {
      await _repository.insert(player);
    } else {
      await _repository.update(player);
    }

    _clearForm();

    _searchController.clear();

    await _loadPlayers();
  }

  void _editPlayer(Player player) {
    setState(() {
      _editingPlayer = player;

      _nameController.text = player.name;

      _selectedPosition = player.position;

      _matchesController.text = player.matches.toString();

      _goalsController.text = player.goals.toString();

      _assistsController.text = player.assists.toString();
    });
  }

  Future<void> _deletePlayer(Player player) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir jogador'),
          content: Text('Deseja excluir ${player.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await _repository.delete(player.id!);

    _searchController.clear();

    await _loadPlayers();
  }

  void _clearForm() {
    _formKey.currentState?.reset();

    _nameController.clear();
    _matchesController.clear();
    _goalsController.clear();
    _assistsController.clear();

    setState(() {
      _editingPlayer = null;
      _selectedPosition = 'Goleiro';
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _loadPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jogadores')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ExpandableSection(
            title: _editingPlayer == null
                ? 'Cadastrar jogador'
                : 'Editar jogador',
            initiallyExpanded: true,
            child: PlayerForm(
              formKey: _formKey,
              nameController: _nameController,
              matchesController: _matchesController,
              goalsController: _goalsController,
              assistsController: _assistsController,
              positions: _positions,
              selectedPosition: _selectedPosition,
              isEditing: _editingPlayer != null,
              onPositionChanged: (value) {
                setState(() {
                  _selectedPosition = value;
                });
              },
              onSave: _savePlayer,
              onCancel: _clearForm,
            ),
          ),

          const SizedBox(height: 24),

          PlayerSearchField(
            controller: _searchController,
            onChanged: _searchPlayers,
            onClear: _clearSearch,
          ),

          const SizedBox(height: 24),

          Text('Jogadores', style: Theme.of(context).textTheme.titleLarge),

          const SizedBox(height: 12),

          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_players.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('Nenhum jogador encontrado.')),
            )
          else
            ..._players.map(
              (player) => PlayerCard(
                player: player,
                onEdit: () {
                  _editPlayer(player);
                },
                onDelete: () {
                  _deletePlayer(player);
                },
              ),
            ),
        ],
      ),
    );
  }
}
