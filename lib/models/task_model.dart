class Task {
  String? title;
  String? description;
  bool isCompleted;
  String? priority; // Adicionando prioridade

  Task({this.title, this.description, this.isCompleted = false, this.priority});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'priority': priority, // Incluindo prioridade
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'] ?? false,
      priority: json['priority'], // Incluindo prioridade
    );
  }
}
