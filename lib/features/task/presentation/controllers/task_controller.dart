import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/update_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/toggle_task_status.dart';

class TaskController extends ChangeNotifier {
  final AddTask addTaskUseCase;
  final UpdateTask updateTaskUseCase;
  final DeleteTask deleteTaskUseCase;
  final GetTasks getTasksUseCase;
  final ToggleTaskStatus toggleTaskStatusUseCase;

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  TaskController({
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
    required this.getTasksUseCase,
    required this.toggleTaskStatusUseCase,
  });

  Future<void> loadTasks() async {
    _tasks = await getTasksUseCase();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    addTaskUseCase(task);
    await loadTasks();
  }

  Future<void> deleteTask(String id) async {
    deleteTaskUseCase(id);
    await loadTasks();
  }

  Future<void> toggleStatus(String id) async {
    toggleTaskStatusUseCase(id);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await updateTaskUseCase(task);
    await loadTasks();
  }
}