// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MapSummary _$MapSummaryFromJson(Map<String, dynamic> json) {
  return _MapSummary.fromJson(json);
}

/// @nodoc
mixin _$MapSummary {
  int? get mapId => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;

  /// Serializes this MapSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MapSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MapSummaryCopyWith<MapSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapSummaryCopyWith<$Res> {
  factory $MapSummaryCopyWith(
    MapSummary value,
    $Res Function(MapSummary) then,
  ) = _$MapSummaryCopyWithImpl<$Res, MapSummary>;
  @useResult
  $Res call({int? mapId, String? title});
}

/// @nodoc
class _$MapSummaryCopyWithImpl<$Res, $Val extends MapSummary>
    implements $MapSummaryCopyWith<$Res> {
  _$MapSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MapSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? mapId = freezed, Object? title = freezed}) {
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MapSummaryImplCopyWith<$Res>
    implements $MapSummaryCopyWith<$Res> {
  factory _$$MapSummaryImplCopyWith(
    _$MapSummaryImpl value,
    $Res Function(_$MapSummaryImpl) then,
  ) = __$$MapSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? mapId, String? title});
}

/// @nodoc
class __$$MapSummaryImplCopyWithImpl<$Res>
    extends _$MapSummaryCopyWithImpl<$Res, _$MapSummaryImpl>
    implements _$$MapSummaryImplCopyWith<$Res> {
  __$$MapSummaryImplCopyWithImpl(
    _$MapSummaryImpl _value,
    $Res Function(_$MapSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MapSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? mapId = freezed, Object? title = freezed}) {
    return _then(
      _$MapSummaryImpl(
        mapId: freezed == mapId
            ? _value.mapId
            : mapId // ignore: cast_nullable_to_non_nullable
                  as int?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MapSummaryImpl implements _MapSummary {
  _$MapSummaryImpl({this.mapId, this.title});

  factory _$MapSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$MapSummaryImplFromJson(json);

  @override
  final int? mapId;
  @override
  final String? title;

  @override
  String toString() {
    return 'MapSummary(mapId: $mapId, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapSummaryImpl &&
            (identical(other.mapId, mapId) || other.mapId == mapId) &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mapId, title);

  /// Create a copy of MapSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MapSummaryImplCopyWith<_$MapSummaryImpl> get copyWith =>
      __$$MapSummaryImplCopyWithImpl<_$MapSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MapSummaryImplToJson(this);
  }
}

abstract class _MapSummary implements MapSummary {
  factory _MapSummary({final int? mapId, final String? title}) =
      _$MapSummaryImpl;

  factory _MapSummary.fromJson(Map<String, dynamic> json) =
      _$MapSummaryImpl.fromJson;

  @override
  int? get mapId;
  @override
  String? get title;

  /// Create a copy of MapSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MapSummaryImplCopyWith<_$MapSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
