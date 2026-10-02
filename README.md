#  Shortest Path Finder - Webspark Test Task

A Flutter application designed to calculate and visualize the shortest path between two points on a 2D grid. Developed as a technical test task for Webspark.

##  Key Features & Technical Highlights

* **Custom Pathfinding Algorithm:** Implemented a custom **Breadth-First Search (BFS)** algorithm from scratch (no external pathfinding libraries). It guarantees the shortest path on a 2D grid considering horizontal, vertical, and diagonal movements, while avoiding blocked cells (`X`).
* **Background Processing (Isolates):** To ensure the UI remains smooth (60 FPS) during heavy calculations (grids up to 100x100), the BFS algorithm is executed in a background thread using Dart's `compute` function (Isolates).
* **Clean Architecture:** Strict separation of concerns divided into `Domain`, `Data`, and `Presentation` layers.
* **State Management:** Fully managed by `flutter_bloc` for predictable and scalable state transitions.
* **Pixel-Perfect UI:** Exact adherence to the provided mockups and specific HEX color codes for grid visualization.
* **Unit Testing:** Critical business logic (Algorithm, DTOs, Repository, and BLoC) is covered with unit tests using `mocktail` and `bloc_test`.

##  Tech Stack

* **Framework:** Flutter / Dart
* **State Management:** `flutter_bloc`, `equatable`
* **Networking:** `dio`
* **Testing:** `flutter_test`, `mocktail`, `bloc_test`

##  Project Structure (Clean Architecture)

```text
lib/
├── data/              # Networking, DTOs, and Repositories
│   ├── models/        # JSON serialization (PointDto, TaskDto, ResultDto)
│   ├── api_client.dart
│   └── task_repository.dart
├── domain/            # Core business logic (No Flutter dependencies)
│   ├── pathfinder_service.dart  # Custom BFS Algorithm
│   └── point_entity.dart
├── presentation/      # UI and State Management
│   ├── bloc/          # ProcessBloc, Events, States
│   └── ui/            # HomeScreen, ProcessScreen, ResultListScreen, PreviewScreen
└── main.dart          # App entry point & Dependency Injection
```

##  How to Run Locally

1. Clone the repository:
```bash
git clone https://github.com/Kryvutsia-Roman/webspark-flutter-test.git
```

2. Navigate to the project directory:
```bash
cd flutter_project_webspark
```

3. Fetch dependencies:
```bash
flutter pub get
```

4. Run the unit tests (optional but recommended):
```bash
flutter test
```

5. Run the application:
```bash
flutter run
```