import '../entities/task.dart';
import '../../../task/data/repositories/task_repository.dart';

/// Caso de uso para obtener tareas de un usuario específico
class GetTasksByUser {
  final TaskRepository repository;
  GetTasksByUser(this.repository);

  /// Obtiene todas las tareas de un usuario específico
  Future<List<Task>> call(String userId) => repository.getTasksByUser(userId);
}
