import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'book_library.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books(
        id INTEGER PRIMARY KEY,
        title TEXT,
        author TEXT,
        shelf TEXT
      )
    ''');
  }

  Future<int> insertBook(Map<String, dynamic> book) async {
    Database db = await instance.database;
    return await db.insert('books', book);
  }

  Future<List<Map<String, dynamic>>> retrieveBooks() async {
    Database db = await instance.database;
    return await db.query('books');
  }

  Future<int> updateBook(Map<String, dynamic> book) async {
    Database db = await instance.database;
    return await db.update('books', book, where: 'id = ?', whereArgs: [book['id']]);
  }

  Future<int> deleteBook(int id) async {
    Database db = await instance.database;
    return await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }
}
