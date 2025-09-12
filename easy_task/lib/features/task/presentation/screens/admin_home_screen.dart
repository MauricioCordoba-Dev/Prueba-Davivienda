import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/task_controller.dart';
import '../controllers/auth_controller.dart';
import '../../domain/entities/task.dart';
import '../../../../widgets/task_tile.dart';
import '../../../../widgets/edit_task_dialog.dart';
import 'package:uuid/uuid.dart';

/// Pantalla principal donde se gestionan las tareas
class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  late TaskController controller;
  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = Provider.of<TaskController>(context, listen: false);
    final authController = Provider.of<AuthController>(context, listen: false);
    
    // Cargar tareas del usuario actual al inicializar la pantalla
    if (authController.currentUser != null) {
      controller.loadTasksByUser(authController.currentUser!.username);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body: Consumer2<TaskController, AuthController>(
        builder: (context, taskController, authController, _) {
          return ListView(
            children: taskController.tasks
                .map(
                  (task) => TaskTile(
                    task: task,
                    onToggle: () => taskController.toggleStatusByUser(
                      task.id, 
                      authController.currentUser?.username ?? ''
                    ),
                    onEdit: () => _showEditDialog(context, task),
                    onDelete: () => taskController.deleteTaskByUser(
                      task.id, 
                      authController.currentUser?.username ?? ''
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
      floatingActionButton: Consumer2<TaskController, AuthController>(
        builder: (context, taskController, authController, _) {
          return FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Agregar Tareas'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Titulo de la tarea.'),
                      ),
                      TextField(
                        controller: descController,
                        decoration: const InputDecoration(labelText: 'Descripción'),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        final currentUser = authController.currentUser;
                        
                        if (currentUser != null) {
                          // Crear nueva tarea con ID único y userId
                          final task = Task(
                            id: const Uuid().v4(),
                            title: titleController.text,
                            description: descController.text,
                            userId: currentUser.username,
                          );
                          await taskController.addTask(task);
                          titleController.clear();
                          descController.clear();
                          // ignore: use_build_context_synchronously
                          if (mounted) Navigator.pop(context);
                        }
                      },
                      child: const Text('Agregar'),
                    ),
                  ],
                ),
              );
            },
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }

  /// Muestra el diálogo para editar una tarea
  void _showEditDialog(BuildContext context, Task task) {
    final taskController = Provider.of<TaskController>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => EditTaskDialog(
        task: task,
        onSave: (updatedTask) async {
          await taskController.updateTask(updatedTask);
        },
      ),
    );
  }
}
