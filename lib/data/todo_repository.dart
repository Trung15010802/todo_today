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

  Future<void> addTodo(Todo todo) async {
    final db = await _getDb();
    bool isTodoExist = await checkTodoExist(todo);
    if (isTodoExist) {
      updateTodo(todo);
    } else {
      db.insert(
        'Todos',
        todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
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

  Future<void> deleteTodo(Todo todo) async {
    final db = await _getDb();
    await db.delete(
      'Todos',
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<List<Todo>> searchTodoByTitle(String keyword) async {
    final db = await _getDb();
    var maps = await db.query(
      'Todos',
      where: 'title LIKE ?',
      whereArgs: ['%$keyword%'],
    );
    if (maps.isEmpty) {
      return [];
    }
    return List.generate(
      maps.length,
      (index) => Todo.fromMap(maps[index]),
    );
  }

  Future<List<Todo>> getAllTodo() async {
    final db = await _getDb();
    var maps = await db.query('Todos');
    if (maps.isEmpty) {
      return [];
    }
    return List.generate(
      maps.length,
      (index) => Todo.fromMap(
        maps[index],
      ),
    );
  }

  Future<Todo> getTodo(Todo todo) async {
    final db = await _getDb();
    final result = await db.query(
      'Todos',
      where: 'id = ?',
      whereArgs: [todo.id],
    );
    return Todo.fromMap(result.first);
  }

  Future<bool> checkTodoExist(Todo todo) async {
    final db = await _getDb();

    try {
      await db.query(
        'Todos',
        where: 'id = ?',
        whereArgs: [todo.id],
      );
    } on Exception catch (_) {
      return false;
    }

    return true;
  }

  Future<List<Todo>> getTodoByCompletionStatus(
      bool isCompleted, DateTime dateTime) async {
    final db = await _getDb();
    String sql =
        'SELECT * FROM Todos WHERE isCompleted = ${isCompleted ? 1 : 0} AND date = ${dateTime.millisecondsSinceEpoch}';
    var maps = await db.rawQuery(sql);
    if (maps.isEmpty) {
      return [];
    }
    return List.generate(
      maps.length,
      (index) => Todo.fromMap(maps[index]),
    );
  }

  Future<int> countTodoByCompletedStatus(bool isCompleted,
      {DateTime? dateTime}) async {
    final db = await _getDb();
    String sql =
        'SELECT COUNT(*) FROM Todos WHERE isCompleted = ${isCompleted ? 1 : 0}';

    if (dateTime != null) {
      sql += " AND date = '${dateTime.millisecondsSinceEpoch}'";
    }
    final result = await db.rawQuery(sql);

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<Todo>> getTodoByDate(DateTime dateTime) async {
    final db = await _getDb();
    var maps = await db.query(
      'Todos',
      where: 'date = ?',
      whereArgs: [dateTime.millisecondsSinceEpoch],
    );

    if (maps.isEmpty) {
      return [];
    }
    return List.generate(
      maps.length,
      (index) => Todo.fromMap(maps[index]),
    );
  }
}
