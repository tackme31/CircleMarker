// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$MapListState {
  List<MapDetail> get maps => throw _privateConstructorUsedError;

  /// Create a copy of MapListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MapListStateCopyWith<MapListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapListStateCopyWith<$Res> {
  factory $MapListStateCopyWith(
    MapListState value,
    $Res Function(MapListState) then,
  ) = _$MapListStateCopyWithImpl<$Res, MapListState>;
  @useResult
  $Res call({List<MapDetail> maps});
}

/// @nodoc
class _$MapListStateCopyWithImpl<$Res, $Val extends MapListState>
    implements $MapListStateCopyWith<$Res> {
  _$MapListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MapListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? maps = null}) {
    return _then(
      _value.copyWith(
            maps: null == maps
                ? _value.maps
                : maps // ignore: cast_nullable_to_non_nullable
                      as List<MapDetail>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MapListStateImplCopyWith<$Res>
    implements $MapListStateCopyWith<$Res> {
  factory _$$MapListStateImplCopyWith(
    _$MapListStateImpl value,
    $Res Function(_$MapListStateImpl) then,
  ) = __$$MapListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<MapDetail> maps});
}

/// @nodoc
class __$$MapListStateImplCopyWithImpl<$Res>
    extends _$MapListStateCopyWithImpl<$Res, _$MapListStateImpl>
    implements _$$MapListStateImplCopyWith<$Res> {
  __$$MapListStateImplCopyWithImpl(
    _$MapListStateImpl _value,
    $Res Function(_$MapListStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MapListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? maps = null}) {
    return _then(
      _$MapListStateImpl(
        maps: null == maps
            ? _value._maps
            : maps // ignore: cast_nullable_to_non_nullable
                  as List<MapDetail>,
      ),
    );
  }
}

/// @nodoc

class _$MapListStateImpl implements _MapListState {
  const _$MapListStateImpl({final List<MapDetail> maps = const []})
    : _maps = maps;

  final List<MapDetail> _maps;
  @override
  @JsonKey()
  List<MapDetail> get maps {
    if (_maps is EqualUnmodifiableListView) return _maps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_maps);
  }

  @override
  String toString() {
    return 'MapListState(maps: $maps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapListStateImpl &&
            const DeepCollectionEquality().equals(other._maps, _maps));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_maps));

  /// Create a copy of MapListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MapListStateImplCopyWith<_$MapListStateImpl> get copyWith =>
      __$$MapListStateImplCopyWithImpl<_$MapListStateImpl>(this, _$identity);
}

abstract class _MapListState implements MapListState {
  const factory _MapListState({final List<MapDetail> maps}) =
      _$MapListStateImpl;

  @override
  List<MapDetail> get maps;

  /// Create a copy of MapListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MapListStateImplCopyWith<_$MapListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
