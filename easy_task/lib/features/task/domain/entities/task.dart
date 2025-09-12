/// Entidad que representa una tarea en el sistema
class Task {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final String userId; // Usuario propietario de la tarea

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    this.isCompleted = false,
  });

  /// Crea una copia de la tarea con los campos especificados modificados
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    String? userId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
    );
  }
}
