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
  List<CircleWithMapTitle> get circles => throw _privateConstructorUsedError;
  SortType get sortType => throw _privateConstructorUsedError;
  SortDirection get sortDirection => throw _privateConstructorUsedError;
  List<int> get selectedMapIds => throw _privateConstructorUsedError;
  String get searchQuery =>
      throw _privateConstructorUsedError; // Pagination fields
  bool get hasMore => throw _privateConstructorUsedError;
  int get currentOffset => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  bool get isLoadingMore => throw _privateConstructorUsedError;

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
  $Res call({
    List<CircleWithMapTitle> circles,
    SortType sortType,
    SortDirection sortDirection,
    List<int> selectedMapIds,
    String searchQuery,
    bool hasMore,
    int currentOffset,
    int pageSize,
    bool isLoadingMore,
  });
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
  $Res call({
    Object? circles = null,
    Object? sortType = null,
    Object? sortDirection = null,
    Object? selectedMapIds = null,
    Object? searchQuery = null,
    Object? hasMore = null,
    Object? currentOffset = null,
    Object? pageSize = null,
    Object? isLoadingMore = null,
  }) {
    return _then(
      _value.copyWith(
            circles: null == circles
                ? _value.circles
                : circles // ignore: cast_nullable_to_non_nullable
                      as List<CircleWithMapTitle>,
            sortType: null == sortType
                ? _value.sortType
                : sortType // ignore: cast_nullable_to_non_nullable
                      as SortType,
            sortDirection: null == sortDirection
                ? _value.sortDirection
                : sortDirection // ignore: cast_nullable_to_non_nullable
                      as SortDirection,
            selectedMapIds: null == selectedMapIds
                ? _value.selectedMapIds
                : selectedMapIds // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            searchQuery: null == searchQuery
                ? _value.searchQuery
                : searchQuery // ignore: cast_nullable_to_non_nullable
                      as String,
            hasMore: null == hasMore
                ? _value.hasMore
                : hasMore // ignore: cast_nullable_to_non_nullable
                      as bool,
            currentOffset: null == currentOffset
                ? _value.currentOffset
                : currentOffset // ignore: cast_nullable_to_non_nullable
                      as int,
            pageSize: null == pageSize
                ? _value.pageSize
                : pageSize // ignore: cast_nullable_to_non_nullable
                      as int,
            isLoadingMore: null == isLoadingMore
                ? _value.isLoadingMore
                : isLoadingMore // ignore: cast_nullable_to_non_nullable
                      as bool,
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
  $Res call({
    List<CircleWithMapTitle> circles,
    SortType sortType,
    SortDirection sortDirection,
    List<int> selectedMapIds,
    String searchQuery,
    bool hasMore,
    int currentOffset,
    int pageSize,
    bool isLoadingMore,
  });
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
  $Res call({
    Object? circles = null,
    Object? sortType = null,
    Object? sortDirection = null,
    Object? selectedMapIds = null,
    Object? searchQuery = null,
    Object? hasMore = null,
    Object? currentOffset = null,
    Object? pageSize = null,
    Object? isLoadingMore = null,
  }) {
    return _then(
      _$CircleListStateImpl(
        circles: null == circles
            ? _value._circles
            : circles // ignore: cast_nullable_to_non_nullable
                  as List<CircleWithMapTitle>,
        sortType: null == sortType
            ? _value.sortType
            : sortType // ignore: cast_nullable_to_non_nullable
                  as SortType,
        sortDirection: null == sortDirection
            ? _value.sortDirection
            : sortDirection // ignore: cast_nullable_to_non_nullable
                  as SortDirection,
        selectedMapIds: null == selectedMapIds
            ? _value._selectedMapIds
            : selectedMapIds // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        searchQuery: null == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String,
        hasMore: null == hasMore
            ? _value.hasMore
            : hasMore // ignore: cast_nullable_to_non_nullable
                  as bool,
        currentOffset: null == currentOffset
            ? _value.currentOffset
            : currentOffset // ignore: cast_nullable_to_non_nullable
                  as int,
        pageSize: null == pageSize
            ? _value.pageSize
            : pageSize // ignore: cast_nullable_to_non_nullable
                  as int,
        isLoadingMore: null == isLoadingMore
            ? _value.isLoadingMore
            : isLoadingMore // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$CircleListStateImpl implements _CircleListState {
  const _$CircleListStateImpl({
    final List<CircleWithMapTitle> circles = const [],
    this.sortType = SortType.mapName,
    this.sortDirection = SortDirection.asc,
    final List<int> selectedMapIds = const [],
    this.searchQuery = '',
    this.hasMore = false,
    this.currentOffset = 0,
    this.pageSize = 20,
    this.isLoadingMore = false,
  }) : _circles = circles,
       _selectedMapIds = selectedMapIds;

  final List<CircleWithMapTitle> _circles;
  @override
  @JsonKey()
  List<CircleWithMapTitle> get circles {
    if (_circles is EqualUnmodifiableListView) return _circles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_circles);
  }

  @override
  @JsonKey()
  final SortType sortType;
  @override
  @JsonKey()
  final SortDirection sortDirection;
  final List<int> _selectedMapIds;
  @override
  @JsonKey()
  List<int> get selectedMapIds {
    if (_selectedMapIds is EqualUnmodifiableListView) return _selectedMapIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedMapIds);
  }

  @override
  @JsonKey()
  final String searchQuery;
  // Pagination fields
  @override
  @JsonKey()
  final bool hasMore;
  @override
  @JsonKey()
  final int currentOffset;
  @override
  @JsonKey()
  final int pageSize;
  @override
  @JsonKey()
  final bool isLoadingMore;

  @override
  String toString() {
    return 'CircleListState(circles: $circles, sortType: $sortType, sortDirection: $sortDirection, selectedMapIds: $selectedMapIds, searchQuery: $searchQuery, hasMore: $hasMore, currentOffset: $currentOffset, pageSize: $pageSize, isLoadingMore: $isLoadingMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CircleListStateImpl &&
            const DeepCollectionEquality().equals(other._circles, _circles) &&
            (identical(other.sortType, sortType) ||
                other.sortType == sortType) &&
            (identical(other.sortDirection, sortDirection) ||
                other.sortDirection == sortDirection) &&
            const DeepCollectionEquality().equals(
              other._selectedMapIds,
              _selectedMapIds,
            ) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.currentOffset, currentOffset) ||
                other.currentOffset == currentOffset) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_circles),
    sortType,
    sortDirection,
    const DeepCollectionEquality().hash(_selectedMapIds),
    searchQuery,
    hasMore,
    currentOffset,
    pageSize,
    isLoadingMore,
  );

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
  const factory _CircleListState({
    final List<CircleWithMapTitle> circles,
    final SortType sortType,
    final SortDirection sortDirection,
    final List<int> selectedMapIds,
    final String searchQuery,
    final bool hasMore,
    final int currentOffset,
    final int pageSize,
    final bool isLoadingMore,
  }) = _$CircleListStateImpl;

  @override
  List<CircleWithMapTitle> get circles;
  @override
  SortType get sortType;
  @override
  SortDirection get sortDirection;
  @override
  List<int> get selectedMapIds;
  @override
  String get searchQuery; // Pagination fields
  @override
  bool get hasMore;
  @override
  int get currentOffset;
  @override
  int get pageSize;
  @override
  bool get isLoadingMore;

  /// Create a copy of CircleListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CircleListStateImplCopyWith<_$CircleListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
