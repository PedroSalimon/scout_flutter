import '../database/app_database.dart';
import '../models/player.dart';

class PlayerRepository {
  Future<int> insert(Player player) async {
    final db = await AppDatabase.instance.database;

    final data = player.toMap();
    data.remove('id');

    return db.insert('players', data);
  }

  Future<List<Player>> getAll() async {
    final db = await AppDatabase.instance.database;

    final result = await db.query('players', orderBy: 'name ASC');

    return result.map(Player.fromMap).toList();
  }

  Future<List<Player>> searchByName(String name) async {
    final db = await AppDatabase.instance.database;

    final result = await db.query(
      'players',
      where: 'name LIKE ?',
      whereArgs: ['%$name%'],
      orderBy: 'name ASC',
    );

    return result.map(Player.fromMap).toList();
  }

  Future<int> update(Player player) async {
    final db = await AppDatabase.instance.database;

    final data = player.toMap();
    data.remove('id');

    return db.update('players', data, where: 'id = ?', whereArgs: [player.id]);
  }

  Future<int> delete(int id) async {
    final db = await AppDatabase.instance.database;

    return db.delete('players', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getTotalPlayers() async {
    final db = await AppDatabase.instance.database;

    final result = await db.rawQuery('SELECT COUNT(*) AS total FROM players');

    return result.first['total'] as int;
  }

  Future<Map<String, int>> getPlayersByPosition() async {
    final db = await AppDatabase.instance.database;

    final result = await db.rawQuery('''
      SELECT position, COUNT(*) AS total
      FROM players
      GROUP BY position
    ''');

    return {
      for (final row in result) row['position'] as String: row['total'] as int,
    };
  }

  Future<List<Player>> getTopScorers() async {
    final db = await AppDatabase.instance.database;

    final result = await db.query('players', orderBy: 'goals DESC', limit: 10);

    return result.map(Player.fromMap).toList();
  }

  Future<List<Player>> getTopAssists() async {
    final db = await AppDatabase.instance.database;

    final result = await db.query(
      'players',
      orderBy: 'assists DESC',
      limit: 10,
    );

    return result.map(Player.fromMap).toList();
  }
}
