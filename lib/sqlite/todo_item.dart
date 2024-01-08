class TodoItemData {
  final int id;
  final String title;
  final int status;
  const TodoItemData(
      {required this.id, required this.title, required this.status});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      "title": title,
      "status": status,
    };
  }

  @override
  String toString() {
    return 'TodoItem{id: $id, title: $title, status: $status}';
  }
}
