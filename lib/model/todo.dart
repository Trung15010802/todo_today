class Todo {
  final int? id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime date;
  Todo({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] != null ? map['id'] as int : null,
      title: map['title'] as String,
      description: map['description'] as String,
      isCompleted: map['isCompleted'] == 1,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  Todo copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? date,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
    );
  }
}
