import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'note.dart';

class NoteDb {
  NoteDb._();
  static final NoteDb instance = NoteDb._();

  static const _dbName = 'notes.db';
  static const _dbVersion = 1;
  static const table = 'notes';

  Database? _db;

  // =========================
  // INIT DATABASE
  // =========================
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        deadline TEXT
      )
    ''');
  }

  // =========================
  // INSERT NOTE
  // =========================
  Future<int> insert(Note note) async {
    final db = await database;
    return db.insert(
      table,
      {
        'title': note.title,
        'content': note.content,
        'createdAt': note.createdAt.toIso8601String(),
        'deadline': note.deadline?.toIso8601String(),
      },
    );
  }

  // =========================
  // GET ALL NOTES
  // =========================
  Future<List<Note>> getAll() async {
    final db = await database;
    final maps = await db.query(
      table,
      orderBy: 'createdAt DESC',
    );

    return maps.map((e) => Note(
      id: e['id'] as int,
      title: e['title'] as String,
      content: e['content'] as String,
      createdAt: DateTime.parse(e['createdAt'] as String),
      deadline: e['deadline'] == null
          ? null
          : DateTime.parse(e['deadline'] as String),
    )).toList();
  }

  // =========================
  // DELETE NOTE
  // =========================
  Future<int> delete(int id) async {
    final db = await database;
    return db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
