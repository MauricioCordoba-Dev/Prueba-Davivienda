import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:easy_task/features/task/data/repositories/auth_repository.dart';
import 'package:easy_task/features/task/data/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/services/local_storage.dart';
import '../../domain/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository, UserRepository {
  @override
  Future<bool> register(User user) async {
    try {
      if (kIsWeb) {
        // Para web, usar solo SharedPreferences
        return await _registerWithSharedPreferences(user);
      } else {
        // Para móvil y desktop, usar SQLite
        final db = await AppDatabase.database;
        final passwordHash = sha256.convert(utf8.encode(user.password)).toString();
        
        await db.insert('users', {
          'username': user.username,
          'passwordHash': passwordHash,
        });
        return true;
      }
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  Future<bool> _registerWithSharedPreferences(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final users = prefs.getStringList('users') ?? [];
      final passwordHash = sha256.convert(utf8.encode(user.password)).toString();
      
      // Verificar si el usuario ya existe
      for (String userData in users) {
        final userMap = json.decode(userData);
        if (userMap['username'] == user.username) {
          return false; // Usuario ya existe
        }
      }
      
      // Agregar nuevo usuario
      final newUser = {
        'username': user.username,
        'passwordHash': passwordHash,
      };
      users.add(json.encode(newUser));
      await prefs.setStringList('users', users);
      return true;
    } catch (e) {
      print('Error registering with shared preferences: $e');
      return false;
    }
  }

  @override
  Future<User?> login(String username, String password) async {
    try {
      if (kIsWeb) {
        // Para web, usar solo SharedPreferences
        return await _loginWithSharedPreferences(username, password);
      } else {
        // Para móvil y desktop, usar SQLite
        final db = await AppDatabase.database;
        final result = await db.query(
          'users', 
          where: 'username = ?', 
          whereArgs: [username]
        );
        
        if (result.isNotEmpty) {
          final storedHash = result.first['passwordHash'] as String;
          final inputHash = sha256.convert(utf8.encode(password)).toString();
          
          if (storedHash == inputHash) {
            await LocalStorage.saveUsername(username);
            return User(username: username, password: '');
          }
        }
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  Future<User?> _loginWithSharedPreferences(String username, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final users = prefs.getStringList('users') ?? [];
      final inputHash = sha256.convert(utf8.encode(password)).toString();
      
      for (String userData in users) {
        final userMap = json.decode(userData);
        if (userMap['username'] == username && userMap['passwordHash'] == inputHash) {
          await LocalStorage.saveUsername(username);
          return User(username: username, password: '');
        }
      }
      return null;
    } catch (e) {
      print('Error logging in with shared preferences: $e');
      return null;
    }
  }

  @override
  Future<User?> getLoggedInUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('loggedInUsername');
      if (username != null) {
        return User(username: username, password: '');
      }
      return null;
    } catch (e) {
      print('Error getting logged in user: $e');
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await LocalStorage.clearUsername();
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}