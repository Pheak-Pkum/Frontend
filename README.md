# Matching Words mobile app

Flutter application for Android and iOS.

## Structure

- `lib/app/` - app shell and theme
- `lib/core/` - shared configuration
- `lib/features/levels/` - level models, API access, and level selection
- `lib/features/game/` - game screen entry point
- `test/` - widget tests

Run with `flutter run`. The API URL can be set with `--dart-define=API_BASE_URL=...`; see the repository root README for local backend details.
