// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$MapDetailState {
  MapDetail? get mapDetail => throw _privateConstructorUsedError;

  /// Create a copy of MapDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MapDetailStateCopyWith<MapDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapDetailStateCopyWith<$Res> {
  factory $MapDetailStateCopyWith(
    MapDetailState value,
    $Res Function(MapDetailState) then,
  ) = _$MapDetailStateCopyWithImpl<$Res, MapDetailState>;
  @useResult
  $Res call({MapDetail? mapDetail});

  $MapDetailCopyWith<$Res>? get mapDetail;
}

/// @nodoc
class _$MapDetailStateCopyWithImpl<$Res, $Val extends MapDetailState>
    implements $MapDetailStateCopyWith<$Res> {
  _$MapDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MapDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? mapDetail = freezed}) {
    return _then(
      _value.copyWith(
            mapDetail: freezed == mapDetail
                ? _value.mapDetail
                : mapDetail // ignore: cast_nullable_to_non_nullable
                      as MapDetail?,
          )
          as $Val,
    );
  }

  /// Create a copy of MapDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MapDetailCopyWith<$Res>? get mapDetail {
    if (_value.mapDetail == null) {
      return null;
    }

    return $MapDetailCopyWith<$Res>(_value.mapDetail!, (value) {
      return _then(_value.copyWith(mapDetail: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MapDetailStateImplCopyWith<$Res>
    implements $MapDetailStateCopyWith<$Res> {
  factory _$$MapDetailStateImplCopyWith(
    _$MapDetailStateImpl value,
    $Res Function(_$MapDetailStateImpl) then,
  ) = __$$MapDetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({MapDetail? mapDetail});

  @override
  $MapDetailCopyWith<$Res>? get mapDetail;
}

/// @nodoc
class __$$MapDetailStateImplCopyWithImpl<$Res>
    extends _$MapDetailStateCopyWithImpl<$Res, _$MapDetailStateImpl>
    implements _$$MapDetailStateImplCopyWith<$Res> {
  __$$MapDetailStateImplCopyWithImpl(
    _$MapDetailStateImpl _value,
    $Res Function(_$MapDetailStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MapDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? mapDetail = freezed}) {
    return _then(
      _$MapDetailStateImpl(
        mapDetail: freezed == mapDetail
            ? _value.mapDetail
            : mapDetail // ignore: cast_nullable_to_non_nullable
                  as MapDetail?,
      ),
    );
  }
}

/// @nodoc

class _$MapDetailStateImpl implements _MapDetailState {
  const _$MapDetailStateImpl({this.mapDetail});

  @override
  final MapDetail? mapDetail;

  @override
  String toString() {
    return 'MapDetailState(mapDetail: $mapDetail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapDetailStateImpl &&
            (identical(other.mapDetail, mapDetail) ||
                other.mapDetail == mapDetail));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mapDetail);

  /// Create a copy of MapDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MapDetailStateImplCopyWith<_$MapDetailStateImpl> get copyWith =>
      __$$MapDetailStateImplCopyWithImpl<_$MapDetailStateImpl>(
        this,
        _$identity,
      );
}

abstract class _MapDetailState implements MapDetailState {
  const factory _MapDetailState({final MapDetail? mapDetail}) =
      _$MapDetailStateImpl;

  @override
  MapDetail? get mapDetail;

  /// Create a copy of MapDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MapDetailStateImplCopyWith<_$MapDetailStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
