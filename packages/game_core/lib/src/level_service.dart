import 'dart:math';

import 'game_level.dart';
import 'level_generator.dart';
import 'repository.dart';
import 'word_list_service.dart';

/// Service that manages level generation, caching, and progression.
class LevelService {
  final GameRepository repository;
  final WordListService wordList;
  final LevelGenerator generator;
  final Random _random;

  LevelService({
    required this.repository,
    required this.wordList,
    Random? random,
  })  : generator = LevelGenerator(random: random),
        _random = random ?? Random();

  /// Get or generate a level by number.
  ///
  /// If the level exists in the repository, returns it.
  /// Otherwise generates, saves, and returns a new level.
  Future<GameLevel> getLevelByNumber(int levelNumber) async {
    final levelId = _levelNumberToId(levelNumber);
    final existing = await repository.loadLevel(levelId);
    if (existing != null) return existing;

    // Generate new level
    final words = wordList.getWordsForLevel(
      levelNumber: levelNumber,
      count: _calculateWordCount(levelNumber),
    );

    final dimensions = _calculateGridSize(levelNumber);
    final level = generator.generateLevel(
      id: levelId,
      name: 'Level $levelNumber',
      width: dimensions,
      height: dimensions,
      targetWordCount: words.length,
      timeLimit: _calculateTimeLimit(levelNumber),
      pointsToWin: _calculatePointsToWin(words),
    );

    // Save it
    await repository.saveLevelResult(levelId, 0);
    return level;
  }

  String _levelNumberToId(int number) => 'level_$number';

  int _calculateWordCount(int levelNumber) {
    // Start with 2 words, add one more every 3 levels
    return 1 + (levelNumber ~/ 3);
  }

  int _calculateGridSize(int levelNumber) {
    // Start with 4x4, increase size every 10 levels
    // Level 1-10: 4x4
    // Level 11-20: 5x5
    // etc.
    return 3 + (levelNumber ~/ 10) + 1;
  }

  int _calculateTimeLimit(int levelNumber) {
    // Optional: return 0 for no limit
    // Or calculate based on word count and grid size
    final baseTime = 60; // 1 minute base
    final wordCount = _calculateWordCount(levelNumber);
    return baseTime + (wordCount * 30); // 30 seconds per word
  }

  int _calculatePointsToWin(List<String> words) {
    return words.fold<int>(0, (sum, word) => sum + (word.length * 100));
  }
}