import 'package:game_core/game_core.dart';
import 'package:sozzle/src/level/data/level_adapter.dart';
import 'package:sozzle/src/level/domain/i_level_repository.dart';

/// An adapter to make our LevelRepository work with GameCore
class GameCoreLevelRepositoryAdapter implements Repository {
  const GameCoreLevelRepositoryAdapter(this._repository);

  final ILevelRepository _repository;

  @override
  Future<GameLevel?> getLevel(String id) async {
    try {
      final levelData = await _repository.getLevel(int.parse(id));
      return levelData.toGameLevel();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveLevel(GameLevel level) async {
    await _repository.setLevel(level.toLevelData());
  }
}