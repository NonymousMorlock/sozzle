import 'package:flutter/foundation.dart';
import 'package:game_core/game_core.dart';
import 'package:sozzle/src/level/data/level_adapter.dart';
import 'package:sozzle/src/level/domain/i_level_repository.dart';

/// A GameCore implementation that integrates with the app's level repository
class AppGameCore extends InMemoryGameCore implements GameCore {
  AppGameCore({
    required ILevelRepository levelRepository,
    required List<String> wordList,
  })  : _levelRepository = levelRepository,
        super(
          wordList: wordList,
          progression: DifficultyProgressionSystem(wordList: wordList),
        );

  final ILevelRepository _levelRepository;

  @override
  Future<bool> initializeLevel([GameLevel? level]) async {
    if (level == null) {
      // Generate next level
      final result = await super.initializeLevel();
      if (!result) return false;

      // Save generated level to repository
      await _levelRepository.setLevel(currentLevel!.toLevelData());
      return true;
    }

    // Initialize with provided level
    final result = await super.initializeLevel(level);
    if (!result) return false;

    // Save level to repository if it's not already there
    try {
      await _levelRepository.getLevel(int.parse(level.id));
    } catch (e) {
      debugPrint('Level ${level.id} not found in repository, saving...');
      await _levelRepository.setLevel(level.toLevelData());
    }

    return true;
  }

  @override
  Future<bool> loadGame() async {
    try {
      final currentLevelNum = playerStats.currentLevel;
      final levelData = await _levelRepository.getLevel(currentLevelNum);
      return initializeLevel(levelData.toGameLevel());
    } catch (e) {
      debugPrint('Failed to load game: $e');
      return false;
    }
  }

  @override
  Future<bool> saveGame() async {
    try {
      if (currentLevel != null) {
        await _levelRepository.setLevel(currentLevel!.toLevelData());
      }
      return true;
    } catch (e) {
      debugPrint('Failed to save game: $e');
      return false;
    }
  }
}