import '../../../task/data/repositories/task_repository.dart';

class DeleteTask {
  final TaskRepository repository;
  DeleteTask(this.repository);

  void call(String id) => repository.deleteTask(id);
}