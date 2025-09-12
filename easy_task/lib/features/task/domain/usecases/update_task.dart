import '../entities/task.dart';
import '../../../task/data/repositories/task_repository.dart';

/// Caso de uso para actualizar una tarea existente
class UpdateTask {
  final TaskRepository repository;
  UpdateTask(this.repository);

  /// Actualiza una tarea en el repositorio
  void call(Task task) => repository.updateTask(task);
}
