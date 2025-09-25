// Model only; no Flutter-specific imports needed

/// TodoItem data model per PRD
class TodoItem {
  final String id;
  final String title;
  final String? navigationRoute;
  final int points;
  bool isCompleted;

  TodoItem({
    required this.id,
    required this.title,
    this.navigationRoute,
    this.points = 100,
    this.isCompleted = false,
  });

  TodoItem copyWith({
    String? id,
    String? title,
    String? navigationRoute,
    int? points,
    bool? isCompleted,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      navigationRoute: navigationRoute ?? this.navigationRoute,
      points: points ?? this.points,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'navigationRoute': navigationRoute,
      'points': points,
      'isCompleted': isCompleted,
    };
  }

  static TodoItem fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'] as String,
      title: json['title'] as String,
      navigationRoute: json['navigationRoute'] as String?,
      points: (json['points'] as int?) ?? 100,
      isCompleted: (json['isCompleted'] as bool?) ?? false,
    );
  }
}
