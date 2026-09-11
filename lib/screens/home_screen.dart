import 'package:flutter/material.dart';

import '../models/player.dart';
import '../repositories/player_repository.dart';
import '../widgets/dashboard_indicator_card.dart';
import '../widgets/ranking_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PlayerRepository _repository = PlayerRepository();

  final List<String> _positions = [
    'Goleiro',
    'Zagueiro',
    'Lateral',
    'Volante',
    'Meia',
    'Atacante',
  ];

  int _totalPlayers = 0;

  Map<String, int> _playersByPosition = {};

  List<Player> _topScorers = [];
  List<Player> _topAssists = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
    });

    final total = await _repository.getTotalPlayers();

    final positions = await _repository.getPlayersByPosition();

    final scorers = await _repository.getTopScorers();

    final assists = await _repository.getTopAssists();

    setState(() {
      _totalPlayers = total;

      _playersByPosition = positions;

      _topScorers = scorers;

      _topAssists = assists;

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: const Text('Scout de Jogadores')),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadDashboard,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      'Elenco por posição',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    const SizedBox(height: 16),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _positions.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemBuilder: (context, index) {
                        final position = _positions[index];

                        final total = _playersByPosition[position] ?? 0;

                        return DashboardIndicatorCard(
                          title: position,
                          value: total,
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    DashboardIndicatorCard(
                      title: 'Total de jogadores',
                      value: _totalPlayers,
                    ),

                    const SizedBox(height: 32),

                    Text(
                      'Destaques',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    const SizedBox(height: 12),

                    const TabBar(
                      tabs: [
                        Tab(text: 'Artilheiros'),
                        Tab(text: 'Garçons'),
                      ],
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      height: 520,
                      child: TabBarView(
                        children: [
                          RankingList(
                            players: _topScorers,
                            type: RankingType.goals,
                          ),
                          RankingList(
                            players: _topAssists,
                            type: RankingType.assists,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
