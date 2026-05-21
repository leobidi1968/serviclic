import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/usuario.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _db;
  static const int _version = 1;

  Future<void> init() async {
    _db ??= await openDatabase(
      join(await getDatabasesPath(), 'serviclic.db'),
      version: _version,
      onCreate: _onCreate,
    );
  }

  Database get db {
    assert(_db != null, 'DatabaseService.init() no fue llamado antes de usar la DB');
    return _db!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id            INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre        TEXT NOT NULL,
        direccion     TEXT NOT NULL,
        ciudad        TEXT NOT NULL,
        departamento  TEXT NOT NULL,
        telefono      TEXT NOT NULL,
        email         TEXT NOT NULL,
        sesion_activa INTEGER NOT NULL DEFAULT 1
      )
    ''');
  }

  Future<bool> hayUsuario() async {
    final rows = await db.query('usuarios', limit: 1);
    return rows.isNotEmpty;
  }

  Future<Usuario?> getUsuario() async {
    final rows = await db.query('usuarios', limit: 1);
    if (rows.isEmpty) return null;
    return Usuario.fromMap(rows.first);
  }

  Future<int> insertUsuario(Usuario usuario) async {
    return db.insert('usuarios', usuario.toMap());
  }

  Future<void> updateUsuario(Usuario usuario) async {
    await db.update(
      'usuarios',
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }
}
