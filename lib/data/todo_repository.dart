import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/todo.dart';

class TodoRepository {
  static const int _version = 1;
  static const String _dbName = 'Todos.db';

  Future<Database> _getDb() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async => await db.execute(
          "CREATE TABLE Todos(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, description TEXT NOT NULL, isCompleted INTEGER, date INTEGER);"),
      version: _version,
    );
  }

  Future<int> addTodo(Todo todo) async {
    final db = await _getDb();
    return db.insert(
      'Todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTodo(Todo todo) async {
    final db = await _getDb();
    await db.update(
      'Todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<List<Todo>?> getAllTodo() async {
    final db = await _getDb();
    var maps = await db.query('Todos');
    if (maps.isEmpty) {
      return null;
    }
    return List.generate(
      maps.length,
      (index) => Todo.fromMap(
        maps[index],
      ),
    );
  }
}
