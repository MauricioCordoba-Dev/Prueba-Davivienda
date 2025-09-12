import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/task/data/repositories/task_repository_impl.dart';
import 'features/task/domain/usecases/add_task.dart';
import 'features/task/domain/usecases/update_task.dart';
import 'features/task/domain/usecases/delete_task.dart';
import 'features/task/domain/usecases/get_tasks.dart';
import 'features/task/domain/usecases/toggle_task_status.dart';
import 'features/task/presentation/controllers/task_controller.dart';
import 'features/task/presentation/screens/admin_home_screen.dart';
import 'features/task/presentation/screens/splash_screen.dart';
import 'features/task/data/repositories/auth_repository_impl.dart';
import 'features/task/domain/usecases/register_user.dart';
import 'features/task/domain/usecases/login_user.dart';
import 'features/task/domain/usecases/logout_user.dart';
import 'features/task/domain/usecases/get_logged_in_user.dart';
import 'features/task/presentation/controllers/auth_controller.dart';
import 'features/task/presentation/screens/login_screen.dart';

class ThemeController extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}

void main() {
  final taskRepository = TaskRepositoryImpl();
  final authRepository = AuthRepositoryImpl();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthController(
            registerUser: RegisterUser(authRepository),
            loginUser: LoginUser(authRepository),
            logoutUser: LogoutUser(authRepository),
            getLoggedInUser: GetLoggedInUser(authRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => TaskController(
            addTaskUseCase: AddTask(taskRepository),
            updateTaskUseCase: UpdateTask(taskRepository),
            deleteTaskUseCase: DeleteTask(taskRepository),
            getTasksUseCase: GetTasks(taskRepository),
            toggleTaskStatusUseCase: ToggleTaskStatus(taskRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeController(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.isDark ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => LoginScreen(),
        '/admin': (_) => const AdminHomeScreen(),
      },
    );
  }
}

