import 'package:flutter/material.dart';
import '../features/task/domain/entities/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
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
                task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Text(task.description),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              icon: Icon(task.isCompleted
                  ? Icons.check_box
                  : Icons.check_box_outline_blank),
              onPressed: onToggle,
              tooltip: task.isCompleted ? 'Marcar como pendiente' : 'Marcar como completada',
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
              tooltip: 'Editar tarea',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
              tooltip: 'Eliminar tarea',
            ),
          ],
        ),
      ),
    );
  }
}
