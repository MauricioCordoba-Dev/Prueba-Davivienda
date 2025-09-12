
import 'package:easy_task/features/task/domain/entities/user.dart';

abstract class UserRepository {
  Future<User?> login(String username, String password);
  Future<bool> register(User user);
  Future<void> logout();
  Future<User?> getLoggedInUser();
}
