import 'package:flutter/material.dart';

import '../models/player.dart';
import 'ranking_item.dart';

enum RankingType { goals, assists }

class RankingList extends StatelessWidget {
  final List<Player> players;
  final RankingType type;

  const RankingList({super.key, required this.players, required this.type});

  @override
  Widget build(BuildContext context) {
    if (players.isEmpty) {
      return const Center(child: Text('Nenhum jogador cadastrado.'));
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];

        final value = type == RankingType.goals ? player.goals : player.assists;

        final label = type == RankingType.goals ? 'gols' : 'assist.';

        return RankingItem(
          rankingPosition: index + 1,
          player: player,
          value: value,
          label: label,
        );
      },
    );
  }
}
