import 'package:sqflite/sqflite.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/task.dart';
import '../../data/repositories/task_repository.dart';

/// Implementación del repositorio de tareas usando SQLite
class TaskRepositoryImpl implements TaskRepository {
  @override
  Future<void> addTask(Task task) async {
    final db = await AppDatabase.database;
    await db.insert(
      'tasks',
      {
        'id': task.id,
        'title': task.title,
        'description': task.description,
        'isCompleted': task.isCompleted ? 1 : 0, // Convertir bool a int para SQLite
        'userId': task.userId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateTask(Task task) async {
    final db = await AppDatabase.database;
    await db.update(
      'tasks',
      {
        'title': task.title,
        'description': task.description,
        'isCompleted': task.isCompleted ? 1 : 0, // Convertir bool a int para SQLite
        'userId': task.userId,
      },
      where: 'id = ? AND userId = ?',
      whereArgs: [task.id, task.userId],
    );
  }

  @override
  Future<void> deleteTask(String id) async {
    final db = await AppDatabase.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Task>> getTasks() async {
    final db = await AppDatabase.database;
    final result = await db.query('tasks');
    return result.map((e) => Task(
      id: e['id']?.toString() ?? '',
      title: e['title']?.toString() ?? '',
      description: e['description']?.toString() ?? '',
      isCompleted: (e['isCompleted'] as int) == 1, // Convertir int a bool
      userId: e['userId']?.toString() ?? '',
    )).toList();
  }

  @override
  Future<List<Task>> getTasksByUser(String userId) async {
    final db = await AppDatabase.database;
    final result = await db.query('tasks', where: 'userId = ?', whereArgs: [userId]);
    return result.map((e) => Task(
      id: e['id']?.toString() ?? '',
      title: e['title']?.toString() ?? '',
      description: e['description']?.toString() ?? '',
      isCompleted: (e['isCompleted'] as int) == 1, // Convertir int a bool
      userId: e['userId']?.toString() ?? '',
    )).toList();
  }

  @override
  Future<void> toggleTaskStatus(String id) async {
    final db = await AppDatabase.database;
    final result = await db.query('tasks', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      final current = result.first;
      final currentStatus = (current['isCompleted'] as int) == 1;
      // Cambiar el estado de completado
      await db.update(
        'tasks',
        {'isCompleted': currentStatus ? 0 : 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  @override
  Future<void> deleteTaskByUser(String id, String userId) async {
    final db = await AppDatabase.database;
    await db.delete('tasks', where: 'id = ? AND userId = ?', whereArgs: [id, userId]);
  }

  @override
  Future<void> toggleTaskStatusByUser(String id, String userId) async {
    final db = await AppDatabase.database;
    final result = await db.query('tasks', where: 'id = ? AND userId = ?', whereArgs: [id, userId]);

    if (result.isNotEmpty) {
      final current = result.first;
      final currentStatus = (current['isCompleted'] as int) == 1;
      // Cambiar el estado de completado
      await db.update(
        'tasks',
        {'isCompleted': currentStatus ? 0 : 1},
        where: 'id = ? AND userId = ?',
        whereArgs: [id, userId],
      );
    }
  }
}
