/// PlayerStats tracks the player's progress and achievements
abstract class PlayerStats {
  /// Get the current level number
  int get currentLevel;
  
  /// Get the total number of levels completed
  int get levelsCompleted;
  
  /// Get the total score across all levels
  int get totalScore;
  
  /// Get the high score for a specific level
  int getHighScore(int levelId);
  
  /// Get the percentage completion for a level
  double getLevelProgress(int levelId);
  
  /// Update stats after completing a level
  Future<void> updateLevelStats({
    required int levelId,
    required int score,
    required int wordsFound,
    required int totalWords,
    required Duration timeSpent,
  });
  
  /// Save stats to persistent storage
  Future<bool> saveStats();
  
  /// Load stats from persistent storage
  Future<bool> loadStats();
}