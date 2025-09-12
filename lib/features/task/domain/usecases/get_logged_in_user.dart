import 'package:easy_task/features/task/data/repositories/auth_repository.dart';
import '../entities/user.dart';


class GetLoggedInUser {
  final AuthRepository repository;

  GetLoggedInUser(this.repository);

  Future<User?> call() => repository.getLoggedInUser();
}
