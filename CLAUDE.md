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
- **ViewModels** (`lib/viewModels/`): Annotated with `@riverpod`, extending generated base classes (e.g., `MapDetailViewModel extends _$MapDetailViewModel`)
- **Repositories** (`lib/repositories/`): Data access layer, also using `@riverpod` for provider generation
- **States** (`lib/states/`): Immutable state classes using `@freezed`
- All `.g.dart` files are generated - never edit manually

### Data Layer

**Database**: SQLite via `sqflite` package
- `DatabaseHelper` (lib/database_helper.dart): Singleton managing database initialization, schema, and migrations
- Current version: 3
- Tables:
  - `map_detail`: Stores map information (mapId, title, baseImagePath)
  - `circle_detail`: Stores circle/booth markers with positions, images, metadata, and isDone status

**Models** (`lib/models/`):
- `MapDetail` and `CircleDetail`: Domain models using `@freezed` for immutability and JSON serialization
- All `.freezed.dart` and `.g.dart` files are code-generated

**Repositories** (`lib/repositories/`):
- `MapRepository`: CRUD operations for maps
- `CircleRepository`: CRUD operations for circles, including position/pointer updates, image paths, and individual field updates (circleName, spaceNo, note, description, isDone)

### UI Architecture

**Navigation**: `go_router` with nested navigation
- `AppRouter` (lib/app_router.dart): Riverpod-managed router with `StatefulShellRoute.indexedStack` for bottom navigation
- Routes:
  - `/mapList`: Map list screen (used by both bottom nav tabs)
  - `/mapList/:mapId`: Map detail screen with interactive markers

**Screens** (`lib/views/screens/`):
- `MapListScreen`: Displays all maps, allows adding new maps via image picker
- `MapDetailScreen`: Interactive map view with `InteractiveViewer`, supports:
  - Long-press to add new circles
  - Tap circles to show bottom sheet with details
  - Drag circles to reposition
  - Drag pointer line endpoints to adjust

**Widgets** (`lib/views/widgets/`):
- `CircleBox`: Displays individual circle marker with optional image, color overlay, and checkmark for isDone status
- `CircleBottomSheet`: Modal bottom sheet for viewing/editing circle details (images, name, space number, note, description, isDone toggle)
- `DraggableLine`: Pointer line from circle to target location on map
- `EditableImage`: Long-press to edit images (circle image and menu image)
- `EditableLabel`: Long-press to edit text fields inline
- `PixelPositioned`: Custom positioned widget that converts pixel coordinates to display coordinates accounting for image scaling (BoxFit.contain)

**Key UI Patterns**:
- Long-press activation for editing mode (images, labels, adding circles)
- `TransformationController` manages zoom/pan state in `MapDetailScreen`
- Coordinate conversion between original image pixels and display pixels is critical for accurate marker positioning

### Image Handling

Images are stored locally using `path_provider`:
- Base map images: Selected via `image_picker`, copied to app's documents directory
- Circle images: Optional image per circle
- Menu images: Secondary image per circle (e.g., for product/menu photos)

All image paths are stored as strings in the database and displayed using `File` widgets.

## Key Implementation Details

### Coordinate System
The app maintains two coordinate systems:
1. **Original image coordinates**: Stored in database (positionX/Y, pointerX/Y, sizeWidth/Height)
2. **Display coordinates**: Calculated at runtime based on actual image display size with BoxFit.contain

`PixelPositioned` widget handles this conversion transparently.

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
