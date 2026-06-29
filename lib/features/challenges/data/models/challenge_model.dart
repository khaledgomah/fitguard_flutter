
class ChallengeModel {
  final String id;
  final String sport;
  final String difficulty;
  final String status;
  final List<ChallengeDay> generatedPlan;
  final DateTime startDate;

  ChallengeModel({
    required this.id,
    required this.sport,
    required this.difficulty,
    required this.status,
    required this.generatedPlan,
    required this.startDate,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      id: json['_id'] ?? '',
      sport: json['sport'] ?? '',
      difficulty: json['difficulty'] ?? '',
      status: json['status'] ?? 'active',
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : DateTime.now(),
      generatedPlan: (json['generatedPlan'] as List<dynamic>?)
              ?.map((e) => ChallengeDay.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
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
      day: json['day'] ?? 1,
      task: json['task'],
      exercises: (json['exercises'] as List<dynamic>?)
              ?.map((e) => Exercise.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      muscleGroups: (json['muscleGroups'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      difficulty: json['difficulty'],
      completed: json['completed'] ?? false,
    );
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
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      sets: json['sets'],
      reps: json['reps'],
      duration: json['duration'],
      completed: json['completed'] ?? false,
    );
  }
}
