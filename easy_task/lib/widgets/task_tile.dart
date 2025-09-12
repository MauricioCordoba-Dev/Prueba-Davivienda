import 'package:flutter/material.dart';
import '../features/task/domain/entities/task.dart';

/// Widget que representa una tarea individual en la lista
class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration:
                task.isCompleted ? TextDecoration.lineThrough : null, // Tachar texto si está completado
            color: task.isCompleted ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Text(task.description),
        trailing: Wrap(
          spacing: 8,
          children: [
            // Botón para marcar/desmarcar como completado
            IconButton(
              icon: Icon(task.isCompleted
                  ? Icons.check_box
                  : Icons.check_box_outline_blank),
              onPressed: onToggle,
            ),
            // Botón para editar tarea
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            // Botón para eliminar tarea
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
