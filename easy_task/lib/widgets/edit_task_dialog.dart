import 'package:flutter/material.dart';
import '../features/task/domain/entities/task.dart';

/// Diálogo modal para editar una tarea existente
class EditTaskDialog extends StatefulWidget {
  final Task task;
  final Function(Task) onSave;

  const EditTaskDialog({
    super.key,
    required this.task,
    required this.onSave,
  });

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    // Inicializar controladores con los valores actuales de la tarea
    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(text: widget.task.description);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Tarea'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Título',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descripción',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            // Validar que el título no esté vacío
            if (titleController.text.trim().isNotEmpty) {
              final updatedTask = widget.task.copyWith(
                title: titleController.text.trim(),
                description: descriptionController.text.trim(),
              );
              widget.onSave(updatedTask);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('El título no puede estar vacío'),
                ),
              );
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
