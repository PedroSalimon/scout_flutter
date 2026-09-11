import 'package:flutter/material.dart';

import '../models/player.dart';

class RankingItem extends StatelessWidget {
  final int rankingPosition;
  final Player player;
  final int value;
  final String label;

  const RankingItem({
    super.key,
    required this.rankingPosition,
    required this.player,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(rankingPosition.toString())),
      title: Text(
        player.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(player.position),
      trailing: Text(
        '$value $label',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
