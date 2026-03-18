# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test
flutter test test/path_to_specific_test.dart

# Static analysis
flutter analyze

# Build for specific platforms
flutter build apk      # Android
flutter build ios      # iOS
flutter build web      # Web
```

## Architecture Overview

**TurfVolt** is a fitness tracking Flutter application backed by Appwrite. The codebase follows a provider-driven architecture with separation of concerns:

### Core (`lib/core/`)
- `app_router.dart` - go_router-based navigation with a ShellRoute for authenticated main screens
- `app_theme.dart` / `app_colors.dart` / `app_text_styles.dart` - Design system tokens
- `constants.dart` - Appwrite configuration (endpoint, database ID, collection IDs) and built-in exercises
- `app_logger.dart` - Centralized logging

### State Management (`lib/providers/`)
Four ChangeNotifier providers manage app state:
- `auth_provider.dart` - User session state (login/register/logout via AuthService)
- `plan_provider.dart` - Workout plans CRUD
- `log_provider.dart` - Workout logs
- `exercise_provider.dart` - Exercise catalog (built-in + custom)

### Services (`lib/services/`)
- `appwrite_service.dart` - Appwrite client initialization + DatabaseService for CRUD operations on users/plans/logs/exercises collections
- `auth_service.dart` - Authentication wrapper (email/password sessions, cookie-based auth)

### Models (`lib/models/`)
- `plan_model.dart`, `log_model.dart`, `exercise_model.dart`, `set_entry_model.dart` - Data structures matching Appwrite document schemas

### Screens (`lib/screens/`)
- Auth flow: `splash_screen.dart` → `login_screen.dart` / `register_screen.dart`
- Main app (ShellRoute): `home_screen.dart`, `library_screen.dart`, `plans_screen.dart`, `log_screen.dart`, `reports_screen.dart`

### Widgets (`lib/widgets/`)
Reusable UI components: `app_card.dart`, `neumorphic_card.dart`, `glass_panel.dart`, `lime_button.dart`, `exercise_row.dart`, `muscle_chip.dart`, `stat_card.dart`, `consistency_matrix.dart`, `app_toast.dart`

## Key Patterns

1. **Provider initialization**: `main.dart` creates all providers upfront; AuthProvider initializes synchronously for UI, then runs async `init()` in background to avoid blocking first frame
2. **Appwrite session handling**: Uses cookie-based sessions (no JWT on client); `AppwriteService.reset()` recreates client to clear headers on login/logout
3. **Error handling**: AuthService wraps Appwrite exceptions with user-friendly messages (network issues, timeouts)
4. **Data flow**: Services → Providers → Screens (via Provider.of or Consumer)
