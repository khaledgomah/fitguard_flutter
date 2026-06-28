import 'daily_task.dart';

class Challenge {
  const Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.durationDays,
    required this.currentDay,
    required this.isCompleted,
    required this.dailyTasks,
    this.startDate,
  });

  final String id;
  final String title;
  final String description;
  final String type; // e.g. 'mobility', 'strength', 'injury_prevention'
  final String difficulty; // e.g. 'beginner', 'intermediate', 'advanced'
  final int durationDays;
  final int currentDay;
  final bool isCompleted;
  final List<DailyTask> dailyTasks;
  final DateTime? startDate;

  Challenge copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? difficulty,
    int? durationDays,
    int? currentDay,
    bool? isCompleted,
    List<DailyTask>? dailyTasks,
    DateTime? startDate,
  }) {
    return Challenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      durationDays: durationDays ?? this.durationDays,
      currentDay: currentDay ?? this.currentDay,
      isCompleted: isCompleted ?? this.isCompleted,
      dailyTasks: dailyTasks ?? this.dailyTasks,
      startDate: startDate ?? this.startDate,
    );
  }

  double get progressPercentage {
    if (dailyTasks.isEmpty) return 0.0;
    final completedCount = dailyTasks.where((task) => task.isCompleted).length;
    return completedCount / dailyTasks.length;
  }
}
