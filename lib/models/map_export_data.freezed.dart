// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_export_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MapExportData _$MapExportDataFromJson(Map<String, dynamic> json) {
  return _MapExportData.fromJson(json);
}

/// @nodoc
mixin _$MapExportData {
  MapExportManifest get manifest => throw _privateConstructorUsedError;
  MapExportContent get content => throw _privateConstructorUsedError;

  /// Serializes this MapExportData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MapExportData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MapExportDataCopyWith<MapExportData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapExportDataCopyWith<$Res> {
  factory $MapExportDataCopyWith(
    MapExportData value,
    $Res Function(MapExportData) then,
  ) = _$MapExportDataCopyWithImpl<$Res, MapExportData>;
  @useResult
  $Res call({MapExportManifest manifest, MapExportContent content});

  $MapExportManifestCopyWith<$Res> get manifest;
  $MapExportContentCopyWith<$Res> get content;
}

/// @nodoc
class _$MapExportDataCopyWithImpl<$Res, $Val extends MapExportData>
    implements $MapExportDataCopyWith<$Res> {
  _$MapExportDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MapExportData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? manifest = null, Object? content = null}) {
    return _then(
      _value.copyWith(
            manifest: null == manifest
                ? _value.manifest
                : manifest // ignore: cast_nullable_to_non_nullable
                      as MapExportManifest,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as MapExportContent,
          )
          as $Val,
    );
  }

  /// Create a copy of MapExportData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MapExportManifestCopyWith<$Res> get manifest {
    return $MapExportManifestCopyWith<$Res>(_value.manifest, (value) {
      return _then(_value.copyWith(manifest: value) as $Val);
    });
  }

  /// Create a copy of MapExportData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MapExportContentCopyWith<$Res> get content {
    return $MapExportContentCopyWith<$Res>(_value.content, (value) {
      return _then(_value.copyWith(content: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MapExportDataImplCopyWith<$Res>
    implements $MapExportDataCopyWith<$Res> {
  factory _$$MapExportDataImplCopyWith(
    _$MapExportDataImpl value,
    $Res Function(_$MapExportDataImpl) then,
  ) = __$$MapExportDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({MapExportManifest manifest, MapExportContent content});

  @override
  $MapExportManifestCopyWith<$Res> get manifest;
  @override
  $MapExportContentCopyWith<$Res> get content;
}

/// @nodoc
class __$$MapExportDataImplCopyWithImpl<$Res>
    extends _$MapExportDataCopyWithImpl<$Res, _$MapExportDataImpl>
    implements _$$MapExportDataImplCopyWith<$Res> {
  __$$MapExportDataImplCopyWithImpl(
    _$MapExportDataImpl _value,
    $Res Function(_$MapExportDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MapExportData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? manifest = null, Object? content = null}) {
    return _then(
      _$MapExportDataImpl(
        manifest: null == manifest
            ? _value.manifest
            : manifest // ignore: cast_nullable_to_non_nullable
                  as MapExportManifest,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as MapExportContent,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MapExportDataImpl implements _MapExportData {
  const _$MapExportDataImpl({required this.manifest, required this.content});

  factory _$MapExportDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MapExportDataImplFromJson(json);

  @override
  final MapExportManifest manifest;
  @override
  final MapExportContent content;

  @override
  String toString() {
    return 'MapExportData(manifest: $manifest, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapExportDataImpl &&
            (identical(other.manifest, manifest) ||
                other.manifest == manifest) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, manifest, content);

  /// Create a copy of MapExportData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MapExportDataImplCopyWith<_$MapExportDataImpl> get copyWith =>
      __$$MapExportDataImplCopyWithImpl<_$MapExportDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MapExportDataImplToJson(this);
  }
}

abstract class _MapExportData implements MapExportData {
  const factory _MapExportData({
    required final MapExportManifest manifest,
    required final MapExportContent content,
  }) = _$MapExportDataImpl;

  factory _MapExportData.fromJson(Map<String, dynamic> json) =
      _$MapExportDataImpl.fromJson;

  @override
  MapExportManifest get manifest;
  @override
  MapExportContent get content;

  /// Create a copy of MapExportData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MapExportDataImplCopyWith<_$MapExportDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MapExportManifest _$MapExportManifestFromJson(Map<String, dynamic> json) {
  return _MapExportManifest.fromJson(json);
}

/// @nodoc
mixin _$MapExportManifest {
  String get version => throw _privateConstructorUsedError;
  String get exportDate => throw _privateConstructorUsedError;

  /// Serializes this MapExportManifest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MapExportManifest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MapExportManifestCopyWith<MapExportManifest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapExportManifestCopyWith<$Res> {
  factory $MapExportManifestCopyWith(
    MapExportManifest value,
    $Res Function(MapExportManifest) then,
  ) = _$MapExportManifestCopyWithImpl<$Res, MapExportManifest>;
  @useResult
  $Res call({String version, String exportDate});
}

/// @nodoc
class _$MapExportManifestCopyWithImpl<$Res, $Val extends MapExportManifest>
    implements $MapExportManifestCopyWith<$Res> {
  _$MapExportManifestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MapExportManifest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? version = null, Object? exportDate = null}) {
    return _then(
      _value.copyWith(
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as String,
            exportDate: null == exportDate
                ? _value.exportDate
                : exportDate // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MapExportManifestImplCopyWith<$Res>
    implements $MapExportManifestCopyWith<$Res> {
  factory _$$MapExportManifestImplCopyWith(
    _$MapExportManifestImpl value,
    $Res Function(_$MapExportManifestImpl) then,
  ) = __$$MapExportManifestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String version, String exportDate});
}

/// @nodoc
class __$$MapExportManifestImplCopyWithImpl<$Res>
    extends _$MapExportManifestCopyWithImpl<$Res, _$MapExportManifestImpl>
    implements _$$MapExportManifestImplCopyWith<$Res> {
  __$$MapExportManifestImplCopyWithImpl(
    _$MapExportManifestImpl _value,
    $Res Function(_$MapExportManifestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MapExportManifest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? version = null, Object? exportDate = null}) {
    return _then(
      _$MapExportManifestImpl(
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as String,
        exportDate: null == exportDate
            ? _value.exportDate
            : exportDate // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MapExportManifestImpl implements _MapExportManifest {
  const _$MapExportManifestImpl({
    required this.version,
    required this.exportDate,
  });

  factory _$MapExportManifestImpl.fromJson(Map<String, dynamic> json) =>
      _$$MapExportManifestImplFromJson(json);

  @override
  final String version;
  @override
  final String exportDate;

  @override
  String toString() {
    return 'MapExportManifest(version: $version, exportDate: $exportDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapExportManifestImpl &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.exportDate, exportDate) ||
                other.exportDate == exportDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, version, exportDate);

  /// Create a copy of MapExportManifest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MapExportManifestImplCopyWith<_$MapExportManifestImpl> get copyWith =>
      __$$MapExportManifestImplCopyWithImpl<_$MapExportManifestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MapExportManifestImplToJson(this);
  }
}

abstract class _MapExportManifest implements MapExportManifest {
  const factory _MapExportManifest({
    required final String version,
    required final String exportDate,
  }) = _$MapExportManifestImpl;

  factory _MapExportManifest.fromJson(Map<String, dynamic> json) =
      _$MapExportManifestImpl.fromJson;

  @override
  String get version;
  @override
  String get exportDate;

  /// Create a copy of MapExportManifest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MapExportManifestImplCopyWith<_$MapExportManifestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MapExportContent _$MapExportContentFromJson(Map<String, dynamic> json) {
  return _MapExportContent.fromJson(json);
}

/// @nodoc
mixin _$MapExportContent {
  MapExportMapData get map => throw _privateConstructorUsedError;
  List<CircleExportData> get circles => throw _privateConstructorUsedError;

  /// Serializes this MapExportContent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MapExportContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MapExportContentCopyWith<MapExportContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapExportContentCopyWith<$Res> {
  factory $MapExportContentCopyWith(
    MapExportContent value,
    $Res Function(MapExportContent) then,
  ) = _$MapExportContentCopyWithImpl<$Res, MapExportContent>;
  @useResult
  $Res call({MapExportMapData map, List<CircleExportData> circles});

  $MapExportMapDataCopyWith<$Res> get map;
}

/// @nodoc
class _$MapExportContentCopyWithImpl<$Res, $Val extends MapExportContent>
    implements $MapExportContentCopyWith<$Res> {
  _$MapExportContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MapExportContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? map = null, Object? circles = null}) {
    return _then(
      _value.copyWith(
            map: null == map
                ? _value.map
                : map // ignore: cast_nullable_to_non_nullable
                      as MapExportMapData,
            circles: null == circles
                ? _value.circles
                : circles // ignore: cast_nullable_to_non_nullable
                      as List<CircleExportData>,
          )
          as $Val,
    );
  }

  /// Create a copy of MapExportContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MapExportMapDataCopyWith<$Res> get map {
    return $MapExportMapDataCopyWith<$Res>(_value.map, (value) {
      return _then(_value.copyWith(map: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MapExportContentImplCopyWith<$Res>
    implements $MapExportContentCopyWith<$Res> {
  factory _$$MapExportContentImplCopyWith(
    _$MapExportContentImpl value,
    $Res Function(_$MapExportContentImpl) then,
  ) = __$$MapExportContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({MapExportMapData map, List<CircleExportData> circles});

  @override
  $MapExportMapDataCopyWith<$Res> get map;
}

/// @nodoc
class __$$MapExportContentImplCopyWithImpl<$Res>
    extends _$MapExportContentCopyWithImpl<$Res, _$MapExportContentImpl>
    implements _$$MapExportContentImplCopyWith<$Res> {
  __$$MapExportContentImplCopyWithImpl(
    _$MapExportContentImpl _value,
    $Res Function(_$MapExportContentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MapExportContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? map = null, Object? circles = null}) {
    return _then(
      _$MapExportContentImpl(
        map: null == map
            ? _value.map
            : map // ignore: cast_nullable_to_non_nullable
                  as MapExportMapData,
        circles: null == circles
            ? _value._circles
            : circles // ignore: cast_nullable_to_non_nullable
                  as List<CircleExportData>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MapExportContentImpl implements _MapExportContent {
  const _$MapExportContentImpl({
    required this.map,
    required final List<CircleExportData> circles,
  }) : _circles = circles;

  factory _$MapExportContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$MapExportContentImplFromJson(json);

  @override
  final MapExportMapData map;
  final List<CircleExportData> _circles;
  @override
  List<CircleExportData> get circles {
    if (_circles is EqualUnmodifiableListView) return _circles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_circles);
  }

  @override
  String toString() {
    return 'MapExportContent(map: $map, circles: $circles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapExportContentImpl &&
            (identical(other.map, map) || other.map == map) &&
            const DeepCollectionEquality().equals(other._circles, _circles));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    map,
    const DeepCollectionEquality().hash(_circles),
  );

  /// Create a copy of MapExportContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MapExportContentImplCopyWith<_$MapExportContentImpl> get copyWith =>
      __$$MapExportContentImplCopyWithImpl<_$MapExportContentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MapExportContentImplToJson(this);
  }
}

abstract class _MapExportContent implements MapExportContent {
  const factory _MapExportContent({
    required final MapExportMapData map,
    required final List<CircleExportData> circles,
  }) = _$MapExportContentImpl;

  factory _MapExportContent.fromJson(Map<String, dynamic> json) =
      _$MapExportContentImpl.fromJson;

  @override
  MapExportMapData get map;
  @override
  List<CircleExportData> get circles;

  /// Create a copy of MapExportContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MapExportContentImplCopyWith<_$MapExportContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MapExportMapData _$MapExportMapDataFromJson(Map<String, dynamic> json) {
  return _MapExportMapData.fromJson(json);
}

/// @nodoc
mixin _$MapExportMapData {
  String get title => throw _privateConstructorUsedError;
  String get baseImagePath => throw _privateConstructorUsedError;
  String? get thumbnailPath => throw _privateConstructorUsedError;

  /// Serializes this MapExportMapData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MapExportMapData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MapExportMapDataCopyWith<MapExportMapData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapExportMapDataCopyWith<$Res> {
  factory $MapExportMapDataCopyWith(
    MapExportMapData value,
    $Res Function(MapExportMapData) then,
  ) = _$MapExportMapDataCopyWithImpl<$Res, MapExportMapData>;
  @useResult
  $Res call({String title, String baseImagePath, String? thumbnailPath});
}

/// @nodoc
class _$MapExportMapDataCopyWithImpl<$Res, $Val extends MapExportMapData>
    implements $MapExportMapDataCopyWith<$Res> {
  _$MapExportMapDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MapExportMapData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? baseImagePath = null,
    Object? thumbnailPath = freezed,
  }) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            baseImagePath: null == baseImagePath
                ? _value.baseImagePath
                : baseImagePath // ignore: cast_nullable_to_non_nullable
                      as String,
            thumbnailPath: freezed == thumbnailPath
                ? _value.thumbnailPath
                : thumbnailPath // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MapExportMapDataImplCopyWith<$Res>
    implements $MapExportMapDataCopyWith<$Res> {
  factory _$$MapExportMapDataImplCopyWith(
    _$MapExportMapDataImpl value,
    $Res Function(_$MapExportMapDataImpl) then,
  ) = __$$MapExportMapDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String baseImagePath, String? thumbnailPath});
}

/// @nodoc
class __$$MapExportMapDataImplCopyWithImpl<$Res>
    extends _$MapExportMapDataCopyWithImpl<$Res, _$MapExportMapDataImpl>
    implements _$$MapExportMapDataImplCopyWith<$Res> {
  __$$MapExportMapDataImplCopyWithImpl(
    _$MapExportMapDataImpl _value,
    $Res Function(_$MapExportMapDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MapExportMapData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? baseImagePath = null,
    Object? thumbnailPath = freezed,
  }) {
    return _then(
      _$MapExportMapDataImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        baseImagePath: null == baseImagePath
            ? _value.baseImagePath
            : baseImagePath // ignore: cast_nullable_to_non_nullable
                  as String,
        thumbnailPath: freezed == thumbnailPath
            ? _value.thumbnailPath
            : thumbnailPath // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MapExportMapDataImpl implements _MapExportMapData {
  const _$MapExportMapDataImpl({
    required this.title,
    required this.baseImagePath,
    this.thumbnailPath,
  });

  factory _$MapExportMapDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MapExportMapDataImplFromJson(json);

  @override
  final String title;
  @override
  final String baseImagePath;
  @override
  final String? thumbnailPath;

  @override
  String toString() {
    return 'MapExportMapData(title: $title, baseImagePath: $baseImagePath, thumbnailPath: $thumbnailPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapExportMapDataImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.baseImagePath, baseImagePath) ||
                other.baseImagePath == baseImagePath) &&
            (identical(other.thumbnailPath, thumbnailPath) ||
                other.thumbnailPath == thumbnailPath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, title, baseImagePath, thumbnailPath);

  /// Create a copy of MapExportMapData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MapExportMapDataImplCopyWith<_$MapExportMapDataImpl> get copyWith =>
      __$$MapExportMapDataImplCopyWithImpl<_$MapExportMapDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MapExportMapDataImplToJson(this);
  }
}

abstract class _MapExportMapData implements MapExportMapData {
  const factory _MapExportMapData({
    required final String title,
    required final String baseImagePath,
    final String? thumbnailPath,
  }) = _$MapExportMapDataImpl;

  factory _MapExportMapData.fromJson(Map<String, dynamic> json) =
      _$MapExportMapDataImpl.fromJson;

  @override
  String get title;
  @override
  String get baseImagePath;
  @override
  String? get thumbnailPath;

  /// Create a copy of MapExportMapData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MapExportMapDataImplCopyWith<_$MapExportMapDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CircleExportData _$CircleExportDataFromJson(Map<String, dynamic> json) {
  return _CircleExportData.fromJson(json);
}

/// @nodoc
mixin _$CircleExportData {
  int get positionX => throw _privateConstructorUsedError;
  int get positionY => throw _privateConstructorUsedError;
  int get sizeWidth => throw _privateConstructorUsedError;
  int get sizeHeight => throw _privateConstructorUsedError;
  int get pointerX => throw _privateConstructorUsedError;
  int get pointerY => throw _privateConstructorUsedError;
  String get circleName => throw _privateConstructorUsedError;
  String get spaceNo => throw _privateConstructorUsedError;
  String? get imagePath => throw _privateConstructorUsedError;
  String? get menuImagePath => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  int get isDone => throw _privateConstructorUsedError;

  /// Serializes this CircleExportData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CircleExportData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CircleExportDataCopyWith<CircleExportData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CircleExportDataCopyWith<$Res> {
  factory $CircleExportDataCopyWith(
    CircleExportData value,
    $Res Function(CircleExportData) then,
  ) = _$CircleExportDataCopyWithImpl<$Res, CircleExportData>;
  @useResult
  $Res call({
    int positionX,
    int positionY,
    int sizeWidth,
    int sizeHeight,
    int pointerX,
    int pointerY,
    String circleName,
    String spaceNo,
    String? imagePath,
    String? menuImagePath,
    String? note,
    String? description,
    String? color,
    int isDone,
  });
}

/// @nodoc
class _$CircleExportDataCopyWithImpl<$Res, $Val extends CircleExportData>
    implements $CircleExportDataCopyWith<$Res> {
  _$CircleExportDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CircleExportData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? positionX = null,
    Object? positionY = null,
    Object? sizeWidth = null,
    Object? sizeHeight = null,
    Object? pointerX = null,
    Object? pointerY = null,
    Object? circleName = null,
    Object? spaceNo = null,
    Object? imagePath = freezed,
    Object? menuImagePath = freezed,
    Object? note = freezed,
    Object? description = freezed,
    Object? color = freezed,
    Object? isDone = null,
  }) {
    return _then(
      _value.copyWith(
            positionX: null == positionX
                ? _value.positionX
                : positionX // ignore: cast_nullable_to_non_nullable
                      as int,
            positionY: null == positionY
                ? _value.positionY
                : positionY // ignore: cast_nullable_to_non_nullable
                      as int,
            sizeWidth: null == sizeWidth
                ? _value.sizeWidth
                : sizeWidth // ignore: cast_nullable_to_non_nullable
                      as int,
            sizeHeight: null == sizeHeight
                ? _value.sizeHeight
                : sizeHeight // ignore: cast_nullable_to_non_nullable
                      as int,
            pointerX: null == pointerX
                ? _value.pointerX
                : pointerX // ignore: cast_nullable_to_non_nullable
                      as int,
            pointerY: null == pointerY
                ? _value.pointerY
                : pointerY // ignore: cast_nullable_to_non_nullable
                      as int,
            circleName: null == circleName
                ? _value.circleName
                : circleName // ignore: cast_nullable_to_non_nullable
                      as String,
            spaceNo: null == spaceNo
                ? _value.spaceNo
                : spaceNo // ignore: cast_nullable_to_non_nullable
                      as String,
            imagePath: freezed == imagePath
                ? _value.imagePath
                : imagePath // ignore: cast_nullable_to_non_nullable
                      as String?,
            menuImagePath: freezed == menuImagePath
                ? _value.menuImagePath
                : menuImagePath // ignore: cast_nullable_to_non_nullable
                      as String?,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
            isDone: null == isDone
                ? _value.isDone
                : isDone // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CircleExportDataImplCopyWith<$Res>
    implements $CircleExportDataCopyWith<$Res> {
  factory _$$CircleExportDataImplCopyWith(
    _$CircleExportDataImpl value,
    $Res Function(_$CircleExportDataImpl) then,
  ) = __$$CircleExportDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int positionX,
    int positionY,
    int sizeWidth,
    int sizeHeight,
    int pointerX,
    int pointerY,
    String circleName,
    String spaceNo,
    String? imagePath,
    String? menuImagePath,
    String? note,
    String? description,
    String? color,
    int isDone,
  });
}

/// @nodoc
class __$$CircleExportDataImplCopyWithImpl<$Res>
    extends _$CircleExportDataCopyWithImpl<$Res, _$CircleExportDataImpl>
    implements _$$CircleExportDataImplCopyWith<$Res> {
  __$$CircleExportDataImplCopyWithImpl(
    _$CircleExportDataImpl _value,
    $Res Function(_$CircleExportDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CircleExportData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? positionX = null,
    Object? positionY = null,
    Object? sizeWidth = null,
    Object? sizeHeight = null,
    Object? pointerX = null,
    Object? pointerY = null,
    Object? circleName = null,
    Object? spaceNo = null,
    Object? imagePath = freezed,
    Object? menuImagePath = freezed,
    Object? note = freezed,
    Object? description = freezed,
    Object? color = freezed,
    Object? isDone = null,
  }) {
    return _then(
      _$CircleExportDataImpl(
        positionX: null == positionX
            ? _value.positionX
            : positionX // ignore: cast_nullable_to_non_nullable
                  as int,
        positionY: null == positionY
            ? _value.positionY
            : positionY // ignore: cast_nullable_to_non_nullable
                  as int,
        sizeWidth: null == sizeWidth
            ? _value.sizeWidth
            : sizeWidth // ignore: cast_nullable_to_non_nullable
                  as int,
        sizeHeight: null == sizeHeight
            ? _value.sizeHeight
            : sizeHeight // ignore: cast_nullable_to_non_nullable
                  as int,
        pointerX: null == pointerX
            ? _value.pointerX
            : pointerX // ignore: cast_nullable_to_non_nullable
                  as int,
        pointerY: null == pointerY
            ? _value.pointerY
            : pointerY // ignore: cast_nullable_to_non_nullable
                  as int,
        circleName: null == circleName
            ? _value.circleName
            : circleName // ignore: cast_nullable_to_non_nullable
                  as String,
        spaceNo: null == spaceNo
            ? _value.spaceNo
            : spaceNo // ignore: cast_nullable_to_non_nullable
                  as String,
        imagePath: freezed == imagePath
            ? _value.imagePath
            : imagePath // ignore: cast_nullable_to_non_nullable
                  as String?,
        menuImagePath: freezed == menuImagePath
            ? _value.menuImagePath
            : menuImagePath // ignore: cast_nullable_to_non_nullable
                  as String?,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
        isDone: null == isDone
            ? _value.isDone
            : isDone // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CircleExportDataImpl implements _CircleExportData {
  const _$CircleExportDataImpl({
    required this.positionX,
    required this.positionY,
    required this.sizeWidth,
    required this.sizeHeight,
    required this.pointerX,
    required this.pointerY,
    required this.circleName,
    required this.spaceNo,
    this.imagePath,
    this.menuImagePath,
    this.note,
    this.description,
    this.color,
    required this.isDone,
  });

  factory _$CircleExportDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CircleExportDataImplFromJson(json);

  @override
  final int positionX;
  @override
  final int positionY;
  @override
  final int sizeWidth;
  @override
  final int sizeHeight;
  @override
  final int pointerX;
  @override
  final int pointerY;
  @override
  final String circleName;
  @override
  final String spaceNo;
  @override
  final String? imagePath;
  @override
  final String? menuImagePath;
  @override
  final String? note;
  @override
  final String? description;
  @override
  final String? color;
  @override
  final int isDone;

  @override
  String toString() {
    return 'CircleExportData(positionX: $positionX, positionY: $positionY, sizeWidth: $sizeWidth, sizeHeight: $sizeHeight, pointerX: $pointerX, pointerY: $pointerY, circleName: $circleName, spaceNo: $spaceNo, imagePath: $imagePath, menuImagePath: $menuImagePath, note: $note, description: $description, color: $color, isDone: $isDone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CircleExportDataImpl &&
            (identical(other.positionX, positionX) ||
                other.positionX == positionX) &&
            (identical(other.positionY, positionY) ||
                other.positionY == positionY) &&
            (identical(other.sizeWidth, sizeWidth) ||
                other.sizeWidth == sizeWidth) &&
            (identical(other.sizeHeight, sizeHeight) ||
                other.sizeHeight == sizeHeight) &&
            (identical(other.pointerX, pointerX) ||
                other.pointerX == pointerX) &&
            (identical(other.pointerY, pointerY) ||
                other.pointerY == pointerY) &&
            (identical(other.circleName, circleName) ||
                other.circleName == circleName) &&
            (identical(other.spaceNo, spaceNo) || other.spaceNo == spaceNo) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.menuImagePath, menuImagePath) ||
                other.menuImagePath == menuImagePath) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.isDone, isDone) || other.isDone == isDone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    positionX,
    positionY,
    sizeWidth,
    sizeHeight,
    pointerX,
    pointerY,
    circleName,
    spaceNo,
    imagePath,
    menuImagePath,
    note,
    description,
    color,
    isDone,
  );

  /// Create a copy of CircleExportData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CircleExportDataImplCopyWith<_$CircleExportDataImpl> get copyWith =>
      __$$CircleExportDataImplCopyWithImpl<_$CircleExportDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CircleExportDataImplToJson(this);
  }
}

abstract class _CircleExportData implements CircleExportData {
  const factory _CircleExportData({
    required final int positionX,
    required final int positionY,
    required final int sizeWidth,
    required final int sizeHeight,
    required final int pointerX,
    required final int pointerY,
    required final String circleName,
    required final String spaceNo,
    final String? imagePath,
    final String? menuImagePath,
    final String? note,
    final String? description,
    final String? color,
    required final int isDone,
  }) = _$CircleExportDataImpl;

  factory _CircleExportData.fromJson(Map<String, dynamic> json) =
      _$CircleExportDataImpl.fromJson;

  @override
  int get positionX;
  @override
  int get positionY;
  @override
  int get sizeWidth;
  @override
  int get sizeHeight;
  @override
  int get pointerX;
  @override
  int get pointerY;
  @override
  String get circleName;
  @override
  String get spaceNo;
  @override
  String? get imagePath;
  @override
  String? get menuImagePath;
  @override
  String? get note;
  @override
  String? get description;
  @override
  String? get color;
  @override
  int get isDone;

  /// Create a copy of CircleExportData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CircleExportDataImplCopyWith<_$CircleExportDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
