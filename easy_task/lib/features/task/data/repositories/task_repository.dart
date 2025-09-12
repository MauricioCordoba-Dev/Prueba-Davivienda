import '../../domain/entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<List<Task>> getTasksByUser(String userId);
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
  Future<void> deleteTaskByUser(String id, String userId);
  Future<void> toggleTaskStatus(String id);
  Future<void> toggleTaskStatusByUser(String id, String userId);
}
