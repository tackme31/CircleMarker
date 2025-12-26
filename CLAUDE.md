# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Circle Marker is a Flutter application for managing event maps (such as doujinshi convention floor layouts) with interactive circle markers. Users can upload map images, place markers on specific locations (circles/booths), and track information about each circle including images, descriptions, and completion status.

## Development Commands

### Code Generation
The project uses code generation for Riverpod, Freezed, and JSON serialization:

```bash
# Generate all code (run after modifying @riverpod, @freezed, or @JsonSerializable classes)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for continuous generation during development
dart run build_runner watch --delete-conflicting-outputs
```

### Running the App
```bash
# Run on connected device/emulator
flutter run

# Run on specific device
flutter run -d <device-id>
```

### Testing and Linting
```bash
# Run static analysis
flutter analyze

# Run tests
flutter test

# Run a specific test file
flutter test test/widget_test.dart
```

### Dependencies
```bash
# Install dependencies
flutter pub get

# Update dependencies
flutter pub upgrade
```

### Icon Generation
```bash
# Generate launcher icons from assets/icons/app_icon.png
flutter pub run flutter_launcher_icons
```

## Architecture

### State Management: Riverpod + Code Generation

The app uses **hooks_riverpod** with code generation (`riverpod_annotation`, `riverpod_generator`):
- **ViewModels** (`lib/viewModels/`): Annotated with `@riverpod`, extending generated base classes
  - `MapListViewModel`: Manages map list state
  - `MapDetailViewModel`: Manages map detail screen state
  - `CircleListViewModel`: Manages circle list with filtering and sorting
  - `CircleViewModel`: **Riverpod Family pattern** - manages individual circle state for optimal performance (only the updated circle re-renders)
  - `MapExportViewModel`: Manages map import/export operations
  - `MarkdownOutputViewModel`: Generates markdown output
- **Repositories** (`lib/repositories/`): Data access layer, also using `@riverpod` for provider generation
- **States** (`lib/states/`): Immutable state classes using `@freezed`
  - `MapListState`, `MapDetailState`, `CircleListState`, etc.
- All `.g.dart` and `.freezed.dart` files are code-generated - never edit manually

#### Riverpod Family Pattern
`CircleViewModel` uses the Family pattern (`circleViewModelProvider(circleId)`) to manage individual circles independently. This ensures that when one circle is updated, only that specific circle widget rebuilds, rather than the entire list.

### Data Layer

**Database**: SQLite via `sqflite` package
- `DatabaseHelper` (lib/database_helper.dart): Singleton managing database initialization, schema, and migrations
- Current version: 4
- Tables:
  - `map_detail`: Stores map information (mapId, title, baseImagePath, thumbnailPath)
  - `circle_detail`: Stores circle/booth markers with positions, images, metadata, and isDone status

**Models** (`lib/models/`):
- `MapDetail` and `CircleDetail`: Domain models using `@freezed` for immutability and JSON serialization
- `MapExportData`: Data model for map import/export functionality
- `CircleWithMapTitle`: Extended circle model with map title information
- `MapImagePaths`: Holds original and thumbnail image paths
- All `.freezed.dart` and `.g.dart` files are code-generated

**Repositories** (`lib/repositories/`):
- `MapRepository`: CRUD operations for maps
- `CircleRepository`: CRUD operations for circles, including position/pointer updates, image paths, and individual field updates (circleName, spaceNo, note, description, isDone)
- `MapExportRepository`: Handles map import/export as ZIP archives with JSON manifest
- `MarkdownOutputRepository`: Generates markdown output for maps and circles
- `ImageRepository`: Manages image saving and compression (thumbnails for maps, compression for circle images)

### UI Architecture

**Navigation**: `go_router` with nested navigation
- `AppRouter` (lib/app_router.dart): Riverpod-managed router with `StatefulShellRoute.indexedStack` for bottom navigation
- Routes:
  - `/mapList`: Map list screen (map management tab)
  - `/circleList`: Circle list screen with filtering and sorting (circle list tab)
  - `/mapList/:mapId`: Map detail screen with interactive markers (supports `?circleId=N` query parameter to pre-select a circle)

**Screens** (`lib/views/screens/`):
- `MapListScreen`: Displays all maps with thumbnails, allows adding new maps via image picker, supports map import/export and markdown output
- `MapDetailScreen`: Interactive map view with `InteractiveViewer`, supports:
  - Long-press to add new circles
  - Tap circles to show bottom sheet with details
  - Drag circles to reposition
  - Drag pointer line endpoints to adjust
  - Initial circle selection via route parameter
- `CircleListScreen`: Displays all circles across all maps with filtering (by map) and sorting (by map name or space number, ascending/descending)

