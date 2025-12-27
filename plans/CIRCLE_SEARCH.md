# CircleListScreen Search Feature Implementation Plan

## Overview
Add a search feature to CircleListScreen following MapListScreen's architectural pattern with SQL-level filtering and AppBar title-based TextField search UI.

## Requirements
✓ Search functionality similar to MapListScreen
✓ Works alongside existing sort and filter features
✓ AppBar title becomes a TextField (like MapListScreen)
✓ SQL-level filtering (not in-memory)
✓ Search by circle name, space number, and map title

---

## Critical Files to Modify

### 1. **lib/states/circle_list_state.dart**
Add `searchQuery` field to CircleListState:
```dart
@freezed
class CircleListState with _$CircleListState {
  const factory CircleListState({
    @Default([]) List<CircleWithMapTitle> circles,
    @Default(SortType.mapName) SortType sortType,
    @Default(SortDirection.asc) SortDirection sortDirection,
    @Default([]) List<int> selectedMapIds,
    @Default('') String searchQuery,  // NEW - empty string means no search active
  }) = _CircleListState;
}
```

### 2. **lib/repositories/circle_repository.dart**
Add `searchCirclesSorted()` method (similar to existing getAllCirclesSorted):

**Method signature:**
```dart
Future<List<CircleWithMapTitle>> searchCirclesSorted({
  required String searchQuery,
  required String sortType,
  required String sortDirection,
  List<int>? mapIds,
  int? offset,
  int? limit,
}) async
```

**SQL Query Logic:**
```sql
SELECT c.*, m.title AS mapTitle
FROM circle_detail c
LEFT JOIN map_detail m ON c.mapId = m.mapId
WHERE (
  LOWER(c.circleName) LIKE LOWER(?) OR
  LOWER(c.spaceNo) LIKE LOWER(?) OR
  LOWER(m.title) LIKE LOWER(?)
)
[AND c.mapId IN (?, ?, ...)]  -- If mapIds provided
ORDER BY [existing sort logic from getAllCirclesSorted]
[LIMIT ? [OFFSET ?]]
```

**Key implementation details:**
- Normalize query: `query.trim()`
- If normalized query is empty: return `getAllCirclesSorted(...)` for consistency
- Search pattern: `%$normalizedQuery%` for each LIKE clause
- Combine search (OR) + map filter (AND) in WHERE clause
- Reuse exact ORDER BY logic from getAllCirclesSorted (lines 76-89)
- Same error handling pattern (DatabaseException → AppException)

### 3. **lib/viewModels/circle_list_view_model.dart**
Update ViewModel to manage search state:

**Add new methods:**
```dart
Future<void> searchCircles(String query) async {
  state = const AsyncValue.loading();
  final currentState = state.value;

  state = await AsyncValue.guard(() async {
    final circles = await ref.read(circleRepositoryProvider).searchCirclesSorted(
      searchQuery: query,
      sortType: currentState?.sortType.displayName ?? 'mapName',
      sortDirection: currentState?.sortDirection.displayName ?? 'asc',
      mapIds: currentState?.selectedMapIds.isEmpty ?? true
          ? null
          : currentState?.selectedMapIds,
    );

    return CircleListState(
      circles: circles,
      sortType: currentState?.sortType ?? SortType.mapName,
      sortDirection: currentState?.sortDirection ?? SortDirection.asc,
      selectedMapIds: currentState?.selectedMapIds ?? [],
      searchQuery: query,
    );
  });
}

void clearSearch() {
  searchCircles('');
}
```

**Modify existing methods to preserve searchQuery:**
- `_loadCircles()`: Add `String searchQuery` parameter, call `searchCirclesSorted()` instead of `getAllCirclesSorted()`
- `build()`: Pass empty string `''` as searchQuery to `_loadCircles()`
- `setSort()`: Preserve `currentState.searchQuery` when calling `_loadCircles()`
- `setMapFilter()`: Preserve `currentState.searchQuery` when calling `_loadCircles()`
- `refresh()`: Preserve `currentState.searchQuery` when calling `_loadCircles()`
- `removeCircle()`: Preserve `currentState.searchQuery` when calling `_loadCircles()`

### 4. **lib/views/screens/circle_list_screen.dart**
Convert from ConsumerWidget to ConsumerStatefulWidget and add search UI:

**Widget structure changes:**
```dart
class CircleListScreen extends ConsumerStatefulWidget {
  const CircleListScreen({super.key});
  @override
  ConsumerState<CircleListScreen> createState() => _CircleListScreenState();
}

class _CircleListScreenState extends ConsumerState<CircleListScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ... build method
}
```

**AppBar title replacement:**
```dart
AppBar(
  title: Padding(
    padding: const EdgeInsets.only(left: 8),
    child: TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'サークルを検索',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _clearSearch,
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: InputBorder.none,
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: _onSearchSubmitted,
      onChanged: (value) {
        setState(() {}); // Update clear button visibility
      },
    ),
  ),
  actions: [
    // Existing filter button (IconButton with filter_list icon)
    // Existing sort PopupMenuButton
  ],
)
```

