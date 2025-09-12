import 'package:easy_task/features/task/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/task/data/repositories/task_repository_impl.dart';
import 'features/task/domain/usecases/add_task.dart';
import 'features/task/domain/usecases/update_task.dart';
import 'features/task/domain/usecases/delete_task.dart';
import 'features/task/domain/usecases/delete_task_by_user.dart';
import 'features/task/domain/usecases/get_tasks.dart';
import 'features/task/domain/usecases/get_tasks_by_user.dart';
import 'features/task/domain/usecases/toggle_task_status.dart';
import 'features/task/domain/usecases/toggle_task_status_by_user.dart';
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

/// Punto de entrada de la aplicación
void main() {
  final taskRepository = TaskRepositoryImpl();
  final authRepository = AuthRepositoryImpl();

  runApp(
    MultiProvider(
      providers: [
        // Proveedor para el controlador de autenticación
        ChangeNotifierProvider(
          create: (_) => AuthController(
            registerUser: RegisterUser(authRepository as UserRepository),
            loginUser: LoginUser(authRepository),
            logoutUser: LogoutUser(authRepository),
            getLoggedInUser: GetLoggedInUser(authRepository),
          ),
        ),
        // Proveedor para el controlador de tareas
        ChangeNotifierProvider(
          create: (_) => TaskController(
            addTaskUseCase: AddTask(taskRepository),
            updateTaskUseCase: UpdateTask(taskRepository),
            deleteTaskUseCase: DeleteTask(taskRepository),
            deleteTaskByUserUseCase: DeleteTaskByUser(taskRepository),
            getTasksUseCase: GetTasks(taskRepository),
            getTasksByUserUseCase: GetTasksByUser(taskRepository),
            toggleTaskStatusUseCase: ToggleTaskStatus(taskRepository),
            toggleTaskStatusByUserUseCase: ToggleTaskStatusByUser(taskRepository),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

/// Widget principal de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(), // Pantalla de carga inicial
        '/login': (_) => LoginScreen(), // Pantalla de inicio de sesión
        '/admin': (_) => const AdminHomeScreen(), // Pantalla principal de tareas
      },
    );
  }
}
