// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardStatsImpl _$$DashboardStatsImplFromJson(Map<String, dynamic> json) =>
    _$DashboardStatsImpl(
      totalInjuries: (json['totalInjuries'] as num?)?.toInt() ?? 0,
      severityBreakdown: json['severityBreakdown'] == null
          ? const SeverityBreakdown()
          : SeverityBreakdown.fromJson(
              json['severityBreakdown'] as Map<String, dynamic>,
            ),
      topMuscleGroups:
          (json['topMuscleGroups'] as List<dynamic>?)
              ?.map((e) => TopMuscleGroup.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      activeChallenges: (json['activeChallenges'] as num?)?.toInt() ?? 0,
      unreadNotifications: (json['unreadNotifications'] as num?)?.toInt() ?? 0,
      activeProtocols: (json['activeProtocols'] as num?)?.toInt() ?? 0,
      activityHistory:
          (json['activityHistory'] as List<dynamic>?)
              ?.map((e) => ActivityHistory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      activityScore: (json['activityScore'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DashboardStatsImplToJson(
  _$DashboardStatsImpl instance,
) => <String, dynamic>{
  'totalInjuries': instance.totalInjuries,
  'severityBreakdown': instance.severityBreakdown,
  'topMuscleGroups': instance.topMuscleGroups,
  'activeChallenges': instance.activeChallenges,
  'unreadNotifications': instance.unreadNotifications,
  'activeProtocols': instance.activeProtocols,
  'activityHistory': instance.activityHistory,
  'activityScore': instance.activityScore,
};

_$SeverityBreakdownImpl _$$SeverityBreakdownImplFromJson(
  Map<String, dynamic> json,
) => _$SeverityBreakdownImpl(
  mild: (json['mild'] as num?)?.toInt() ?? 0,
  moderate: (json['moderate'] as num?)?.toInt() ?? 0,
  severe: (json['severe'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$SeverityBreakdownImplToJson(
  _$SeverityBreakdownImpl instance,
) => <String, dynamic>{
  'mild': instance.mild,
  'moderate': instance.moderate,
  'severe': instance.severe,
};

_$TopMuscleGroupImpl _$$TopMuscleGroupImplFromJson(Map<String, dynamic> json) =>
    _$TopMuscleGroupImpl(
      name: json['name'] as String? ?? '',
      count: (json['count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TopMuscleGroupImplToJson(
  _$TopMuscleGroupImpl instance,
) => <String, dynamic>{'name': instance.name, 'count': instance.count};

_$ActivityHistoryImpl _$$ActivityHistoryImplFromJson(
  Map<String, dynamic> json,
) => _$ActivityHistoryImpl(
  day: json['day'] as String? ?? '',
  assigned: (json['assigned'] as num?)?.toInt() ?? 0,
  completed: (json['completed'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$ActivityHistoryImplToJson(
  _$ActivityHistoryImpl instance,
) => <String, dynamic>{
  'day': instance.day,
  'assigned': instance.assigned,
  'completed': instance.completed,
};
