import 'package:level_data/level_data.dart';
import 'package:sozzle/src/level/domain/i_level_repository.dart';
import 'game_level.dart';
import 'repository.dart';

/// Adapts the game core's [GameRepository] interface to work with the
/// app's existing [ILevelRepository].
class AppLevelRepositoryAdapter implements GameRepository {
  final ILevelRepository _appRepository;

  AppLevelRepositoryAdapter(this._appRepository);

  @override
  Future<GameLevel?> loadLevel(String id) async {
    try {
      final levelNumber = int.parse(id.split('_')[1]);
      final levelData = await _appRepository.getLevel(levelNumber);
      return _convertToGameLevel(levelData);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveLevelResult(String id, int score) async {
    try {
      final levelNumber = int.parse(id.split('_')[1]);
      final level = await _appRepository.getLevel(levelNumber);
      await _appRepository.setLevel(level);
    } catch (_) {
      // Ignore errors, level might not exist yet
    }
  }

  GameLevel _convertToGameLevel(LevelData appLevel) {
    return SimpleLevel(
      id: 'level_${appLevel.levelId}',
      name: 'Level ${appLevel.levelId}',
      gridWidth: appLevel.gridSize,
      gridHeight: appLevel.gridSize,
      boardData: appLevel.boardData,
      targetWords: appLevel.words,
      pointsToWin: 100 * appLevel.words.length,
    );
  }

  LevelData _convertToLevelData(GameLevel level) {
    final levelNumber = int.parse(level.id.split('_')[1]);
    return LevelData(
      boardData: level.boardData,
      words: level.targetWords,
      levelId: levelNumber,
      gridSize: level.gridWidth,
    );
  }
}