**Widgets** (`lib/views/widgets/`):
- `CircleBox`: Displays individual circle marker with optional image, color overlay, and checkmark for isDone status
- `CircleMarker`: Wrapper widget that combines CircleBox with DraggableLine, used in MapDetailScreen
- `CircleBottomSheet`: Modal bottom sheet for viewing/editing circle details (images, name, space number, note, description, isDone toggle, delete option on map detail screen)
- `DraggableLine`: Pointer line from circle to target location on map, refactored to use CoordinateConverter
- `EditableImage`: Long-press to edit images (circle image and menu image)
- `EditableLabel`: Long-press to edit text fields inline
- `PixelPositioned`: Custom positioned widget that converts pixel coordinates to display coordinates using CoordinateConverter
- `MapExportDialog`: Dialog for map import/export operations

**Key UI Patterns**:
- Long-press activation for editing mode (images, labels, adding circles)
- `TransformationController` manages zoom/pan state in `MapDetailScreen`
- Coordinate conversion between original image pixels and display pixels is critical for accurate marker positioning

### Image Handling

Images are stored locally using `path_provider` with automatic compression via `flutter_image_compress`:
- **Base map images**: Selected via `image_picker`, stored with both original and thumbnail versions
  - Original: Saved to `{appDir}/maps/` for high-quality viewing
  - Thumbnail: Generated at 512x512 max resolution (85% quality) for list views to reduce memory usage
- **Circle images**: Optional image per circle, compressed to 300x300 max (90% quality)
- **Menu images**: Secondary image per circle (e.g., for product/menu photos)
- All image paths are stored as strings in the database
- `ImageRepository` handles all image saving and compression operations

This thumbnail approach significantly reduces memory usage when displaying map lists.

## Key Implementation Details

### Coordinate System
The app maintains two coordinate systems:
1. **Original image coordinates**: Stored in database (positionX/Y, pointerX/Y, sizeWidth/Height)
2. **Display coordinates**: Calculated at runtime based on actual image display size with BoxFit.contain

**CoordinateConverter** (`lib/utils/coordinate_converter.dart`): Pure function class that handles all coordinate conversions
- `pixelToDisplay()`: Converts image pixels to display coordinates
- `displayToPixel()`: Converts display coordinates to image pixels
- `sizePixelToDisplay()` / `sizeDisplayToPixel()`: Size conversions
- Used by `PixelPositioned` and `DraggableLine` for accurate positioning

This centralized conversion logic is thoroughly tested (see `test/utils/coordinate_converter_test.dart`).

### Database Migrations
When adding new columns to tables:
1. Increment version number in `DatabaseHelper.database` getter
2. Add migration logic in `onUpgrade` callback
3. Update `_onCreate` to include new columns for fresh installs
4. Update corresponding model classes and regenerate code

### Color and Status Tracking
Circles support:
- Custom color overlay (stored as TEXT in database)
- `isDone` boolean flag (INTEGER with default 0) for completion tracking

### Error Handling
Centralized error handling via custom exceptions (`lib/exceptions/app_exceptions.dart`):
- `DatabaseException`: Database operation failures
- `ImageOperationException`: Image processing errors
- `FileOperationException`: File I/O errors
- `ErrorHandler` (`lib/utils/error_handler.dart`): Utility for consistent error handling patterns

### Import/Export
Maps can be exported as ZIP archives containing:
- `manifest.json`: Metadata with map and circle information
- `map_image.*`: Base map image file
- `circles/`: Directory containing circle and menu images

Export files are saved to the Downloads folder with sanitized filenames. Import validates the manifest structure and copies all files to the app's document directory.

## Dependencies of Note

- `freezed` + `freezed_annotation`: Immutable models with union types
- `json_serializable`: JSON serialization for models
- `riverpod_annotation` + `riverpod_generator`: State management with code generation
- `hooks_riverpod`: Riverpod with React-like hooks
- `go_router`: Declarative routing
- `sqflite`: SQLite database
- `image_picker`: Select images from gallery/camera
- `photo_view`: Zoomable image viewer
- `flutter_linkify` + `url_launcher`: Clickable links in descriptions
- `gap`: Spacing widgets
- `flutter_image_compress`: Image compression for thumbnails and circle images
- `archive`: ZIP file creation and extraction for import/export
- `file_picker`: File selection for import operations
- `share_plus`: Sharing exported files

## Testing

The project includes tests for critical components:
- `test/utils/coordinate_converter_test.dart`: Coordinate conversion logic tests
- `test/utils/error_handler_test.dart`: Error handling tests
- `test/widgets/circle_box_test.dart`: CircleBox widget tests

Run tests with `flutter test` to ensure coordinate conversion and core widget functionality remain correct.
