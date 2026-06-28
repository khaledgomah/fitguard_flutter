import '../../domain/entities/daily_task.dart';

class DailyTaskModel extends DailyTask {
  const DailyTaskModel({
    required super.id,
    required super.day,
    required super.title,
    required super.description,
    required super.durationMinutes,
    required super.isCompleted,
    super.videoUrl,
  });

  factory DailyTaskModel.fromJson(Map<String, dynamic> json) {
    return DailyTaskModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      day: _toInt(json['day']),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      durationMinutes: _toInt(json['durationMinutes'] ?? json['duration']),
      isCompleted: json['isCompleted'] == true,
      videoUrl: json['videoUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'title': title,
      'description': description,
      'durationMinutes': durationMinutes,
      'isCompleted': isCompleted,
      'videoUrl': videoUrl,
    };
  }

  static int _toInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
