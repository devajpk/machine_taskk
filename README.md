# Multi Profile Workspace Engine

A production-ready Flutter application demonstrating **Clean Architecture**, **Offline-First Design**, **State Management with BLoC**, **Firebase Analytics**, and **Enterprise-Grade Development Practices**.

---

# ✨ Features

## 1. Local Profiles & Todos

### Profile Management

* Multiple workspace profiles:

  * Personal
  * Work
  * Corporate
  * Creative
* Easy to extend with additional profiles
* Instant profile switching
* Profile-aware user experience

### Todo Management

* Create todos
* Update todos
* Mark todos as completed
* Delete todos
* Profile-specific todo storage
* Offline persistence using Hive

### Offline First

* No backend required for todos
* All data stored locally
* Fast startup and access
* Persistent storage across app restarts

### Technologies

* Hive
* Hive Flutter
* Flutter Bloc

---

## 2. Global Events Feed

### Remote Data Integration

* Fetches events from JSONPlaceholder Photos API
* Repository-based architecture
* Clean separation of concerns

### Event Features

* View all events
* Pull-to-refresh
* Event details page
* Cached image loading
* Read-only event feed

### Event Model

Each event contains:

* ID
* Title
* Description
* Image URL
* Event Date

### Error Handling

* Loading states
* Empty states
* Retry support
* Graceful failure handling

### Technologies

* Dio
* Cached Network Image
* Flutter Bloc
* Go Router

---

## 3. Navigation & Routing

### Implemented Routes

| Screen        | Route      |
| ------------- | ---------- |
| Dashboard     | /          |
| Todo Manager  | /todos     |
| Global Events | /events    |
| Event Details | /event/:id |

### Features

* Go Router integration
* Type-safe navigation
* Deep linking ready
* Route parameter support

### Technologies

* go_router

---

## 4. Security & Networking

### Secure Storage

* Token management using Flutter Secure Storage
* Persistent secure credentials
* Protected sensitive information

### Authorization Interceptor

* Automatic Bearer Token injection
* Centralized request handling
* Easy authentication extension

### Network Layer

* Dio client
* Timeout configuration
* Error mapping
* Centralized API handling

### Features

* Network connectivity checks
* Exception mapping
* Repository abstraction
* Clean API communication

### Technologies

* Dio
* Flutter Secure Storage
* Connectivity Plus

---

## 5. Analytics & Crash Reporting

### Firebase Analytics

Custom analytics event tracking implemented.

#### Event Name

```text
profile_swapped
```

#### Trigger

Whenever the active workspace profile changes.

Example:

```text
Personal → Work
Corporate → Creative
Creative → Personal
```

#### Event Parameters

```json
{
  "from_profile": "personal",
  "to_profile": "work"
}
```

#### Example Log

```text
✅ Firebase Analytics Event Sent: corporate -> work
💡 Logged profile_swapped: corporate -> work
```

### Firebase Crashlytics

Crash reporting service implemented.

#### Features

* Global Flutter error handling
* Platform error handling
* Error recording service
* Stub fallback support when Firebase is unavailable

#### Example Log

```text
💡 Crashlytics recorded error
```

### Technologies

* firebase_core
* firebase_analytics
* firebase_crashlytics

---

## 6. Clean Architecture

The application follows Clean Architecture principles.

```text
lib/
├── core/
│   ├── analytics/
│   ├── crash_lytics/
│   ├── config/
│   ├── exceptions/
│   ├── failures/
│   ├── logger/
│   ├── network/
│   ├── routing/
│   ├── security/
│   └── typedefs/
│
├── features/
├── ├── dashboard/
│   ├── profiles/
│   ├── todos/
│   └── global_events/
│
├── injection/
│
└── main.dart
```

### Layers

#### Domain Layer

* Entities
* Repository Contracts
* Business Rules

#### Data Layer

* Repository Implementations
* Remote Data Sources
* Local Data Sources

#### Presentation Layer

* Screens
* Widgets
* BLoC State Management

---

## 7. Dependency Injection

Service Locator pattern implemented using GetIt.

### Registered Services

* LoggerService
* AnalyticsService
* CrashlyticsService
* NetworkService
* SecureTokenService
* GlobalEventService
* GlobalEventRepository

### Technologies

* get_it

---

## 8. State Management

Implemented using Flutter Bloc.

### Features

* Predictable state flow
* Event-driven architecture
* Easy testing
* Clear separation of UI and business logic

### Blocs

* ProfileBloc
* GlobalEventBloc

### Technologies

* flutter_bloc
* equatable

---

# 📦 Dependencies

```yaml
dependencies:
  flutter_bloc: ^9.1.1
  equatable: ^2.0.5

  get_it: ^9.2.1

  dio: ^5.2.1

  hive: ^2.2.3
  hive_flutter: ^1.1.0

  go_router: ^17.3.0

  cached_network_image: ^3.2.4

  flutter_secure_storage: ^10.3.1

  connectivity_plus: ^7.1.1

  logger: ^2.7.0

  uuid: ^4.3.0

  firebase_core: ^4.0.0
  firebase_analytics: ^12.0.0
  firebase_crashlytics: ^5.0.0
```

---

# 🚀 Getting Started

## Prerequisites

* Flutter 3.0+
* Dart 3.0+

Verify installation:

```bash
flutter doctor
```

---

## Installation

Clone the repository:

```bash
git clone <repository-url>
```

Navigate to project:

```bash
cd multi_profile_workspace_engine
```

Install packages:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

---

# 📱 Application Flow

### Dashboard

* Profile Switcher
* Quick Navigation
* Workspace Overview

### Profile Switching

```text
Personal
   ↓
Work
   ↓
Corporate
   ↓
Creative
```

Each profile maintains its own isolated data.

### Todos

* Add Todo
* Complete Todo
* Delete Todo
* Persistent Storage

### Events

* View Events
* Event Details
* Cached Images
* Pull To Refresh

---

# 🔐 Security Features

### Secure Storage

Sensitive information stored using:

```text
flutter_secure_storage
```

### Authorization

Automatic token injection using:

```text
AuthInterceptor
```

### Error Handling

* Domain Exceptions
* Network Exceptions
* User-Friendly Messages

---

# 🏗️ Architecture Highlights

### Repository Pattern

```dart
abstract class Repository {
  Future<T> getData();
}
```

### Dependency Injection

```dart
final getIt = GetIt.instance;
```

### Bloc Pattern

```dart
class FeatureBloc extends Bloc<Event, State> {}
```

### Offline First Design

```text
UI
 ↓
Bloc
 ↓
Repository
 ↓
Hive Storage
```

---

# 🧪 Testing

Run all tests:

```bash
flutter test
```

Run with coverage:

```bash
flutter test --coverage
```

---

# 📈 Analytics Verification

Successful analytics logging:

```text
✅ Firebase Analytics Event Sent: corporate -> work
💡 Logged profile_swapped: corporate -> work
```

---

# 🛠️ Crashlytics Verification

Successful crash logging:

```text
💡 Crashlytics recorded error
```

---

# 👨‍💻 Built With

* Flutter
* Dart
* BLoC
* Hive
* Dio
* Go Router
* GetIt
* Firebase Analytics
* Firebase Crashlytics
* Clean Architecture

---
Networking is implemented using Dio with custom request/response interceptors for logging, authentication and centralized error handling.

A NetworkService abstraction sits on top of Dio and is consumed by repositories through data sources.

The architecture is Retrofit-ready, but Retrofit was not introduced because the project currently exposes only a small API surface and manual service implementations kept the networking layer lightweight.

# License

This project is intended for technical assessment and demonstration purposes.
