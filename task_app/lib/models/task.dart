class Task {
  final int? id;
  final String title;
  final String description;
  final String priority;
  final String status;
  final int userId;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.priority,
    this.status = 'PENDING',
    required this.userId,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      priority: json['priority'],
      status: json['status'],
      userId: json['user']['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'priority': priority,
      'status': status,
      'user': {'id': userId},
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'description': description,
      'priority': priority,
      'user': {'id': userId},
    };
  }

  Task copyWith({String? status}) {
    return Task(
      id: id,
      title: title,
      description: description,
      priority: priority,
      status: status ?? this.status,
      userId: userId,
    );
  }

  bool get isCompleted => status == 'COMPLETED';
}
