import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/task_controller.dart';
import '../../domain/entities/task.dart';
import 'package:uuid/uuid.dart';
import 'package:easy_task/features/task/presentation/controllers/auth_controller.dart';
import 'package:easy_task/main.dart';
import '../../../../widgets/task_tile.dart';
import '../widgets/edit_task_dialog.dart';

/// Pantalla principal donde se gestionan las tareas
class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final taskController = Provider.of<TaskController>(context, listen: false);
    taskController.loadTasks(); // Cargar tareas al inicializar la pantalla
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final themeController = Provider.of<ThemeController>(context);
    final taskController = Provider.of<TaskController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Task Manager', style: TextStyle(color: Color(0xFF5B5F62), fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          PopupMenuButton<int>(
            icon: const CircleAvatar(child: Icon(Icons.person)),
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authController.currentUser?.username ?? 'No logueado',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: const [
                    Icon(Icons.storage, size: 20),
                    SizedBox(width: 8),
                    Text('Ver datos guardados'),
                  ],
                ),
              ),
              PopupMenuItem(
                enabled: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Modo oscuro'),
                    Switch(
                      value: themeController.isDark,
                      onChanged: (_) => themeController.toggleTheme(),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: const [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 8),
                    Text('Cerrar sesión'),
                  ],
                ),
              ),
            ],
            onSelected: (value) async {
              if (value == 1) {
                await authController.logout();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              }
              if (value == 2) {
                // Mostrar usuarios y tareas guardadas
                final users = await authController.getAllUsers();
                final tasks = await taskController.getTasksUseCase();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Datos guardados'),
                    content: SizedBox(
                      width: 350,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Usuarios registrados:', style: TextStyle(fontWeight: FontWeight.bold)),
                            ...users.map((u) => Text(u.username)),
                            const SizedBox(height: 16),
                            const Text('Tareas guardadas:', style: TextStyle(fontWeight: FontWeight.bold)),
                            ...tasks.map((t) => Text('- ${t.title}: ${t.description}')),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cerrar'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEDEDED), Color(0xFFBFC4CA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Consumer<TaskController>(
          builder: (context, controller, _) {
            return ListView(
              children: controller.tasks
                  .map(
                    (task) => TaskTile(
                      task: task,
                      onToggle: () => controller.toggleStatus(task.id),
                      onEdit: () => _showEditDialog(context, task),
                      onDelete: () => controller.deleteTask(task.id),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF5B5F62),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text('Agregar Tarea', style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título de la tarea',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.title),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    // Crear nueva tarea con ID único
                    final task = Task(
                      id: const Uuid().v4(),
                      title: titleController.text,
                      description: descController.text,
                    );
                    await taskController.addTask(task);
                    titleController.clear();
                    descController.clear();
                    if (mounted) Navigator.pop(context);
                  },
                  child: const Text('Agregar'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Muestra el diálogo para editar una tarea
  void _showEditDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => EditTaskDialog(
        task: task,
        onSave: (updatedTask) async {
          final taskController = Provider.of<TaskController>(context, listen: false);
          await taskController.updateTask(updatedTask);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tarea actualizada correctamente'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
      ),
    );
  }
}