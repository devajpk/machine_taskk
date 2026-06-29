# 🚀 Multi Profile Workspace Engine

A production-ready Flutter application demonstrating **Clean Architecture**, **Offline-First Architecture**, **BLoC State Management**, **Hive Local Storage**, **Firebase Analytics**, **Firebase Crashlytics**, and **Enterprise Flutter Development Practices**.

The application provides multiple isolated workspace profiles where users can manage profile-specific Todos while viewing shared Global Events. A unified Calendar Dashboard combines both local and remote activities into a single timeline with activity indicators and daily filtering.

---

# 📱 Demo

## Screens

* Dashboard
* Profile Switcher
* Todo Manager
* Calendar Dashboard
* Global Events Feed
* Event Details



---

# ✨ Features

## 🏢 Multi Workspace Profiles

Supports multiple isolated workspace profiles.

Available profiles:

* Personal
* Work
* Corporate
* Creative

Each profile maintains its own:

* Todo list
* Dashboard state
* Calendar activities
* Analytics tracking

---

## 📌 Fixed AppBar & Workspace Navigation

The dashboard uses a **fixed (pinned) AppBar** to keep workspace navigation always accessible.

Features include:

* Fixed AppBar during scrolling
* Horizontally scrollable workspace selector
* Smooth profile switching
* Persistent navigation experience
* Responsive layout for small screens

---

## ✅ Todo Management

Features

* Create Todo
* Update Todo
* Delete Todo
* Mark Todo Complete
* Default Today Date
* Offline Storage
* Profile-specific Todos

Built using

* Hive
* Flutter Bloc
* Clean Architecture

---

## 📅 Calendar Dashboard (Phase 2)

A unified dashboard combining Local Todos and Global Events.

### Calendar Features

* Monthly calendar
* Previous / Next month navigation
* Activity indicators
* Daily filtering
* Selected day activities
* Empty state
* Profile-aware Todo filtering
* Shared Global Events
* Smooth UI updates

### Calendar Indicators

Each day displays activity badges.

🔵 Todo

🟢 Global Event

If both exist, both indicators are displayed.

---

## 🌍 Global Events

Global Events are loaded from a remote API.

Features

* Pull to Refresh
* Cached Images
* Event Details
* Retry Support
* Error Handling
* Read-only Feed

Built using

* Dio
* Cached Network Image

---

## 📊 Firebase Analytics

Custom Analytics Event

```
profile_swapped
```

Triggered whenever the active workspace changes.

Example

```
Personal → Work

Corporate → Creative

Creative → Personal
```

Parameters

```json
{
  "from_profile":"personal",
  "to_profile":"work"
}
```

---

## 💥 Firebase Crashlytics

Crashlytics is integrated to capture runtime issues.

Captures

* Flutter Errors
* Platform Errors
* Unhandled Exceptions

---

# 🏗 Clean Architecture

```
lib
│
├── core
│   ├── analytics
│   ├── crashlytics
│   ├── config
│   ├── exceptions
│   ├── failures
│   ├── logger
│   ├── network
│   ├── routing
│   ├── security
│   └── typedefs
│
├── features
│   ├── dashboard
│   ├── profiles
│   ├── todos
│   └── global_events
│
├── injection
│
└── main.dart
```

---

# 🧩 Architecture Layers

## Presentation

* Screens
* Widgets
* Bloc
* UI Components

## Domain

* Entities
* Repository Contracts
* Use Cases

## Data

* Repository Implementations
* Remote Data Sources
* Local Data Sources

---

# 🎯 State Management

Implemented using Flutter Bloc.

Blocs

* ProfileBloc
* TodoBloc
* GlobalEventBloc
* CalendarActivityBloc

Advantages

* Predictable State
* Event-driven Updates
* Easy Testing
* Clean Separation of Concerns

---

# 💾 Offline First

Local persistence implemented using Hive.

Benefits

* Works without internet
* Fast startup
* Persistent data
* Profile-specific storage

---

# 🌐 Networking

Networking is implemented using Dio.

Features

* Repository Pattern
* Request Interceptors
* Response Interceptors
* Error Mapping
* Timeout Configuration
* Centralized API Layer

Architecture

```
UI

↓

Bloc

↓

Repository

↓

Data Source

↓

Network Service (Dio)
```

