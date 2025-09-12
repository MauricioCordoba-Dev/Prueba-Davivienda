import '../../../task/data/repositories/task_repository.dart';

/// Caso de uso para eliminar una tarea de un usuario específico
class DeleteTaskByUser {
  final TaskRepository repository;
  DeleteTaskByUser(this.repository);

  /// Elimina una tarea solo si pertenece al usuario especificado
  void call(String id, String userId) => repository.deleteTaskByUser(id, userId);
}
