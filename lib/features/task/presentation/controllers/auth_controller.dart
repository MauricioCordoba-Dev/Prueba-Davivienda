import 'package:easy_task/features/task/domain/entities/user.dart';
import 'package:easy_task/features/task/domain/usecases/get_logged_in_user.dart';
import 'package:easy_task/features/task/domain/usecases/login_user.dart';
import 'package:easy_task/features/task/domain/usecases/logout_user.dart';
import 'package:easy_task/features/task/domain/usecases/register_user.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/user_repository_impl.dart';

class AuthController extends ChangeNotifier {
  final RegisterUser registerUser;
  final LoginUser loginUser;
  final LogoutUser logoutUser;
  final GetLoggedInUser getLoggedInUser;
  final UserRepositoryImpl userRepositoryImpl = UserRepositoryImpl();

  User? _currentUser;

  AuthController({
    required this.registerUser,
    required this.loginUser,
    required this.logoutUser,
    required this.getLoggedInUser,
  });

  User? get currentUser => _currentUser;

  Future<bool> login(String username, String password) async {
    final user = await loginUser(username, password);
    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String password) async {
    final success = await registerUser(User(username: username, password: password));
    if (success) {
      return await login(username, password);
    }
    return false;
  }

  Future<void> logout() async {
    await logoutUser();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> checkLoggedInUser() async {
  final user = await getLoggedInUser();
  _currentUser = user;
  notifyListeners();
}

  Future<List<User>> getAllUsers() async {
    return await userRepositoryImpl.getAllUsers();
  }
}
