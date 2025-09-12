import 'package:easy_task/features/task/data/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../../domain/entities/user.dart';
import 'package:easy_task/core/database/app_database.dart';

class UserRepositoryImpl implements UserRepository {
  static const String _usersKey = 'users';
  static const String _loggedInKey = 'loggedInUser';

  @override
  Future<User?> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_usersKey) ?? [];

    final hashedPassword = sha256.convert(utf8.encode(password)).toString();

    for (final json in usersJson) {
      final data = jsonDecode(json);
      if (data['username'] == username && data['password'] == hashedPassword) {
        await prefs.setString(_loggedInKey, json);
        return User(username: username, password: hashedPassword);
      }
    }

    return null;
  }

  @override
  Future<bool> register(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_usersKey) ?? [];

    final exists = usersJson.any((json) {
      final data = jsonDecode(json);
      return data['username'] == user.username;
    });

    if (exists) return false;

    final hashedPassword = sha256.convert(utf8.encode(user.password)).toString();

    final newUser = {
      'username': user.username,
      'password': hashedPassword,
    };

    usersJson.add(jsonEncode(newUser));
    await prefs.setStringList(_usersKey, usersJson);
    return true;
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInKey);
  }

  @override
  Future<User?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_loggedInKey);
    if (userJson != null) {
      final data = jsonDecode(userJson);
      return User(
        username: data['username'],
        password: data['password'],
      );
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    try {
      if (identical(0, 0.0)) { // hack para detectar web vs nativo
        // Para web, usar SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final usersJson = prefs.getStringList(_usersKey) ?? [];
        return usersJson.map((json) {
          final data = jsonDecode(json);
          return User(username: data['username'], password: data['password']);
        }).toList();
      } else {
        // Para móvil y desktop, usar SQLite
        final db = await AppDatabase.database;
        final result = await db.query('users');
        return result.map((e) => User(
          username: e['username']?.toString() ?? '',
          password: e['passwordHash']?.toString() ?? '',
        )).toList();
      }
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }
}
