import 'package:easy_task/features/task/domain/entities/user.dart';
import 'package:easy_task/features/task/domain/usecases/get_logged_in_user.dart';
import 'package:easy_task/features/task/domain/usecases/login_user.dart';
import 'package:easy_task/features/task/domain/usecases/logout_user.dart';
import 'package:easy_task/features/task/domain/usecases/register_user.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  final RegisterUser registerUser;
  final LoginUser loginUser;
  final LogoutUser logoutUser;
  final GetLoggedInUser getLoggedInUser;

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

  /// Método temporal para obtener todos los usuarios (para mostrar datos guardados)
  Future<List<User>> getAllUsers() async {
    // Este método es temporal y solo para mostrar datos guardados
    // En una implementación real, esto debería venir del repositorio
    return [_currentUser].where((user) => user != null).cast<User>().toList();
  }
}
