Example: Using GameCore

This example shows how to instantiate and subscribe to the GameCore state stream.

```dart
import 'package:game_core/game_core.dart';

void main() async {
  final repo = InMemoryRepository({
    'level1': SimpleLevel('level1', name: 'First level'),
  });
  final core = SimpleGameCore(repository: repo);

  final sub = core.state.listen((state) {
    print('Game state changed: $state');
  });

  await core.startLevel('level1');
  // ... gameplay happens
  await core.levelWon(score: 123);

  await core.goIdle();
  await core.dispose();
  await sub.cancel();
}
```

Notes:
- Use `FileGameRepository` if you want simple file persistence on platforms that
  support `dart:io`.
- For Flutter apps consider platform-aware persistence (shared_preferences,
  hive, etc.) or `hydrated_bloc` for bloc state persistence.
