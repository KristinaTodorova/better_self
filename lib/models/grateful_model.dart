class GratitudeItem {
  final String text;
  final DateTime date;

  GratitudeItem({required this.text, required this.date});

  Map<String, dynamic> toJson() => {
        'text': text,
        'date': date.toIso8601String(),
      };

  factory GratitudeItem.fromJson(Map<String, dynamic> json) {
    return GratitudeItem(
      text: json['text'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }
}