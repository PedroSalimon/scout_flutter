class Player {
  final int? id;
  final String name;
  final String position;
  final int matches;
  final int goals;
  final int assists;

  const Player({
    this.id,
    required this.name,
    required this.position,
    required this.matches,
    required this.goals,
    required this.assists,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'matches': matches,
      'goals': goals,
      'assists': assists,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'] as int?,
      name: map['name'] as String,
      position: map['position'] as String,
      matches: map['matches'] as int,
      goals: map['goals'] as int,
      assists: map['assists'] as int,
    );
  }
}
