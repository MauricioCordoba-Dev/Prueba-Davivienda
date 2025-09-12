import 'package:easy_task/features/task/data/repositories/auth_repository.dart';

class LogoutUser {
  final AuthRepository repository;
  LogoutUser(this.repository);

  Future<void> call() => repository.logout();
}