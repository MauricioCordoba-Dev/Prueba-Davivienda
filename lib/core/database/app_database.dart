import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
class AppDatabase {
  static Database? _db;
  static bool _initialized = false;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  static Future<void> _initializeDatabase() async {
    if (_initialized) return;
    
    try {
      // Solo inicializar SQLite para móvil y desktop, no para web
      if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
        // Para desktop
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }
      // Para móvil (Android/iOS), usar sqflite por defecto
      // Para web, no usar SQLite
      
      _initialized = true;
    } catch (e) {
      print('Error initializing database: $e');
      _initialized = true;
    }
  }

  static Future<Database> initDb() async {
    await _initializeDatabase();
    
    // Solo usar SQLite para móvil y desktop
    if (kIsWeb) {
      throw UnsupportedError('SQLite is not supported on web. Use SharedPreferences instead.');
    }
    
    final path = join(await getDatabasesPath(), 'task_db.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        try {
          // Crear tabla de usuarios
          await db.execute('''
            CREATE TABLE users (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              username TEXT UNIQUE NOT NULL,
              passwordHash TEXT NOT NULL
            )
          ''');
          
          // Crear tabla de tareas
          await db.execute('''
            CREATE TABLE tasks (
              id TEXT PRIMARY KEY,
              title TEXT,
              description TEXT,
              isCompleted INTEGER
            )
          ''');
        } catch (e) {
          print('Error creating tables: $e');
        }
      },
    );
  }

  // Método para verificar si la base de datos está disponible
  static Future<bool> isDatabaseAvailable() async {
    if (kIsWeb) {
      return false; // SQLite no está disponible en web
    }
    
    try {
      await database;
      return true;
    } catch (e) {
      print('Database not available: $e');
      return false;
    }
  }
}
