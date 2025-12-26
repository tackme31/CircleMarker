// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'circle_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CircleListState {
  List<CircleDetail> get circles => throw _privateConstructorUsedError;

  /// Create a copy of CircleListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CircleListStateCopyWith<CircleListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CircleListStateCopyWith<$Res> {
  factory $CircleListStateCopyWith(
    CircleListState value,
    $Res Function(CircleListState) then,
  ) = _$CircleListStateCopyWithImpl<$Res, CircleListState>;
  @useResult
  $Res call({List<CircleDetail> circles});
}

/// @nodoc
class _$CircleListStateCopyWithImpl<$Res, $Val extends CircleListState>
    implements $CircleListStateCopyWith<$Res> {
  _$CircleListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CircleListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? circles = null}) {
    return _then(
      _value.copyWith(
            circles: null == circles
                ? _value.circles
                : circles // ignore: cast_nullable_to_non_nullable
                      as List<CircleDetail>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CircleListStateImplCopyWith<$Res>
    implements $CircleListStateCopyWith<$Res> {
  factory _$$CircleListStateImplCopyWith(
    _$CircleListStateImpl value,
    $Res Function(_$CircleListStateImpl) then,
  ) = __$$CircleListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<CircleDetail> circles});
}

/// @nodoc
class __$$CircleListStateImplCopyWithImpl<$Res>
    extends _$CircleListStateCopyWithImpl<$Res, _$CircleListStateImpl>
    implements _$$CircleListStateImplCopyWith<$Res> {
  __$$CircleListStateImplCopyWithImpl(
    _$CircleListStateImpl _value,
    $Res Function(_$CircleListStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CircleListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? circles = null}) {
    return _then(
      _$CircleListStateImpl(
        circles: null == circles
            ? _value._circles
            : circles // ignore: cast_nullable_to_non_nullable
                  as List<CircleDetail>,
      ),
    );
  }
}

/// @nodoc

class _$CircleListStateImpl implements _CircleListState {
  const _$CircleListStateImpl({final List<CircleDetail> circles = const []})
    : _circles = circles;

  final List<CircleDetail> _circles;
  @override
  @JsonKey()
  List<CircleDetail> get circles {
    if (_circles is EqualUnmodifiableListView) return _circles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_circles);
  }

  @override
  String toString() {
    return 'CircleListState(circles: $circles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CircleListStateImpl &&
            const DeepCollectionEquality().equals(other._circles, _circles));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_circles));

  /// Create a copy of CircleListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CircleListStateImplCopyWith<_$CircleListStateImpl> get copyWith =>
      __$$CircleListStateImplCopyWithImpl<_$CircleListStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CircleListState implements CircleListState {
  const factory _CircleListState({final List<CircleDetail> circles}) =
      _$CircleListStateImpl;

  @override
  List<CircleDetail> get circles;

  /// Create a copy of CircleListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CircleListStateImplCopyWith<_$CircleListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
