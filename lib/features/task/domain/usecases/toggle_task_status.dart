import '../../../task/data/repositories/task_repository.dart';

class ToggleTaskStatus {
  final TaskRepository repository;
  ToggleTaskStatus(this.repository);

  void call(String id) => repository.toggleTaskStatus(id);
}
