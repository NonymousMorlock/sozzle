# game_core

Core game domain interfaces and a small GameCore implementation.

To run tests locally:

```bash
# from repository root
cd packages/game_core
dart pub get
dart test
```

Note: The dev container used for development may not include the Dart SDK. Run the commands above on a machine with Dart SDK installed.

Adapters and examples
- `InMemoryRepository` — quick in-memory repository useful for tests and simple demos.
- `FileGameRepository` — very small file-backed adapter (uses `dart:io`, not web-friendly).

See `example/usage.md` for a minimal example showing how to subscribe to the
`GameCore.state` stream and perform level lifecycle operations.
