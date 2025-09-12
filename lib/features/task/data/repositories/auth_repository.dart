import '../../domain/entities/user.dart';

abstract class AuthRepository {
  Future<bool> register(User user);
  Future<User?> login(String username, String password);
  Future<User?> getLoggedInUser();
  Future<void> logout();
}