import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/update_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/delete_task_by_user.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/get_tasks_by_user.dart';
import '../../domain/usecases/toggle_task_status.dart';
import '../../domain/usecases/toggle_task_status_by_user.dart';

/// Controlador para gestionar el estado de las tareas
class TaskController extends ChangeNotifier {
  final AddTask addTaskUseCase;
  final UpdateTask updateTaskUseCase;
  final DeleteTask deleteTaskUseCase;
  final DeleteTaskByUser deleteTaskByUserUseCase;
  final GetTasks getTasksUseCase;
  final GetTasksByUser getTasksByUserUseCase;
  final ToggleTaskStatus toggleTaskStatusUseCase;
  final ToggleTaskStatusByUser toggleTaskStatusByUserUseCase;

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks; // Lista de tareas actuales

  TaskController({
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
    required this.deleteTaskByUserUseCase,
    required this.getTasksUseCase,
    required this.getTasksByUserUseCase,
    required this.toggleTaskStatusUseCase,
    required this.toggleTaskStatusByUserUseCase,
  });

  Future<void> loadTasks() async {
    _tasks = await getTasksUseCase();
    notifyListeners();
  }

  /// Carga las tareas de un usuario específico
  Future<void> loadTasksByUser(String userId) async {
    _tasks = await getTasksByUserUseCase(userId);
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    addTaskUseCase(task);
    await loadTasksByUser(task.userId);
  }

  Future<void> updateTask(Task task) async {
    updateTaskUseCase(task);
    await loadTasksByUser(task.userId);
  }

  Future<void> deleteTask(String id) async {
    deleteTaskUseCase(id);
    await loadTasks();
  }

  /// Elimina una tarea solo si pertenece al usuario especificado
  Future<void> deleteTaskByUser(String id, String userId) async {
    deleteTaskByUserUseCase(id, userId);
    await loadTasksByUser(userId);
  }

  Future<void> toggleStatus(String id) async {
    toggleTaskStatusUseCase(id);
    await loadTasks();
  }

  /// Cambia el estado de una tarea solo si pertenece al usuario especificado
  Future<void> toggleStatusByUser(String id, String userId) async {
    toggleTaskStatusByUserUseCase(id, userId);
    await loadTasksByUser(userId);
  }
}