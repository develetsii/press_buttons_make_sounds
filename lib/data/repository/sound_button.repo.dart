import 'package:sqflite/sqflite.dart';

import '../../domain/models/sound_button.model.dart';

class SoundButtonRepository {
  SoundButtonRepository(this._database);

  final Future<Database> _database;

  Future<List<SoundButtonModel>> getAll() async {
    final db = await _database;

    final rows = await db.query('sound_buttons', orderBy: 'id ASC');

    return rows.map(SoundButtonModel.fromMap).toList();
  }

  Future<int> create(SoundButtonModel button) async {
    final db = await _database;

    return db.insert('sound_buttons', button.toMap());
  }

  Future<int> update(SoundButtonModel button) async {
    final id = button.id;

    if (id == null) {
      throw ArgumentError('Cannot update a button without an ID.');
    }

    final db = await _database;

    return db.update(
      'sound_buttons',
      button.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _database;

    return db.delete('sound_buttons', where: 'id = ?', whereArgs: [id]);
  }
}
