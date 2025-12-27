enum SortType { mapName, spaceNo }

enum SortDirection { asc, desc }

extension SortTypeExtension on SortType {
  String get displayName {
    switch (this) {
      case SortType.mapName:
        return 'mapName';
      case SortType.spaceNo:
        return 'spaceNo';
    }
  }
}

extension SortDirectionExtension on SortDirection {
  String get displayName {
    switch (this) {
      case SortDirection.asc:
        return 'asc';
      case SortDirection.desc:
        return 'desc';
    }
  }
}
