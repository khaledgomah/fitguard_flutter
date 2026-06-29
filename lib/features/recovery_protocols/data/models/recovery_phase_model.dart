import '../../domain/entities/recovery_phase.dart';

class RecoveryPhaseModel extends RecoveryPhase {
  const RecoveryPhaseModel({
    required super.id,
    required super.phaseNumber,
    required super.name,
    required super.description,
    required super.status,
    required super.exercises,
    required super.progressPercentage,
  });

  factory RecoveryPhaseModel.fromJson(Map<String, dynamic> json) {
    var exercisesFromJson = json['exercises'] as List? ?? [];
    List<String> exerciseList = exercisesFromJson.map((e) => e.toString()).toList();

    return RecoveryPhaseModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      phaseNumber: _toInt(json['phaseNumber'] ?? 1),
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      status: (json['status'] ?? 'locked').toString(),
      exercises: exerciseList,
      progressPercentage: _toDouble(json['progressPercentage'] ?? 0.0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phaseNumber': phaseNumber,
      'name': name,
      'description': description,
      'status': status,
      'exercises': exercises,
      'progressPercentage': progressPercentage,
    };
  }

  static int _toInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _toDouble(Object? value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}
