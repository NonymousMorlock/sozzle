import 'difficulty_config.dart';
import 'game_level.dart';
import 'level_generator.dart';

/// Manages the progression of difficulty in the game
class DifficultyProgressionSystem {
  DifficultyProgressionSystem({
    required List<String> wordList,
    int? initialLevel,
    LevelGenerator? levelGenerator,
  })  : _currentLevel = initialLevel ?? 1,
        _wordList = wordList,
        _generator = levelGenerator ?? LevelGenerator(wordList: wordList);

  final LevelGenerator _generator;
  final List<String> _wordList;
  int _currentLevel;

  /// Get the current progression level
  int get currentLevel => _currentLevel;

  /// Generate the next level with appropriate difficulty
  SimpleLevel generateNextLevel() {
    final difficulty = _calculateDifficulty();
    
    return _generator.generateLevel(
      id: 'level_$_currentLevel',
      name: 'Level $_currentLevel',
      width: difficulty.baseGridSize,
      height: difficulty.baseGridSize,
      difficulty: difficulty,
    );
  }

  /// Called when a level is completed successfully
  void onLevelCompleted() {
    _currentLevel++;
  }

  DifficultyConfig _calculateDifficulty() {
    // Start with easy difficulty
    if (_currentLevel <= 5) {
      return DifficultyConfig.easy();
    }
    
    // Switch to medium from level 6-15
    if (_currentLevel <= 15) {
      return DifficultyConfig.medium();
    }
    
    // Beyond level 15, use hard difficulty with increasing
    // time pressure and word count
    final base = DifficultyConfig.hard();
    final extraWords = (_currentLevel - 15) ~/ 3; // Add a word every 3 levels
    final timeReduction = (_currentLevel - 15) * 5; // Reduce time by 5s per level
    
    return base.copyWith(
      maxWordsPerLevel: base.maxWordsPerLevel + extraWords,
      timeLimit: math.max(60, base.timeLimit - timeReduction), // Min 1 minute
    );
  }
}