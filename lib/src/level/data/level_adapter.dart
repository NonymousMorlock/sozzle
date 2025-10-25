import 'package:game_core/game_core.dart';
import 'package:level_data/level_data.dart';

/// Adapter to convert between LevelData and GameLevel
extension LevelDataAdapter on LevelData {
  /// Convert LevelData to SimpleLevel
  SimpleLevel toGameLevel() {
    return SimpleLevel(
      id: levelId.toString(),
      gridWidth: boardWidth,
      gridHeight: boardHeight,
      boardData: boardData,
      targetWords: words,
      pointsToWin: words.length * LevelData.levelPoint,
    );
  }
}

/// Adapter to convert GameLevel to LevelData
extension GameLevelAdapter on GameLevel {
  /// Convert GameLevel to LevelData
  LevelData toLevelData() {
    return LevelData(
      levelId: int.parse(id),
      boardWidth: gridWidth,
      boardHeight: gridHeight,
      boardData: boardData,
      words: targetWords,
    );
  }
}