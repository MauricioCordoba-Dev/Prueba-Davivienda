import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:easy_task/features/task/data/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/services/local_storage.dart';
import '../../domain/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<void> register(User user) async {
    final db = await AppDatabase.database;
    await db.insert('users', {
      'username': user.username,
      'passwordHash': user.password,
    });
  }

  @override
  Future<User?> login(String username, String password) async {
    final db = await AppDatabase.database;
    final result = await db.query('users', where: 'username = ?', whereArgs: [username]);
    if (result.isNotEmpty) {
      final storedHash = result.first['passwordHash'] as String;
      // Verificar contraseña usando hash SHA256
      final inputHash = sha256.convert(utf8.encode(password)).toString();
      if (storedHash == inputHash) {
        await LocalStorage.saveUsername(username);
        return User(username: username, password: '');
      }
    }
    return null;
  }

  @override
  Future<User?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('loggedInUsername');
    if (username != null) {
      return User(username: username, password: '');
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await LocalStorage.clearUsername();
  }
}