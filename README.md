# Multi Profile Workspace Engine

A production-oriented Flutter app skeleton demonstrating Clean Architecture, multi-profile isolation, offline-first design, and DI. This workspace contains core services, profile and todo features, and a minimal UI to switch profiles and manage todos per profile.

Setup

1. Ensure Flutter 3.44+ and Dart 3 are installed.
2. From project root run:

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Run the app:

```bash
flutter run
```

Notes

- Hive boxes are created per profile (e.g., `personal_todos`).
- Dependency injection is in `lib/injection/injection.dart` using `GetIt`.
- This scaffold includes NetworkService, AuthInterceptor, LoggerService, Profile and Todo features.

Testing

```bash
flutter test
```
# machine_taskk

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
