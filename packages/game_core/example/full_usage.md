Example: Using GameCore with dynamic level generation

This example shows how to set up the game core with dynamic level generation:

```dart
import 'package:game_core/game_core.dart';

void main() async {
  // 1. Create word list service with dictionary
  final wordList = WordListService(
    words: ['CAT', 'DOG', 'BIRD', 'LION', 'TIGER', ...],
  );

  // 2. Create level service (handles generation and caching)
  final levelService = LevelService(
    repository: InMemoryRepository(), // or FileGameRepository
    wordList: wordList,
  );

  // 3. Create game core
  final gameCore = SimpleGameCore(
    repository: levelService.repository,
  );

  // 4. Subscribe to game state changes
  gameCore.state.listen((state) {
    print('Game state changed: $state');
  });

  // 5. Play through levels
  int currentLevel = 1;
  
  while (true) {
    // Get or generate level
    final level = await levelService.getLevelByNumber(currentLevel);
    
    // Start playing
    await gameCore.startLevel(level.id);
    
    // ... gameplay happens ...
    
    // Win level and progress
    await gameCore.levelWon(score: 100);
    currentLevel++;
    
    // Return to menu
    await gameCore.goIdle();
  }
}
```

To integrate with the existing app:

```dart
void main() {
  // In your app's dependency injection
  final appLevelRepo = LevelRepository(); // your existing repo
  
  // Create adapter to bridge game core with app repository
  final adapter = AppLevelRepositoryAdapter(appLevelRepo);
  
  // Create services using adapter
  final wordList = WordListService(
    words: await loadWordList(), // load from assets
  );
  
  final levelService = LevelService(
    repository: adapter,
    wordList: wordList,
  );
  
  final gameCore = SimpleGameCore(
    repository: adapter,
  );
  
  // Use in your app...
}

// Load word list from assets
Future<List<String>> loadWordList() async {
  final file = await rootBundle.loadString('assets/words.txt');
  return file.split('\n')
    .map((w) => w.trim().toUpperCase())
    .where((w) => w.isNotEmpty)
    .toList();
}
```

Features:
- Automatic level generation
- Difficulty progression
- Word selection by level
- Grid size increases with level
- Time limits scale with difficulty
- Points based on word length
- Caching via repository
- Works with existing app architecture