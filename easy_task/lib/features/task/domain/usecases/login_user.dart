import 'package:easy_task/features/task/data/repositories/auth_repository.dart';
import 'package:easy_task/features/task/domain/entities/user.dart';

class LoginUser {
  final AuthRepository repository;
  LoginUser(this.repository);

  Future<User?> call(String username, String password) => repository.login(username, password);
}