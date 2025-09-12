import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Gestor de base de datos SQLite para la aplicación
class AppDatabase {
  static Database? _db;

  /// Obtiene la instancia de la base de datos (singleton)
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  /// Inicializa la base de datos y crea las tablas necesarias
  static Future<Database> initDb() async {
    final path = join(await getDatabasesPath(), 'task_db.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Crear tabla de tareas
        await db.execute('''
          CREATE TABLE tasks (
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            isCompleted INTEGER,
            userId TEXT
          )
        ''');
      },
    );
  }
}
