// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'injury_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

InjuryLogModel _$InjuryLogModelFromJson(Map<String, dynamic> json) {
  return _InjuryLogModel.fromJson(json);
}

/// @nodoc
mixin _$InjuryLogModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get muscleGroup => throw _privateConstructorUsedError;
  String get injuryType => throw _privateConstructorUsedError;
  String get severity => throw _privateConstructorUsedError;
  DateTime get dateOccurred => throw _privateConstructorUsedError;
  String get recoveryStatus => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this InjuryLogModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InjuryLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InjuryLogModelCopyWith<InjuryLogModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InjuryLogModelCopyWith<$Res> {
  factory $InjuryLogModelCopyWith(
    InjuryLogModel value,
    $Res Function(InjuryLogModel) then,
  ) = _$InjuryLogModelCopyWithImpl<$Res, InjuryLogModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String muscleGroup,
    String injuryType,
    String severity,
    DateTime dateOccurred,
    String recoveryStatus,
    String? notes,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$InjuryLogModelCopyWithImpl<$Res, $Val extends InjuryLogModel>
    implements $InjuryLogModelCopyWith<$Res> {
  _$InjuryLogModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InjuryLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? muscleGroup = null,
    Object? injuryType = null,
    Object? severity = null,
    Object? dateOccurred = null,
    Object? recoveryStatus = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            muscleGroup: null == muscleGroup
                ? _value.muscleGroup
                : muscleGroup // ignore: cast_nullable_to_non_nullable
                      as String,
            injuryType: null == injuryType
                ? _value.injuryType
                : injuryType // ignore: cast_nullable_to_non_nullable
                      as String,
            severity: null == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                      as String,
            dateOccurred: null == dateOccurred
                ? _value.dateOccurred
                : dateOccurred // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            recoveryStatus: null == recoveryStatus
                ? _value.recoveryStatus
                : recoveryStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InjuryLogModelImplCopyWith<$Res>
    implements $InjuryLogModelCopyWith<$Res> {
  factory _$$InjuryLogModelImplCopyWith(
    _$InjuryLogModelImpl value,
    $Res Function(_$InjuryLogModelImpl) then,
  ) = __$$InjuryLogModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String muscleGroup,
    String injuryType,
    String severity,
    DateTime dateOccurred,
    String recoveryStatus,
    String? notes,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$InjuryLogModelImplCopyWithImpl<$Res>
    extends _$InjuryLogModelCopyWithImpl<$Res, _$InjuryLogModelImpl>
    implements _$$InjuryLogModelImplCopyWith<$Res> {
  __$$InjuryLogModelImplCopyWithImpl(
    _$InjuryLogModelImpl _value,
    $Res Function(_$InjuryLogModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InjuryLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? muscleGroup = null,
    Object? injuryType = null,
    Object? severity = null,
    Object? dateOccurred = null,
    Object? recoveryStatus = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$InjuryLogModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        muscleGroup: null == muscleGroup
            ? _value.muscleGroup
            : muscleGroup // ignore: cast_nullable_to_non_nullable
                  as String,
        injuryType: null == injuryType
            ? _value.injuryType
            : injuryType // ignore: cast_nullable_to_non_nullable
                  as String,
        severity: null == severity
            ? _value.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as String,
        dateOccurred: null == dateOccurred
            ? _value.dateOccurred
            : dateOccurred // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        recoveryStatus: null == recoveryStatus
            ? _value.recoveryStatus
            : recoveryStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InjuryLogModelImpl implements _InjuryLogModel {
  const _$InjuryLogModelImpl({
    @JsonKey(name: '_id') required this.id,
    required this.muscleGroup,
    required this.injuryType,
    required this.severity,
    required this.dateOccurred,
    required this.recoveryStatus,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$InjuryLogModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InjuryLogModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String muscleGroup;
  @override
  final String injuryType;
  @override
  final String severity;
  @override
  final DateTime dateOccurred;
  @override
  final String recoveryStatus;
  @override
  final String? notes;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'InjuryLogModel(id: $id, muscleGroup: $muscleGroup, injuryType: $injuryType, severity: $severity, dateOccurred: $dateOccurred, recoveryStatus: $recoveryStatus, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InjuryLogModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.muscleGroup, muscleGroup) ||
                other.muscleGroup == muscleGroup) &&
            (identical(other.injuryType, injuryType) ||
                other.injuryType == injuryType) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.dateOccurred, dateOccurred) ||
                other.dateOccurred == dateOccurred) &&
            (identical(other.recoveryStatus, recoveryStatus) ||
                other.recoveryStatus == recoveryStatus) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    muscleGroup,
    injuryType,
    severity,
    dateOccurred,
    recoveryStatus,
    notes,
    createdAt,
    updatedAt,
  );

  /// Create a copy of InjuryLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InjuryLogModelImplCopyWith<_$InjuryLogModelImpl> get copyWith =>
      __$$InjuryLogModelImplCopyWithImpl<_$InjuryLogModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InjuryLogModelImplToJson(this);
  }
}

abstract class _InjuryLogModel implements InjuryLogModel {
  const factory _InjuryLogModel({
    @JsonKey(name: '_id') required final String id,
    required final String muscleGroup,
    required final String injuryType,
    required final String severity,
    required final DateTime dateOccurred,
    required final String recoveryStatus,
    final String? notes,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$InjuryLogModelImpl;

  factory _InjuryLogModel.fromJson(Map<String, dynamic> json) =
      _$InjuryLogModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get muscleGroup;
  @override
  String get injuryType;
  @override
  String get severity;
  @override
  DateTime get dateOccurred;
  @override
  String get recoveryStatus;
  @override
  String? get notes;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of InjuryLogModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InjuryLogModelImplCopyWith<_$InjuryLogModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
