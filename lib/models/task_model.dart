class Task {
  final String title;
  bool isChecked;
  final DateTime date;

  Task({required this.title, this.isChecked = false, required this.date});

  Map<String, dynamic> toJson() => {
        'title': title,
        'isChecked': isChecked,
        'date': date.toIso8601String(),
      };

  // Create from JSON when loading from Hive
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'] as String,
      isChecked: json['isChecked'] as bool,
      date: DateTime.parse(json['date'] as String),
    );
  }
}