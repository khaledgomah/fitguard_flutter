class DailyTask {
  const DailyTask({
    required this.id,
    required this.day,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.isCompleted,
    this.videoUrl,
  });

  final String id;
  final int day;
  final String title;
  final String description;
  final int durationMinutes;
  final bool isCompleted;
  final String? videoUrl;

  DailyTask copyWith({
    String? id,
    int? day,
    String? title,
    String? description,
    int? durationMinutes,
    bool? isCompleted,
    String? videoUrl,
  }) {
    return DailyTask(
      id: id ?? this.id,
      day: day ?? this.day,
      title: title ?? this.title,
      description: description ?? this.description,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      videoUrl: videoUrl ?? this.videoUrl,
    );
  }
}
