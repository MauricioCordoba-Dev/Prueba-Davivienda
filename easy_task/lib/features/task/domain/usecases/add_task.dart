import '../entities/task.dart';
import '../../../task/data/repositories/task_repository.dart';

class AddTask {
  final TaskRepository repository;
  AddTask(this.repository);

  void call(Task task) => repository.addTask(task);
}