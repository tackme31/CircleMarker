// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'markdown_output_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$MarkdownOutputState {
  bool get isGenerating => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of MarkdownOutputState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarkdownOutputStateCopyWith<MarkdownOutputState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarkdownOutputStateCopyWith<$Res> {
  factory $MarkdownOutputStateCopyWith(
    MarkdownOutputState value,
    $Res Function(MarkdownOutputState) then,
  ) = _$MarkdownOutputStateCopyWithImpl<$Res, MarkdownOutputState>;
  @useResult
  $Res call({bool isGenerating, String? errorMessage});
}

/// @nodoc
class _$MarkdownOutputStateCopyWithImpl<$Res, $Val extends MarkdownOutputState>
    implements $MarkdownOutputStateCopyWith<$Res> {
  _$MarkdownOutputStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarkdownOutputState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isGenerating = null, Object? errorMessage = freezed}) {
    return _then(
      _value.copyWith(
            isGenerating: null == isGenerating
                ? _value.isGenerating
                : isGenerating // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MarkdownOutputStateImplCopyWith<$Res>
    implements $MarkdownOutputStateCopyWith<$Res> {
  factory _$$MarkdownOutputStateImplCopyWith(
    _$MarkdownOutputStateImpl value,
    $Res Function(_$MarkdownOutputStateImpl) then,
  ) = __$$MarkdownOutputStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isGenerating, String? errorMessage});
}

/// @nodoc
class __$$MarkdownOutputStateImplCopyWithImpl<$Res>
    extends _$MarkdownOutputStateCopyWithImpl<$Res, _$MarkdownOutputStateImpl>
    implements _$$MarkdownOutputStateImplCopyWith<$Res> {
  __$$MarkdownOutputStateImplCopyWithImpl(
    _$MarkdownOutputStateImpl _value,
    $Res Function(_$MarkdownOutputStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MarkdownOutputState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isGenerating = null, Object? errorMessage = freezed}) {
    return _then(
      _$MarkdownOutputStateImpl(
        isGenerating: null == isGenerating
            ? _value.isGenerating
            : isGenerating // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$MarkdownOutputStateImpl implements _MarkdownOutputState {
  const _$MarkdownOutputStateImpl({
    this.isGenerating = false,
    this.errorMessage,
  });

  @override
  @JsonKey()
  final bool isGenerating;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'MarkdownOutputState(isGenerating: $isGenerating, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarkdownOutputStateImpl &&
            (identical(other.isGenerating, isGenerating) ||
                other.isGenerating == isGenerating) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isGenerating, errorMessage);

  /// Create a copy of MarkdownOutputState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarkdownOutputStateImplCopyWith<_$MarkdownOutputStateImpl> get copyWith =>
      __$$MarkdownOutputStateImplCopyWithImpl<_$MarkdownOutputStateImpl>(
        this,
        _$identity,
      );
}

abstract class _MarkdownOutputState implements MarkdownOutputState {
  const factory _MarkdownOutputState({
    final bool isGenerating,
    final String? errorMessage,
  }) = _$MarkdownOutputStateImpl;

  @override
  bool get isGenerating;
  @override
  String? get errorMessage;

  /// Create a copy of MarkdownOutputState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarkdownOutputStateImplCopyWith<_$MarkdownOutputStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
