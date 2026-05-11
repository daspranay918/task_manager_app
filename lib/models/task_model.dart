class TaskModel {
  String id;
  String title;
  String description;
  String date;
  bool status;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'status': status,
    };
  }

  factory TaskModel.fromMap(String id, Map<String, dynamic> map) {
    return TaskModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] ?? '',
      status: map['status'] ?? false,
    );
  }
}
