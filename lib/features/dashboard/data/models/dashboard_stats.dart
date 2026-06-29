import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_stats.freezed.dart';
part 'dashboard_stats.g.dart';

@freezed
class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    @Default(0) int totalInjuries,
    @Default(SeverityBreakdown()) SeverityBreakdown severityBreakdown,
    @Default([]) List<TopMuscleGroup> topMuscleGroups,
    @Default(0) int activeChallenges,
    @Default(0) int unreadNotifications,
    @Default(0) int activeProtocols,
    @Default([]) List<ActivityHistory> activityHistory,
    @Default(0) int activityScore,
  }) = _DashboardStats;

  factory DashboardStats.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsFromJson(json);
}

@freezed
class SeverityBreakdown with _$SeverityBreakdown {
  const factory SeverityBreakdown({
    @Default(0) int mild,
    @Default(0) int moderate,
    @Default(0) int severe,
  }) = _SeverityBreakdown;

  factory SeverityBreakdown.fromJson(Map<String, dynamic> json) =>
      _$SeverityBreakdownFromJson(json);
}

@freezed
class TopMuscleGroup with _$TopMuscleGroup {
  const factory TopMuscleGroup({
    @Default('') String name,
    @Default(0) int count,
  }) = _TopMuscleGroup;

  factory TopMuscleGroup.fromJson(Map<String, dynamic> json) =>
      _$TopMuscleGroupFromJson(json);
}

@freezed
class ActivityHistory with _$ActivityHistory {
  const factory ActivityHistory({
    @Default('') String day,
    @Default(0) int assigned,
    @Default(0) int completed,
  }) = _ActivityHistory;

  factory ActivityHistory.fromJson(Map<String, dynamic> json) =>
      _$ActivityHistoryFromJson(json);
}
