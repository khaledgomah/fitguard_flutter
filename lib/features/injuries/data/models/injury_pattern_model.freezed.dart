// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'injury_pattern_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

InjuryPatternModel _$InjuryPatternModelFromJson(Map<String, dynamic> json) {
  return _InjuryPatternModel.fromJson(json);
}

/// @nodoc
mixin _$InjuryPatternModel {
  String get muscleGroup => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Serializes this InjuryPatternModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InjuryPatternModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InjuryPatternModelCopyWith<InjuryPatternModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InjuryPatternModelCopyWith<$Res> {
  factory $InjuryPatternModelCopyWith(
    InjuryPatternModel value,
    $Res Function(InjuryPatternModel) then,
  ) = _$InjuryPatternModelCopyWithImpl<$Res, InjuryPatternModel>;
  @useResult
  $Res call({String muscleGroup, int count});
}

/// @nodoc
class _$InjuryPatternModelCopyWithImpl<$Res, $Val extends InjuryPatternModel>
    implements $InjuryPatternModelCopyWith<$Res> {
  _$InjuryPatternModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InjuryPatternModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? muscleGroup = null, Object? count = null}) {
    return _then(
      _value.copyWith(
            muscleGroup: null == muscleGroup
                ? _value.muscleGroup
                : muscleGroup // ignore: cast_nullable_to_non_nullable
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
abstract class _$$InjuryPatternModelImplCopyWith<$Res>
    implements $InjuryPatternModelCopyWith<$Res> {
  factory _$$InjuryPatternModelImplCopyWith(
    _$InjuryPatternModelImpl value,
    $Res Function(_$InjuryPatternModelImpl) then,
  ) = __$$InjuryPatternModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String muscleGroup, int count});
}

/// @nodoc
class __$$InjuryPatternModelImplCopyWithImpl<$Res>
    extends _$InjuryPatternModelCopyWithImpl<$Res, _$InjuryPatternModelImpl>
    implements _$$InjuryPatternModelImplCopyWith<$Res> {
  __$$InjuryPatternModelImplCopyWithImpl(
    _$InjuryPatternModelImpl _value,
    $Res Function(_$InjuryPatternModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InjuryPatternModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? muscleGroup = null, Object? count = null}) {
    return _then(
      _$InjuryPatternModelImpl(
        muscleGroup: null == muscleGroup
            ? _value.muscleGroup
            : muscleGroup // ignore: cast_nullable_to_non_nullable
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
class _$InjuryPatternModelImpl implements _InjuryPatternModel {
  const _$InjuryPatternModelImpl({
    required this.muscleGroup,
    required this.count,
  });

  factory _$InjuryPatternModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InjuryPatternModelImplFromJson(json);

  @override
  final String muscleGroup;
  @override
  final int count;

  @override
  String toString() {
    return 'InjuryPatternModel(muscleGroup: $muscleGroup, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InjuryPatternModelImpl &&
            (identical(other.muscleGroup, muscleGroup) ||
                other.muscleGroup == muscleGroup) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, muscleGroup, count);

  /// Create a copy of InjuryPatternModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InjuryPatternModelImplCopyWith<_$InjuryPatternModelImpl> get copyWith =>
      __$$InjuryPatternModelImplCopyWithImpl<_$InjuryPatternModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InjuryPatternModelImplToJson(this);
  }
}

abstract class _InjuryPatternModel implements InjuryPatternModel {
  const factory _InjuryPatternModel({
    required final String muscleGroup,
    required final int count,
  }) = _$InjuryPatternModelImpl;

  factory _InjuryPatternModel.fromJson(Map<String, dynamic> json) =
      _$InjuryPatternModelImpl.fromJson;

  @override
  String get muscleGroup;
  @override
  int get count;

  /// Create a copy of InjuryPatternModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InjuryPatternModelImplCopyWith<_$InjuryPatternModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