---

# 🔒 Security

Implemented using Flutter Secure Storage.

Features

* Secure Token Storage
* Authentication Ready
* Centralized Authorization Interceptor

---

# 📅 Calendar Filtering Logic

The calendar filtering logic is implemented in the Business Logic layer rather than the UI.

### Workflow

```
User selects a date

↓

CalendarActivityBloc

↓

CalendarActivityUseCase

↓

TodoRepository
GlobalEventRepository

↓

Merge Activities

↓

ActivityCounts

↓

Update Calendar UI
```

### Filtering Rules

* Todos are filtered by the active workspace profile.
* Global Events remain shared across all profiles.
* Dates are normalized using Year / Month / Day before comparison.
* Activity indicators are precomputed into a `Map<DateTime, ActivityCounts>`.
* Selected-day Todos and Events are merged and sorted chronologically.
* Calendar automatically refreshes after Todo or Event updates.
* Business logic is handled outside the widget tree to minimize rebuilds.

---

# 🛠 UI Improvements & Bug Fixes

### Dashboard

* Implemented a fixed (pinned) AppBar.
* Added a horizontally scrollable workspace profile selector.
* Improved responsive layout across different screen sizes.
* Enhanced spacing and alignment throughout the dashboard.

### Calendar

* Connected calendar with real Todo and Global Event data.
* Added Todo and Event activity indicators.
* Fixed stale calendar state after returning from other screens.
* Added chronological activity ordering.
* Improved calendar refresh behavior.
* Reduced unnecessary rebuilds.
* Optimized activity count rendering.

### Profile Switching

* Eliminated profile switching flicker.
* Preserved previous workspace while loading the next profile.
* Improved animation and transition smoothness.

### Todo

* Added default Today date.
* Improved empty states.
* Enhanced keyboard handling.
* Better form spacing.

### Global Events

* Added structured empty state.
* Retry support.
* Better loading indicators.

---

# ⚡ Performance Optimizations

* Cached activity counts
* Lightweight Bloc rebuilds
* Repository abstraction
* Efficient date normalization
* Profile-based filtering
* O(t + e) activity aggregation
* Optimized calendar updates
* Reduced unnecessary widget rebuilds
* Lazy UI rendering

---

# 📦 Dependencies

```yaml
flutter_bloc
equatable
dio
hive
hive_flutter
cached_network_image
go_router
get_it
flutter_secure_storage
connectivity_plus
firebase_core
firebase_analytics
firebase_crashlytics
logger
uuid
```

---

# 🚀 Getting Started

Clone the repository

```bash
git clone <repository-url>
```

Move into the project

```bash
cd multi_profile_workspace_engine
```

Install packages

```bash
flutter pub get
```

Run the application

```bash
flutter run
```

Build Release APK

```bash
flutter build apk --release
```

---

# 🧪 Testing

Run all tests

```bash
flutter test
```

Run tests with coverage

```bash
flutter test --coverage
```

---

# 📱 Application Flow

```
Launch App

↓

Select Workspace

↓

Dashboard

↓

Calendar Dashboard

↓

Select Date

↓

View Filtered Todos & Global Events

↓

Manage Todo

↓

Refresh Calendar Automatically
```

---

# 📊 Project Highlights

* ✅ Clean Architecture
* ✅ Flutter Bloc State Management
* ✅ Offline First
* ✅ Hive Local Database
* ✅ Dio Networking
* ✅ Repository Pattern
* ✅ GetIt Dependency Injection
* ✅ Firebase Analytics
* ✅ Firebase Crashlytics
* ✅ Unified Calendar Dashboard
* ✅ Activity Indicators
* ✅ Multi Profile Support
* ✅ Profile Isolation
* ✅ Fixed AppBar
* ✅ Horizontally Scrollable Profile Switcher
* ✅ Responsive UI
* ✅ Enterprise Project Structure

---

# 👨‍💻 Built With

* Flutter
* Dart
* Flutter Bloc
* Hive
* Dio
* GetIt
* Go Router
* Cached Network Image
* Firebase Analytics
* Firebase Crashlytics

---

# 📄 License

This project was developed as part of a Flutter technical assessment to demonstrate Clean Architecture, scalable state management, offline-first design, and enterprise-level Flutter development practices.
