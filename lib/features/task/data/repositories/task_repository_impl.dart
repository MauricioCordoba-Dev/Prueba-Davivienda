import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/task.dart';
import '../../data/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  @override
  Future<void> addTask(Task task) async {
    try {
      if (kIsWeb) {
        // Para web, usar solo SharedPreferences
        await _addTaskWithSharedPreferences(task);
      } else {
        // Para móvil y desktop, usar SQLite
        final db = await AppDatabase.database;
        await db.insert(
          'tasks',
          {
            'id': task.id,
            'title': task.title,
            'description': task.description,
            'isCompleted': task.isCompleted ? 1 : 0,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  Future<void> _addTaskWithSharedPreferences(Task task) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasks = prefs.getStringList('tasks') ?? [];
      
      final taskData = {
        'id': task.id,
        'title': task.title,
        'description': task.description,
        'isCompleted': task.isCompleted,
      };
      
      // Remover tarea existente si existe
      tasks.removeWhere((taskStr) {
        final taskMap = json.decode(taskStr);
        return taskMap['id'] == task.id;
      });
      
      // Agregar nueva tarea
      tasks.add(json.encode(taskData));
      await prefs.setStringList('tasks', tasks);
    } catch (e) {
      print('Error adding task with shared preferences: $e');
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    try {
      if (kIsWeb) {
        // Para web, usar solo SharedPreferences
        await _updateTaskWithSharedPreferences(task);
      } else {
        // Para móvil y desktop, usar SQLite
        final db = await AppDatabase.database;
        await db.update(
          'tasks',
          {
            'title': task.title,
            'description': task.description,
            'isCompleted': task.isCompleted ? 1 : 0,
          },
          where: 'id = ?',
          whereArgs: [task.id],
        );
      }
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  Future<void> _updateTaskWithSharedPreferences(Task task) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasks = prefs.getStringList('tasks') ?? [];
      
      for (int i = 0; i < tasks.length; i++) {
        final taskMap = json.decode(tasks[i]);
        if (taskMap['id'] == task.id) {
          taskMap['title'] = task.title;
          taskMap['description'] = task.description;
          taskMap['isCompleted'] = task.isCompleted;
          tasks[i] = json.encode(taskMap);
          break;
        }
      }
      
      await prefs.setStringList('tasks', tasks);
    } catch (e) {
      print('Error updating task with shared preferences: $e');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      if (kIsWeb) {
        // Para web, usar solo SharedPreferences
        await _deleteTaskWithSharedPreferences(id);
      } else {
        // Para móvil y desktop, usar SQLite
        final db = await AppDatabase.database;
        await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
      }
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  Future<void> _deleteTaskWithSharedPreferences(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasks = prefs.getStringList('tasks') ?? [];
      
      tasks.removeWhere((taskStr) {
        final taskMap = json.decode(taskStr);
        return taskMap['id'] == id;
      });
      
      await prefs.setStringList('tasks', tasks);
    } catch (e) {
      print('Error deleting task with shared preferences: $e');
    }
  }

  @override
  Future<List<Task>> getTasks() async {
    try {
      if (kIsWeb) {
        // Para web, usar solo SharedPreferences
        return await _getTasksWithSharedPreferences();
      } else {
        // Para móvil y desktop, usar SQLite
        final db = await AppDatabase.database;
        final result = await db.query('tasks');
        return result.map((e) => Task(
          id: e['id']?.toString() ?? '',
          title: e['title']?.toString() ?? '',
          description: e['description']?.toString() ?? '',
          isCompleted: (e['isCompleted'] as int) == 1,
        )).toList();
      }
    } catch (e) {
      print('Error getting tasks: $e');
      return [];
    }
  }

  Future<List<Task>> _getTasksWithSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasks = prefs.getStringList('tasks') ?? [];
      
      return tasks.map((taskStr) {
        final taskMap = json.decode(taskStr);
        return Task(
          id: taskMap['id']?.toString() ?? '',
          title: taskMap['title']?.toString() ?? '',
          description: taskMap['description']?.toString() ?? '',
          isCompleted: taskMap['isCompleted'] == true,
        );
      }).toList();
    } catch (e) {
      print('Error getting tasks with shared preferences: $e');
      return [];
    }
  }

  @override
  Future<void> toggleTaskStatus(String id) async {
    try {
      if (kIsWeb) {
        // Para web, usar solo SharedPreferences
        await _toggleTaskStatusWithSharedPreferences(id);
      } else {
        // Para móvil y desktop, usar SQLite
        final db = await AppDatabase.database;
        final result = await db.query('tasks', where: 'id = ?', whereArgs: [id]);

        if (result.isNotEmpty) {
          final current = result.first;
          final currentStatus = (current['isCompleted'] as int) == 1;
          await db.update(
            'tasks',
            {'isCompleted': currentStatus ? 0 : 1},
            where: 'id = ?',
            whereArgs: [id],
          );
        }
      }
    } catch (e) {
      print('Error toggling task status: $e');
    }
  }

  Future<void> _toggleTaskStatusWithSharedPreferences(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasks = prefs.getStringList('tasks') ?? [];
      
      for (int i = 0; i < tasks.length; i++) {
        final taskMap = json.decode(tasks[i]);
        if (taskMap['id'] == id) {
          taskMap['isCompleted'] = !(taskMap['isCompleted'] == true);
          tasks[i] = json.encode(taskMap);
          break;
        }
      }
      
      await prefs.setStringList('tasks', tasks);
    } catch (e) {
      print('Error toggling task status with shared preferences: $e');
    }
  }
}
