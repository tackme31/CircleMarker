// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_export_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$MapExportState {
  bool get isExporting => throw _privateConstructorUsedError;
  bool get isImporting => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  String? get exportedFilePath => throw _privateConstructorUsedError;

  /// Create a copy of MapExportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MapExportStateCopyWith<MapExportState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapExportStateCopyWith<$Res> {
  factory $MapExportStateCopyWith(
    MapExportState value,
    $Res Function(MapExportState) then,
  ) = _$MapExportStateCopyWithImpl<$Res, MapExportState>;
  @useResult
  $Res call({
    bool isExporting,
    bool isImporting,
    String? errorMessage,
    String? exportedFilePath,
  });
}

/// @nodoc
class _$MapExportStateCopyWithImpl<$Res, $Val extends MapExportState>
    implements $MapExportStateCopyWith<$Res> {
  _$MapExportStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MapExportState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isExporting = null,
    Object? isImporting = null,
    Object? errorMessage = freezed,
    Object? exportedFilePath = freezed,
  }) {
    return _then(
      _value.copyWith(
            isExporting: null == isExporting
                ? _value.isExporting
                : isExporting // ignore: cast_nullable_to_non_nullable
                      as bool,
            isImporting: null == isImporting
                ? _value.isImporting
                : isImporting // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            exportedFilePath: freezed == exportedFilePath
                ? _value.exportedFilePath
                : exportedFilePath // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MapExportStateImplCopyWith<$Res>
    implements $MapExportStateCopyWith<$Res> {
  factory _$$MapExportStateImplCopyWith(
    _$MapExportStateImpl value,
    $Res Function(_$MapExportStateImpl) then,
  ) = __$$MapExportStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isExporting,
    bool isImporting,
    String? errorMessage,
    String? exportedFilePath,
  });
}

/// @nodoc
class __$$MapExportStateImplCopyWithImpl<$Res>
    extends _$MapExportStateCopyWithImpl<$Res, _$MapExportStateImpl>
    implements _$$MapExportStateImplCopyWith<$Res> {
  __$$MapExportStateImplCopyWithImpl(
    _$MapExportStateImpl _value,
    $Res Function(_$MapExportStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MapExportState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isExporting = null,
    Object? isImporting = null,
    Object? errorMessage = freezed,
    Object? exportedFilePath = freezed,
  }) {
    return _then(
      _$MapExportStateImpl(
        isExporting: null == isExporting
            ? _value.isExporting
            : isExporting // ignore: cast_nullable_to_non_nullable
                  as bool,
        isImporting: null == isImporting
            ? _value.isImporting
            : isImporting // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        exportedFilePath: freezed == exportedFilePath
            ? _value.exportedFilePath
            : exportedFilePath // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$MapExportStateImpl implements _MapExportState {
  const _$MapExportStateImpl({
    this.isExporting = false,
    this.isImporting = false,
    this.errorMessage,
    this.exportedFilePath,
  });

  @override
  @JsonKey()
  final bool isExporting;
  @override
  @JsonKey()
  final bool isImporting;
  @override
  final String? errorMessage;
  @override
  final String? exportedFilePath;

  @override
  String toString() {
    return 'MapExportState(isExporting: $isExporting, isImporting: $isImporting, errorMessage: $errorMessage, exportedFilePath: $exportedFilePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapExportStateImpl &&
            (identical(other.isExporting, isExporting) ||
                other.isExporting == isExporting) &&
            (identical(other.isImporting, isImporting) ||
                other.isImporting == isImporting) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.exportedFilePath, exportedFilePath) ||
                other.exportedFilePath == exportedFilePath));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isExporting,
    isImporting,
    errorMessage,
    exportedFilePath,
  );

  /// Create a copy of MapExportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MapExportStateImplCopyWith<_$MapExportStateImpl> get copyWith =>
      __$$MapExportStateImplCopyWithImpl<_$MapExportStateImpl>(
        this,
        _$identity,
      );
}

abstract class _MapExportState implements MapExportState {
  const factory _MapExportState({
    final bool isExporting,
    final bool isImporting,
    final String? errorMessage,
    final String? exportedFilePath,
  }) = _$MapExportStateImpl;

  @override
  bool get isExporting;
  @override
  bool get isImporting;
  @override
  String? get errorMessage;
  @override
  String? get exportedFilePath;

  /// Create a copy of MapExportState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MapExportStateImplCopyWith<_$MapExportStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
