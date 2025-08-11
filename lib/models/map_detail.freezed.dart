// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MapDetail _$MapDetailFromJson(Map<String, dynamic> json) {
  return _MapDetail.fromJson(json);
}

/// @nodoc
mixin _$MapDetail {
  int? get mapId => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get baseImagePath => throw _privateConstructorUsedError;
  List<int> get circleIds => throw _privateConstructorUsedError;

  /// Serializes this MapDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MapDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MapDetailCopyWith<MapDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapDetailCopyWith<$Res> {
  factory $MapDetailCopyWith(MapDetail value, $Res Function(MapDetail) then) =
      _$MapDetailCopyWithImpl<$Res, MapDetail>;
  @useResult
  $Res call({
    int? mapId,
    String? title,
    String? baseImagePath,
    List<int> circleIds,
  });
}

/// @nodoc
class _$MapDetailCopyWithImpl<$Res, $Val extends MapDetail>
    implements $MapDetailCopyWith<$Res> {
  _$MapDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MapDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mapId = freezed,
    Object? title = freezed,
    Object? baseImagePath = freezed,
    Object? circleIds = null,
  }) {
    return _then(
      _value.copyWith(
            mapId: freezed == mapId
                ? _value.mapId
                : mapId // ignore: cast_nullable_to_non_nullable
                      as int?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            baseImagePath: freezed == baseImagePath
                ? _value.baseImagePath
                : baseImagePath // ignore: cast_nullable_to_non_nullable
                      as String?,
            circleIds: null == circleIds
                ? _value.circleIds
                : circleIds // ignore: cast_nullable_to_non_nullable
                      as List<int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MapDetailImplCopyWith<$Res>
    implements $MapDetailCopyWith<$Res> {
  factory _$$MapDetailImplCopyWith(
    _$MapDetailImpl value,
    $Res Function(_$MapDetailImpl) then,
  ) = __$$MapDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? mapId,
    String? title,
    String? baseImagePath,
    List<int> circleIds,
  });
}

/// @nodoc
class __$$MapDetailImplCopyWithImpl<$Res>
    extends _$MapDetailCopyWithImpl<$Res, _$MapDetailImpl>
    implements _$$MapDetailImplCopyWith<$Res> {
  __$$MapDetailImplCopyWithImpl(
    _$MapDetailImpl _value,
    $Res Function(_$MapDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MapDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mapId = freezed,
    Object? title = freezed,
    Object? baseImagePath = freezed,
    Object? circleIds = null,
  }) {
    return _then(
      _$MapDetailImpl(
        mapId: freezed == mapId
            ? _value.mapId
            : mapId // ignore: cast_nullable_to_non_nullable
                  as int?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        baseImagePath: freezed == baseImagePath
            ? _value.baseImagePath
            : baseImagePath // ignore: cast_nullable_to_non_nullable
                  as String?,
        circleIds: null == circleIds
            ? _value._circleIds
            : circleIds // ignore: cast_nullable_to_non_nullable
                  as List<int>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MapDetailImpl implements _MapDetail {
  const _$MapDetailImpl({
    this.mapId,
    this.title,
    this.baseImagePath,
    final List<int> circleIds = const [],
  }) : _circleIds = circleIds;

  factory _$MapDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$MapDetailImplFromJson(json);

  @override
  final int? mapId;
  @override
  final String? title;
  @override
  final String? baseImagePath;
  final List<int> _circleIds;
  @override
  @JsonKey()
  List<int> get circleIds {
    if (_circleIds is EqualUnmodifiableListView) return _circleIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_circleIds);
  }

  @override
  String toString() {
    return 'MapDetail(mapId: $mapId, title: $title, baseImagePath: $baseImagePath, circleIds: $circleIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapDetailImpl &&
            (identical(other.mapId, mapId) || other.mapId == mapId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.baseImagePath, baseImagePath) ||
                other.baseImagePath == baseImagePath) &&
            const DeepCollectionEquality().equals(
              other._circleIds,
              _circleIds,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    mapId,
    title,
    baseImagePath,
    const DeepCollectionEquality().hash(_circleIds),
  );

  /// Create a copy of MapDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MapDetailImplCopyWith<_$MapDetailImpl> get copyWith =>
      __$$MapDetailImplCopyWithImpl<_$MapDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MapDetailImplToJson(this);
  }
}

abstract class _MapDetail implements MapDetail {
  const factory _MapDetail({
    final int? mapId,
    final String? title,
    final String? baseImagePath,
    final List<int> circleIds,
  }) = _$MapDetailImpl;

  factory _MapDetail.fromJson(Map<String, dynamic> json) =
      _$MapDetailImpl.fromJson;

  @override
  int? get mapId;
  @override
  String? get title;
  @override
  String? get baseImagePath;
  @override
  List<int> get circleIds;

  /// Create a copy of MapDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MapDetailImplCopyWith<_$MapDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
