import '../../domain/entities/challenge.dart';
import 'daily_task_model.dart';

class ChallengeModel extends Challenge {
  const ChallengeModel({
    required super.id,
    required super.title,
    required super.description,
    required super.type,
    required super.difficulty,
    required super.durationDays,
    required super.currentDay,
    required super.isCompleted,
    required super.dailyTasks,
    super.startDate,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    var tasksFromJson = json['dailyTasks'] as List? ?? [];
    List<DailyTaskModel> tasksList = tasksFromJson
        .map((task) => DailyTaskModel.fromJson(Map<String, dynamic>.from(task)))
        .toList();

    return ChallengeModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      difficulty: (json['difficulty'] ?? '').toString(),
      durationDays: _toInt(json['durationDays'] ?? 30),
      currentDay: _toInt(json['currentDay'] ?? 1),
      isCompleted: json['isCompleted'] == true,
      dailyTasks: tasksList,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'difficulty': difficulty,
      'durationDays': durationDays,
      'currentDay': currentDay,
      'isCompleted': isCompleted,
      'dailyTasks': dailyTasks
          .map((task) => (task is DailyTaskModel)
              ? task.toJson()
              : DailyTaskModel(
                  id: task.id,
                  day: task.day,
                  title: task.title,
                  description: task.description,
                  durationMinutes: task.durationMinutes,
                  isCompleted: task.isCompleted,
                  videoUrl: task.videoUrl,
                ).toJson())
          .toList(),
      'startDate': startDate?.toIso8601String(),
    };
  }

  static int _toInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
