import '../../../task/data/repositories/task_repository.dart';

/// Caso de uso para cambiar el estado de una tarea de un usuario específico
class ToggleTaskStatusByUser {
  final TaskRepository repository;
  ToggleTaskStatusByUser(this.repository);

  /// Cambia el estado de una tarea solo si pertenece al usuario especificado
  void call(String id, String userId) => repository.toggleTaskStatusByUser(id, userId);
}
