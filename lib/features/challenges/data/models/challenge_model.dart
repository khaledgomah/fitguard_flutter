import '../../domain/entities/challenge.dart';
import '../../domain/entities/daily_task.dart';
import 'daily_task_model.dart';

class ChallengeModel extends Challenge {
  final String sport;
  final String status;
  final List<ChallengeDay> generatedPlan;

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
    this.sport = '',
    this.status = 'active',
    this.generatedPlan = const [],
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? json['_id'] ?? '').toString();
    final sport = (json['sport'] ?? '').toString();
    final difficulty = (json['difficulty'] ?? '').toString();
    final status = (json['status'] ?? 'active').toString();
    final startDate = json['startDate'] != null
        ? DateTime.tryParse(json['startDate'].toString()) ?? DateTime.now()
        : DateTime.now();

    final generatedPlan =
        (json['generatedPlan'] as List<dynamic>?)
            ?.map((e) => ChallengeDay.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    // Map generatedPlan to dailyTasks for backward compatibility
    final dailyTasks = generatedPlan.map((day) {
      final title = day.task ?? 'Day ${day.day} Workout';
      final exercisesDesc = day.exercises
          .map((e) => '- ${e.name} (${e.sets}x${e.reps ?? e.duration ?? ""})')
          .join('\n');
      return DailyTaskModel(
        id: '${id}_day_${day.day}',
        day: day.day,
        title: title,
        description: exercisesDesc.isNotEmpty ? exercisesDesc : 'Rest Day',
        durationMinutes: 30,
        isCompleted: day.completed,
      );
    }).toList();

    int currentDay = 1;
    if (generatedPlan.isNotEmpty) {
      final firstUncompleted = generatedPlan.firstWhere(
        (day) => !day.completed,
        orElse: () => generatedPlan.last,
      );
      currentDay = firstUncompleted.day;
    }

    return ChallengeModel(
      id: id,
      title: '${sport.toUpperCase()} Challenge',
      description: 'A 30-day $difficulty challenge for $sport.',
      type: sport,
      difficulty: difficulty,
      durationDays: generatedPlan.isNotEmpty ? generatedPlan.length : 30,
      currentDay: currentDay,
      isCompleted: status == 'completed',
      dailyTasks: dailyTasks,
      startDate: startDate,
      sport: sport,
      status: status,
      generatedPlan: generatedPlan,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sport': sport,
      'difficulty': difficulty,
      'status': status,
      'startDate': startDate?.toIso8601String(),
      'generatedPlan': generatedPlan.map((day) => day.toJson()).toList(),
    };
  }

  @override
  ChallengeModel copyWith({
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
    String? sport,
    String? status,
    List<ChallengeDay>? generatedPlan,
  }) {
    return ChallengeModel(
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
      sport: sport ?? this.sport,
      status: status ?? this.status,
      generatedPlan: generatedPlan ?? this.generatedPlan,
    );
  }
}

class ChallengeDay {
  final int day;
  final String? task;
  final List<Exercise> exercises;
  final List<String> muscleGroups;
  final String? difficulty;
  final bool completed;

  ChallengeDay({
    required this.day,
    this.task,
    required this.exercises,
    required this.muscleGroups,
    this.difficulty,
    required this.completed,
  });

  factory ChallengeDay.fromJson(Map<String, dynamic> json) {
    return ChallengeDay(
      day: _toInt(json['day'] ?? 1),
      task: json['task']?.toString(),
      exercises:
          (json['exercises'] as List<dynamic>?)
              ?.map((e) => Exercise.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      muscleGroups:
          (json['muscleGroups'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      difficulty: json['difficulty']?.toString(),
      completed: json['completed'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'task': task,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'muscleGroups': muscleGroups,
      'difficulty': difficulty,
      'completed': completed,
    };
  }

  static int _toInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 1;
  }
}

class Exercise {
  final String id;
  final String name;
  final int? sets;
  final int? reps;
  final String? duration;
  final bool completed;

  Exercise({
    required this.id,
    required this.name,
    this.sets,
    this.reps,
    this.duration,
    required this.completed,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? json['title'] ?? '').toString(),
      sets: json['sets'] != null ? _toInt(json['sets']) : null,
      reps: json['reps'] != null ? _toInt(json['reps']) : null,
      duration: json['duration']?.toString(),
      completed: json['completed'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sets': sets,
      'reps': reps,
      'duration': duration,
      'completed': completed,
    };
  }

  static int _toInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
