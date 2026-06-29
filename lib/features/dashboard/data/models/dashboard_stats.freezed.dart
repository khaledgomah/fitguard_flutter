// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) {
  return _DashboardStats.fromJson(json);
}

/// @nodoc
mixin _$DashboardStats {
  int get totalInjuries => throw _privateConstructorUsedError;
  SeverityBreakdown get severityBreakdown => throw _privateConstructorUsedError;
  List<TopMuscleGroup> get topMuscleGroups =>
      throw _privateConstructorUsedError;
  int get activeChallenges => throw _privateConstructorUsedError;
  int get unreadNotifications => throw _privateConstructorUsedError;
  int get activeProtocols => throw _privateConstructorUsedError;
  List<ActivityHistory> get activityHistory =>
      throw _privateConstructorUsedError;
  int get activityScore => throw _privateConstructorUsedError;

  /// Serializes this DashboardStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardStatsCopyWith<DashboardStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStatsCopyWith<$Res> {
  factory $DashboardStatsCopyWith(
    DashboardStats value,
    $Res Function(DashboardStats) then,
  ) = _$DashboardStatsCopyWithImpl<$Res, DashboardStats>;
  @useResult
  $Res call({
    int totalInjuries,
    SeverityBreakdown severityBreakdown,
    List<TopMuscleGroup> topMuscleGroups,
    int activeChallenges,
    int unreadNotifications,
    int activeProtocols,
    List<ActivityHistory> activityHistory,
    int activityScore,
  });

  $SeverityBreakdownCopyWith<$Res> get severityBreakdown;
}

