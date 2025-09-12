import 'package:easy_task/features/task/data/repositories/user_repository.dart';
import '../entities/user.dart';

class RegisterUser {
  final UserRepository repository;

  RegisterUser(this.repository);

  Future<bool> call(User user) async {
    return await repository.register(user);
  }
}
