class RecoveryPhase {
  const RecoveryPhase({
    required this.id,
    required this.phaseNumber,
    required this.name,
    required this.description,
    required this.status, // 'locked', 'active', 'completed'
    required this.exercises,
    required this.progressPercentage,
  });

  final String id;
  final int phaseNumber;
  final String name;
  final String description;
  final String status;
  final List<String> exercises;
  final double progressPercentage;

  RecoveryPhase copyWith({
    String? id,
    int? phaseNumber,
    String? name,
    String? description,
    String? status,
    List<String>? exercises,
    double? progressPercentage,
  }) {
    return RecoveryPhase(
      id: id ?? this.id,
      phaseNumber: phaseNumber ?? this.phaseNumber,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      exercises: exercises ?? this.exercises,
      progressPercentage: progressPercentage ?? this.progressPercentage,
    );
  }
}
