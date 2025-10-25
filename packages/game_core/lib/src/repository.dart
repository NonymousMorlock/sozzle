import 'game_level.dart';

/// Repository interface for loading and saving game data.
abstract class GameRepository {
  /// Load level data by id. Returns null if not found.
  Future<GameLevel?> loadLevel(String id);

  /// Save progress or score for a level.
  Future<void> saveLevelResult(String id, int score);
}
