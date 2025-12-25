// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$MapImagePaths {
  String get original => throw _privateConstructorUsedError;
  String get thumbnail => throw _privateConstructorUsedError;

  /// Create a copy of MapImagePaths
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MapImagePathsCopyWith<MapImagePaths> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapImagePathsCopyWith<$Res> {
  factory $MapImagePathsCopyWith(
    MapImagePaths value,
    $Res Function(MapImagePaths) then,
  ) = _$MapImagePathsCopyWithImpl<$Res, MapImagePaths>;
  @useResult
  $Res call({String original, String thumbnail});
}

/// @nodoc
class _$MapImagePathsCopyWithImpl<$Res, $Val extends MapImagePaths>
    implements $MapImagePathsCopyWith<$Res> {
  _$MapImagePathsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MapImagePaths
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? original = null, Object? thumbnail = null}) {
    return _then(
      _value.copyWith(
            original: null == original
                ? _value.original
                : original // ignore: cast_nullable_to_non_nullable
                      as String,
            thumbnail: null == thumbnail
                ? _value.thumbnail
                : thumbnail // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MapImagePathsImplCopyWith<$Res>
    implements $MapImagePathsCopyWith<$Res> {
  factory _$$MapImagePathsImplCopyWith(
    _$MapImagePathsImpl value,
    $Res Function(_$MapImagePathsImpl) then,
  ) = __$$MapImagePathsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String original, String thumbnail});
}

/// @nodoc
class __$$MapImagePathsImplCopyWithImpl<$Res>
    extends _$MapImagePathsCopyWithImpl<$Res, _$MapImagePathsImpl>
    implements _$$MapImagePathsImplCopyWith<$Res> {
  __$$MapImagePathsImplCopyWithImpl(
    _$MapImagePathsImpl _value,
    $Res Function(_$MapImagePathsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MapImagePaths
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? original = null, Object? thumbnail = null}) {
    return _then(
      _$MapImagePathsImpl(
        original: null == original
            ? _value.original
            : original // ignore: cast_nullable_to_non_nullable
                  as String,
        thumbnail: null == thumbnail
            ? _value.thumbnail
            : thumbnail // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$MapImagePathsImpl implements _MapImagePaths {
  const _$MapImagePathsImpl({required this.original, required this.thumbnail});

  @override
  final String original;
  @override
  final String thumbnail;

  @override
  String toString() {
    return 'MapImagePaths(original: $original, thumbnail: $thumbnail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapImagePathsImpl &&
            (identical(other.original, original) ||
                other.original == original) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail));
  }

  @override
  int get hashCode => Object.hash(runtimeType, original, thumbnail);

  /// Create a copy of MapImagePaths
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MapImagePathsImplCopyWith<_$MapImagePathsImpl> get copyWith =>
      __$$MapImagePathsImplCopyWithImpl<_$MapImagePathsImpl>(this, _$identity);
}

abstract class _MapImagePaths implements MapImagePaths {
  const factory _MapImagePaths({
    required final String original,
    required final String thumbnail,
  }) = _$MapImagePathsImpl;

  @override
  String get original;
  @override
  String get thumbnail;

  /// Create a copy of MapImagePaths
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MapImagePathsImplCopyWith<_$MapImagePathsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
