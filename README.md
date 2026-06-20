# Multi Profile Workspace Engine

A production-ready Flutter application showcasing **Clean Architecture**, **Offline-First Design**, and **Enterprise Patterns**.

## ✨ Features Implemented

### 1. **Local Profiles & Todos** ✅
- **Multiple Profiles**: Personal, Work, Corporate, Creative (easily extensible)
- **Profile-Specific Data**: Each profile has isolated todo lists
- **Offline-First**: Full Hive persistence with no server required
- **CRUD Operations**: Create, read, update, delete todos
- **Instant UI Updates**: Profile switching refreshes UI automatically
- **Data Isolation**: Complete separation between profiles

**Technologies**: `hive`, `hive_flutter`, `flutter_bloc`

### 2. **Global Events Feed** ✅
- **Remote Data Source**: Fetches from JSONPlaceholder Photos endpoint
- **Domain Model**: `GlobalEvent` entity with id, title, description, imageUrl, eventDate
- **Cached Images**: `cached_network_image` for optimized image loading
- **Read-Only Access**: Events feed displays all events in list view
- **Event Details Screen**: Navigate to detailed event view with full image and metadata
- **Error Handling**: Graceful error states with retry capability

**Technologies**: `retrofit`, `cached_network_image`, `go_router`, `flutter_bloc`

### 3. **Navigation & Security** ✅

#### Routing
- **Go Router Integration**: Type-safe navigation with nested routes
- **Required Screens**:
  - Workspace Dashboard (home)
  - Todo Manager (`/todos`)
  - Global Events Feed (`/events`)
  - Event Details (`/event/:id`)

#### Environment Management
- **AppConfig**: Centralized configuration with strongly-typed constants
- **Feature Flags**: Runtime feature toggles
- **Secure Storage Keys**: Organized configuration for sensitive data

#### Networking & Auth
- **Authorization Interceptor**: Automatically injects Bearer tokens
- **Secure Token Service**: Manages auth tokens in `flutter_secure_storage`
- **Dio Client**: Configured with timeouts, error handling, interceptors
- **Custom Exception Handling**: Maps API errors to domain exceptions

**Technologies**: `go_router`, `dio`, `flutter_secure_storage`, `logger`

### 4. **Architecture** ✅
- **Clean Architecture**: Domain → Data → Presentation layers
- **Repository Pattern**: Abstracted data access
- **Dependency Injection**: GetIt service locator
- **State Management**: Flutter Bloc for predictable state
- **Immutable Models**: Equatable for value equality
- **Feature-Based Structure**:
  ```
  lib/
  ├── core/
  │   ├── config/
  │   ├── exceptions/
  │   ├── failures/
  │   ├── logger/
  │   ├── network/
  │   ├── routing/
  │   ├── security/
  │   └── typedefs/
  ├── features/
  │   ├── profiles/
  │   ├── todos/
  │   └── global_events/
  ├── injection/
  └── main.dart
  ```

## 📦 Dependencies

```yaml
# State Management
flutter_bloc: ^9.1.1
equatable: ^2.0.5

# Service Locator & DI
get_it: ^9.2.1

# Networking
dio: ^5.2.1

# Persistence
hive: ^2.2.3
hive_flutter: ^1.1.0

# UI & Navigation
go_router: ^17.3.0
cached_network_image: ^3.2.4

# Security
flutter_secure_storage: ^10.3.1

# Utilities
logger: ^2.7.0
uuid: ^4.3.0
connectivity_plus: ^7.1.1
```

## 🚀 Getting Started

### Prerequisites
- Flutter 3.0+
- Dart 3.0+

### Installation

```bash
flutter pub get
flutter run
```

## 📱 App Structure

### Dashboard
- Home screen with profile switcher
- Quick access to Todos and Events
- Profile-aware context switching

### Profiles Module
- Switch between profiles instantly
- Profile-specific data loading
- Clean UI with chip-based selector

### Todos Module
- List all todos for active profile
- Add new todos
- Toggle completion status
- Delete todos
- Offline persistence

### Global Events Module
- Browse events from external API
- Cached image loading
- Event details with full metadata
- Pull-to-refresh capability
- Error recovery

## 🔐 Security

### Token Management
- Tokens stored in `flutter_secure_storage`
- Automatic injection via `AuthInterceptor`
- Bearer token scheme support

### Error Handling
- Custom exception hierarchy
- Domain-level error mapping
- Network error detection

## 🏗️ Architecture Patterns

### Repository Pattern
```dart
abstract class Repository {
  Future<T> getData();
}

class RepositoryImpl implements Repository {
  // Implementation with caching, error handling, etc.
}
```

### Bloc Pattern
```dart
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  // Event handling with proper state emissions
}
```

## 🧪 Testing

Run tests:
```bash
flutter test
```
