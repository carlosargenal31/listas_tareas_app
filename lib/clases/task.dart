class Task {
  final String title;
  final String description;
  final bool completed;

  Task({
    required this.title,
    required this.description,
    required this.completed,
  });

  Task copyWith({
    String? title,
    String? description,
    bool? completed,
  }) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}