**Callback methods:**
```dart
void _onSearchSubmitted(String query) {
  ref.read(circleListViewModelProvider.notifier).searchCircles(query);
}

void _clearSearch() {
  _searchController.clear();
  ref.read(circleListViewModelProvider.notifier).clearSearch();
}
```

---

## Implementation Sequence

### Phase 1: Foundation (State + Code Generation)
1. Add `searchQuery` field to CircleListState
2. Run `dart run build_runner build --delete-conflicting-outputs`
3. Verify `.freezed.dart` file updated successfully

### Phase 2: Data Layer (Repository)
4. Add `searchCirclesSorted()` method to CircleRepository
5. Implement SQL query with multi-field search (circleName OR spaceNo OR mapTitle)
6. Combine with map filter using AND clause
7. Reuse existing ORDER BY logic from getAllCirclesSorted
8. Handle empty query by calling getAllCirclesSorted

### Phase 3: Business Logic (ViewModel)
9. Modify `_loadCircles()` to accept `searchQuery` parameter
10. Update `_loadCircles()` to call `searchCirclesSorted()` instead of `getAllCirclesSorted()`
11. Add `searchCircles()` and `clearSearch()` methods
12. Update all existing methods (build, setSort, setMapFilter, refresh, removeCircle) to preserve searchQuery
13. Run `dart run build_runner build --delete-conflicting-outputs`

### Phase 4: UI Layer (Screen)
14. Convert CircleListScreen to ConsumerStatefulWidget
15. Add TextEditingController lifecycle (initState, dispose)
16. Replace AppBar title Text with TextField
17. Add search/clear callback methods
18. Test basic functionality

### Phase 5: Polish & Testing
19. Add empty search results UI (optional)
20. Test all combinations: search + filter + sort
21. Test edge cases: empty query, no results, special characters
22. Verify state preservation after delete/refresh

---

## SQL Query Example

**With search and map filter:**
```sql
SELECT c.*, m.title AS mapTitle
FROM circle_detail c
LEFT JOIN map_detail m ON c.mapId = m.mapId
WHERE (
  LOWER(c.circleName) LIKE LOWER('%東方%') OR
  LOWER(c.spaceNo) LIKE LOWER('%東方%') OR
  LOWER(m.title) LIKE LOWER('%東方%')
)
AND c.mapId IN (1, 3, 5)
ORDER BY CASE WHEN m.title IS NULL THEN 1 ELSE 0 END, m.title ASC
```

**With search only (no map filter):**
```sql
SELECT c.*, m.title AS mapTitle
FROM circle_detail c
LEFT JOIN map_detail m ON c.mapId = m.mapId
WHERE (
  LOWER(c.circleName) LIKE LOWER('%A01%') OR
  LOWER(c.spaceNo) LIKE LOWER('%A01%') OR
  LOWER(m.title) LIKE LOWER('%A01%')
)
ORDER BY CASE WHEN c.spaceNo IS NULL OR c.spaceNo = '' THEN 1 ELSE 0 END, c.spaceNo ASC
```

---

## Design Principles

1. **Pattern Consistency**: Follow MapListScreen's exact architecture (StatefulWidget + TextEditingController + searchQuery in state)
2. **SQL-Level Filtering**: All filtering at database level for performance (LIKE with LOWER() for case-insensitive)
3. **State Preservation**: Maintain searchQuery through all operations (sort, filter, delete, refresh)
4. **Feature Combination**: Search works seamlessly with existing sort (mapName/spaceNo, asc/desc) and filter (selectedMapIds)
5. **Empty Query Handling**: Empty search = show all results with current filters/sorts applied

---

## Reference Files (MapListScreen Pattern)
- **lib/views/screens/map_list_screen.dart** - TextField in AppBar, TextEditingController lifecycle
- **lib/viewModels/map_list_view_model.dart** - searchMaps() and clearSearch() methods
- **lib/repositories/map_repository.dart** - searchMapsByTitle() SQL implementation
- **lib/states/map_list_state.dart** - searchQuery field in state

---

## Testing Checklist

**Basic Search:**
- [ ] Search by circleName (partial match, case-insensitive)
- [ ] Search by spaceNo (partial match, case-insensitive)
- [ ] Search by mapTitle (partial match, case-insensitive)
- [ ] Empty search returns all circles
- [ ] Clear button functionality

**Feature Combinations:**
- [ ] Search + map filter (single map)
- [ ] Search + map filter (multiple maps)
- [ ] Search + sort by mapName (asc/desc)
- [ ] Search + sort by spaceNo (asc/desc)
- [ ] Search + filter + sort (all three combined)

**State Preservation:**
- [ ] Delete circle preserves search query
- [ ] Change sort preserves search query
- [ ] Change filter preserves search query
- [ ] Refresh preserves search query

**Edge Cases:**
- [ ] Search with no results
- [ ] Special characters in query
- [ ] Whitespace handling (trim)
- [ ] TextEditingController disposal on screen dismiss