/// @nodoc
class _$DashboardStatsCopyWithImpl<$Res, $Val extends DashboardStats>
    implements $DashboardStatsCopyWith<$Res> {
  _$DashboardStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalInjuries = null,
    Object? severityBreakdown = null,
    Object? topMuscleGroups = null,
    Object? activeChallenges = null,
    Object? unreadNotifications = null,
    Object? activeProtocols = null,
    Object? activityHistory = null,
    Object? activityScore = null,
  }) {
    return _then(
      _value.copyWith(
            totalInjuries: null == totalInjuries
                ? _value.totalInjuries
                : totalInjuries // ignore: cast_nullable_to_non_nullable
                      as int,
            severityBreakdown: null == severityBreakdown
                ? _value.severityBreakdown
                : severityBreakdown // ignore: cast_nullable_to_non_nullable
                      as SeverityBreakdown,
            topMuscleGroups: null == topMuscleGroups
                ? _value.topMuscleGroups
                : topMuscleGroups // ignore: cast_nullable_to_non_nullable
                      as List<TopMuscleGroup>,
            activeChallenges: null == activeChallenges
                ? _value.activeChallenges
                : activeChallenges // ignore: cast_nullable_to_non_nullable
                      as int,
            unreadNotifications: null == unreadNotifications
                ? _value.unreadNotifications
                : unreadNotifications // ignore: cast_nullable_to_non_nullable
                      as int,
            activeProtocols: null == activeProtocols
                ? _value.activeProtocols
                : activeProtocols // ignore: cast_nullable_to_non_nullable
                      as int,
            activityHistory: null == activityHistory
                ? _value.activityHistory
                : activityHistory // ignore: cast_nullable_to_non_nullable
                      as List<ActivityHistory>,
            activityScore: null == activityScore
                ? _value.activityScore
                : activityScore // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SeverityBreakdownCopyWith<$Res> get severityBreakdown {
    return $SeverityBreakdownCopyWith<$Res>(_value.severityBreakdown, (value) {
      return _then(_value.copyWith(severityBreakdown: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DashboardStatsImplCopyWith<$Res>
    implements $DashboardStatsCopyWith<$Res> {
  factory _$$DashboardStatsImplCopyWith(
    _$DashboardStatsImpl value,
    $Res Function(_$DashboardStatsImpl) then,
  ) = __$$DashboardStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalInjuries,
    SeverityBreakdown severityBreakdown,
    List<TopMuscleGroup> topMuscleGroups,
    int activeChallenges,
    int unreadNotifications,
    int activeProtocols,
    List<ActivityHistory> activityHistory,
    int activityScore,
  });

  @override
  $SeverityBreakdownCopyWith<$Res> get severityBreakdown;
}

/// @nodoc
class __$$DashboardStatsImplCopyWithImpl<$Res>
    extends _$DashboardStatsCopyWithImpl<$Res, _$DashboardStatsImpl>
    implements _$$DashboardStatsImplCopyWith<$Res> {
  __$$DashboardStatsImplCopyWithImpl(
    _$DashboardStatsImpl _value,
    $Res Function(_$DashboardStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalInjuries = null,
    Object? severityBreakdown = null,
    Object? topMuscleGroups = null,
    Object? activeChallenges = null,
    Object? unreadNotifications = null,
    Object? activeProtocols = null,
    Object? activityHistory = null,
    Object? activityScore = null,
  }) {
    return _then(
      _$DashboardStatsImpl(
        totalInjuries: null == totalInjuries
            ? _value.totalInjuries
            : totalInjuries // ignore: cast_nullable_to_non_nullable
                  as int,
        severityBreakdown: null == severityBreakdown
            ? _value.severityBreakdown
            : severityBreakdown // ignore: cast_nullable_to_non_nullable
                  as SeverityBreakdown,
        topMuscleGroups: null == topMuscleGroups
            ? _value._topMuscleGroups
            : topMuscleGroups // ignore: cast_nullable_to_non_nullable
                  as List<TopMuscleGroup>,
        activeChallenges: null == activeChallenges
            ? _value.activeChallenges
            : activeChallenges // ignore: cast_nullable_to_non_nullable
                  as int,
        unreadNotifications: null == unreadNotifications
            ? _value.unreadNotifications
            : unreadNotifications // ignore: cast_nullable_to_non_nullable
                  as int,
        activeProtocols: null == activeProtocols
            ? _value.activeProtocols
            : activeProtocols // ignore: cast_nullable_to_non_nullable
                  as int,
        activityHistory: null == activityHistory
            ? _value._activityHistory
            : activityHistory // ignore: cast_nullable_to_non_nullable
                  as List<ActivityHistory>,
        activityScore: null == activityScore
            ? _value.activityScore
            : activityScore // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardStatsImpl implements _DashboardStats {
  const _$DashboardStatsImpl({
    this.totalInjuries = 0,
    this.severityBreakdown = const SeverityBreakdown(),
    final List<TopMuscleGroup> topMuscleGroups = const [],
    this.activeChallenges = 0,
    this.unreadNotifications = 0,
    this.activeProtocols = 0,
    final List<ActivityHistory> activityHistory = const [],
    this.activityScore = 0,
  }) : _topMuscleGroups = topMuscleGroups,
       _activityHistory = activityHistory;

  factory _$DashboardStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardStatsImplFromJson(json);

  @override
  @JsonKey()
  final int totalInjuries;
  @override
  @JsonKey()
  final SeverityBreakdown severityBreakdown;
  final List<TopMuscleGroup> _topMuscleGroups;
  @override
  @JsonKey()
  List<TopMuscleGroup> get topMuscleGroups {
    if (_topMuscleGroups is EqualUnmodifiableListView) return _topMuscleGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topMuscleGroups);
  }

  @override
  @JsonKey()
  final int activeChallenges;
  @override
  @JsonKey()
  final int unreadNotifications;
  @override
  @JsonKey()
  final int activeProtocols;
  final List<ActivityHistory> _activityHistory;
  @override
  @JsonKey()
  List<ActivityHistory> get activityHistory {
    if (_activityHistory is EqualUnmodifiableListView) return _activityHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activityHistory);
  }

  @override
  @JsonKey()
  final int activityScore;

  @override
  String toString() {
    return 'DashboardStats(totalInjuries: $totalInjuries, severityBreakdown: $severityBreakdown, topMuscleGroups: $topMuscleGroups, activeChallenges: $activeChallenges, unreadNotifications: $unreadNotifications, activeProtocols: $activeProtocols, activityHistory: $activityHistory, activityScore: $activityScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStatsImpl &&
            (identical(other.totalInjuries, totalInjuries) ||
                other.totalInjuries == totalInjuries) &&
            (identical(other.severityBreakdown, severityBreakdown) ||
                other.severityBreakdown == severityBreakdown) &&
            const DeepCollectionEquality().equals(
              other._topMuscleGroups,
              _topMuscleGroups,
            ) &&
            (identical(other.activeChallenges, activeChallenges) ||
                other.activeChallenges == activeChallenges) &&
            (identical(other.unreadNotifications, unreadNotifications) ||
                other.unreadNotifications == unreadNotifications) &&
            (identical(other.activeProtocols, activeProtocols) ||
                other.activeProtocols == activeProtocols) &&
            const DeepCollectionEquality().equals(
              other._activityHistory,
              _activityHistory,
            ) &&
            (identical(other.activityScore, activityScore) ||
                other.activityScore == activityScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalInjuries,
    severityBreakdown,
    const DeepCollectionEquality().hash(_topMuscleGroups),
    activeChallenges,
    unreadNotifications,
    activeProtocols,
    const DeepCollectionEquality().hash(_activityHistory),
    activityScore,
  );

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStatsImplCopyWith<_$DashboardStatsImpl> get copyWith =>
      __$$DashboardStatsImplCopyWithImpl<_$DashboardStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardStatsImplToJson(this);
  }
}

abstract class _DashboardStats implements DashboardStats {
  const factory _DashboardStats({
    final int totalInjuries,
    final SeverityBreakdown severityBreakdown,
    final List<TopMuscleGroup> topMuscleGroups,
    final int activeChallenges,
    final int unreadNotifications,
    final int activeProtocols,
    final List<ActivityHistory> activityHistory,
    final int activityScore,
  }) = _$DashboardStatsImpl;

  factory _DashboardStats.fromJson(Map<String, dynamic> json) =
      _$DashboardStatsImpl.fromJson;

  @override
  int get totalInjuries;
  @override
  SeverityBreakdown get severityBreakdown;
  @override
  List<TopMuscleGroup> get topMuscleGroups;
  @override
  int get activeChallenges;
  @override
  int get unreadNotifications;
  @override
  int get activeProtocols;
  @override
  List<ActivityHistory> get activityHistory;
  @override
  int get activityScore;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardStatsImplCopyWith<_$DashboardStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SeverityBreakdown _$SeverityBreakdownFromJson(Map<String, dynamic> json) {
  return _SeverityBreakdown.fromJson(json);
}

/// @nodoc
mixin _$SeverityBreakdown {
  int get mild => throw _privateConstructorUsedError;
  int get moderate => throw _privateConstructorUsedError;
  int get severe => throw _privateConstructorUsedError;

  /// Serializes this SeverityBreakdown to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SeverityBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SeverityBreakdownCopyWith<SeverityBreakdown> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SeverityBreakdownCopyWith<$Res> {
  factory $SeverityBreakdownCopyWith(
    SeverityBreakdown value,
    $Res Function(SeverityBreakdown) then,
  ) = _$SeverityBreakdownCopyWithImpl<$Res, SeverityBreakdown>;
  @useResult
  $Res call({int mild, int moderate, int severe});
}

/// @nodoc
class _$SeverityBreakdownCopyWithImpl<$Res, $Val extends SeverityBreakdown>
    implements $SeverityBreakdownCopyWith<$Res> {
  _$SeverityBreakdownCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SeverityBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mild = null,
    Object? moderate = null,
    Object? severe = null,
  }) {
    return _then(
      _value.copyWith(
            mild: null == mild
                ? _value.mild
                : mild // ignore: cast_nullable_to_non_nullable
                      as int,
            moderate: null == moderate
                ? _value.moderate
                : moderate // ignore: cast_nullable_to_non_nullable
                      as int,
            severe: null == severe
                ? _value.severe
                : severe // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SeverityBreakdownImplCopyWith<$Res>
    implements $SeverityBreakdownCopyWith<$Res> {
  factory _$$SeverityBreakdownImplCopyWith(
    _$SeverityBreakdownImpl value,
    $Res Function(_$SeverityBreakdownImpl) then,
  ) = __$$SeverityBreakdownImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int mild, int moderate, int severe});
}

/// @nodoc
class __$$SeverityBreakdownImplCopyWithImpl<$Res>
    extends _$SeverityBreakdownCopyWithImpl<$Res, _$SeverityBreakdownImpl>
    implements _$$SeverityBreakdownImplCopyWith<$Res> {
  __$$SeverityBreakdownImplCopyWithImpl(
    _$SeverityBreakdownImpl _value,
    $Res Function(_$SeverityBreakdownImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SeverityBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mild = null,
    Object? moderate = null,
    Object? severe = null,
  }) {
    return _then(
      _$SeverityBreakdownImpl(
        mild: null == mild
            ? _value.mild
            : mild // ignore: cast_nullable_to_non_nullable
                  as int,
        moderate: null == moderate
            ? _value.moderate
            : moderate // ignore: cast_nullable_to_non_nullable
                  as int,
        severe: null == severe
            ? _value.severe
            : severe // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SeverityBreakdownImpl implements _SeverityBreakdown {
  const _$SeverityBreakdownImpl({
    this.mild = 0,
    this.moderate = 0,
    this.severe = 0,
  });

  factory _$SeverityBreakdownImpl.fromJson(Map<String, dynamic> json) =>
      _$$SeverityBreakdownImplFromJson(json);

  @override
  @JsonKey()
  final int mild;
  @override
  @JsonKey()
  final int moderate;
  @override
  @JsonKey()
  final int severe;

  @override
  String toString() {
    return 'SeverityBreakdown(mild: $mild, moderate: $moderate, severe: $severe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SeverityBreakdownImpl &&
            (identical(other.mild, mild) || other.mild == mild) &&
            (identical(other.moderate, moderate) ||
                other.moderate == moderate) &&
            (identical(other.severe, severe) || other.severe == severe));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mild, moderate, severe);

  /// Create a copy of SeverityBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SeverityBreakdownImplCopyWith<_$SeverityBreakdownImpl> get copyWith =>
      __$$SeverityBreakdownImplCopyWithImpl<_$SeverityBreakdownImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SeverityBreakdownImplToJson(this);
  }
}

abstract class _SeverityBreakdown implements SeverityBreakdown {
  const factory _SeverityBreakdown({
    final int mild,
    final int moderate,
    final int severe,
  }) = _$SeverityBreakdownImpl;

  factory _SeverityBreakdown.fromJson(Map<String, dynamic> json) =
      _$SeverityBreakdownImpl.fromJson;

  @override
  int get mild;
  @override
  int get moderate;
  @override
  int get severe;

  /// Create a copy of SeverityBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SeverityBreakdownImplCopyWith<_$SeverityBreakdownImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopMuscleGroup _$TopMuscleGroupFromJson(Map<String, dynamic> json) {
  return _TopMuscleGroup.fromJson(json);
}

/// @nodoc
mixin _$TopMuscleGroup {
  String get name => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Serializes this TopMuscleGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopMuscleGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopMuscleGroupCopyWith<TopMuscleGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopMuscleGroupCopyWith<$Res> {
  factory $TopMuscleGroupCopyWith(
    TopMuscleGroup value,
    $Res Function(TopMuscleGroup) then,
  ) = _$TopMuscleGroupCopyWithImpl<$Res, TopMuscleGroup>;
  @useResult
  $Res call({String name, int count});
}

/// @nodoc
class _$TopMuscleGroupCopyWithImpl<$Res, $Val extends TopMuscleGroup>
    implements $TopMuscleGroupCopyWith<$Res> {
  _$TopMuscleGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopMuscleGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? count = null}) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TopMuscleGroupImplCopyWith<$Res>
    implements $TopMuscleGroupCopyWith<$Res> {
  factory _$$TopMuscleGroupImplCopyWith(
    _$TopMuscleGroupImpl value,
    $Res Function(_$TopMuscleGroupImpl) then,
  ) = __$$TopMuscleGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int count});
}

/// @nodoc
class __$$TopMuscleGroupImplCopyWithImpl<$Res>
    extends _$TopMuscleGroupCopyWithImpl<$Res, _$TopMuscleGroupImpl>
    implements _$$TopMuscleGroupImplCopyWith<$Res> {
  __$$TopMuscleGroupImplCopyWithImpl(
    _$TopMuscleGroupImpl _value,
    $Res Function(_$TopMuscleGroupImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TopMuscleGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? count = null}) {
    return _then(
      _$TopMuscleGroupImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TopMuscleGroupImpl implements _TopMuscleGroup {
  const _$TopMuscleGroupImpl({this.name = '', this.count = 0});

  factory _$TopMuscleGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopMuscleGroupImplFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final int count;

  @override
  String toString() {
    return 'TopMuscleGroup(name: $name, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopMuscleGroupImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, count);

  /// Create a copy of TopMuscleGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopMuscleGroupImplCopyWith<_$TopMuscleGroupImpl> get copyWith =>
      __$$TopMuscleGroupImplCopyWithImpl<_$TopMuscleGroupImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TopMuscleGroupImplToJson(this);
  }
}

abstract class _TopMuscleGroup implements TopMuscleGroup {
  const factory _TopMuscleGroup({final String name, final int count}) =
      _$TopMuscleGroupImpl;

  factory _TopMuscleGroup.fromJson(Map<String, dynamic> json) =
      _$TopMuscleGroupImpl.fromJson;

  @override
  String get name;
  @override
  int get count;

  /// Create a copy of TopMuscleGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopMuscleGroupImplCopyWith<_$TopMuscleGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityHistory _$ActivityHistoryFromJson(Map<String, dynamic> json) {
  return _ActivityHistory.fromJson(json);
}

/// @nodoc
mixin _$ActivityHistory {
  String get day => throw _privateConstructorUsedError;
  int get assigned => throw _privateConstructorUsedError;
  int get completed => throw _privateConstructorUsedError;

  /// Serializes this ActivityHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityHistoryCopyWith<ActivityHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityHistoryCopyWith<$Res> {
  factory $ActivityHistoryCopyWith(
    ActivityHistory value,
    $Res Function(ActivityHistory) then,
  ) = _$ActivityHistoryCopyWithImpl<$Res, ActivityHistory>;
  @useResult
  $Res call({String day, int assigned, int completed});
}

/// @nodoc
class _$ActivityHistoryCopyWithImpl<$Res, $Val extends ActivityHistory>
    implements $ActivityHistoryCopyWith<$Res> {
  _$ActivityHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? assigned = null,
    Object? completed = null,
  }) {
    return _then(
      _value.copyWith(
            day: null == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                      as String,
            assigned: null == assigned
                ? _value.assigned
                : assigned // ignore: cast_nullable_to_non_nullable
                      as int,
            completed: null == completed
                ? _value.completed
                : completed // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivityHistoryImplCopyWith<$Res>
    implements $ActivityHistoryCopyWith<$Res> {
  factory _$$ActivityHistoryImplCopyWith(
    _$ActivityHistoryImpl value,
    $Res Function(_$ActivityHistoryImpl) then,
  ) = __$$ActivityHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String day, int assigned, int completed});
}

/// @nodoc
class __$$ActivityHistoryImplCopyWithImpl<$Res>
    extends _$ActivityHistoryCopyWithImpl<$Res, _$ActivityHistoryImpl>
    implements _$$ActivityHistoryImplCopyWith<$Res> {
  __$$ActivityHistoryImplCopyWithImpl(
    _$ActivityHistoryImpl _value,
    $Res Function(_$ActivityHistoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? assigned = null,
    Object? completed = null,
  }) {
    return _then(
      _$ActivityHistoryImpl(
        day: null == day
            ? _value.day
            : day // ignore: cast_nullable_to_non_nullable
                  as String,
        assigned: null == assigned
            ? _value.assigned
            : assigned // ignore: cast_nullable_to_non_nullable
                  as int,
        completed: null == completed
            ? _value.completed
            : completed // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityHistoryImpl implements _ActivityHistory {
  const _$ActivityHistoryImpl({
    this.day = '',
    this.assigned = 0,
    this.completed = 0,
  });

  factory _$ActivityHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityHistoryImplFromJson(json);

  @override
  @JsonKey()
  final String day;
  @override
  @JsonKey()
  final int assigned;
  @override
  @JsonKey()
  final int completed;

  @override
  String toString() {
    return 'ActivityHistory(day: $day, assigned: $assigned, completed: $completed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityHistoryImpl &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.assigned, assigned) ||
                other.assigned == assigned) &&
            (identical(other.completed, completed) ||
                other.completed == completed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, day, assigned, completed);

  /// Create a copy of ActivityHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityHistoryImplCopyWith<_$ActivityHistoryImpl> get copyWith =>
      __$$ActivityHistoryImplCopyWithImpl<_$ActivityHistoryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityHistoryImplToJson(this);
  }
}

abstract class _ActivityHistory implements ActivityHistory {
  const factory _ActivityHistory({
    final String day,
    final int assigned,
    final int completed,
  }) = _$ActivityHistoryImpl;

  factory _ActivityHistory.fromJson(Map<String, dynamic> json) =
      _$ActivityHistoryImpl.fromJson;

  @override
  String get day;
  @override
  int get assigned;
  @override
  int get completed;

  /// Create a copy of ActivityHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityHistoryImplCopyWith<_$ActivityHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
