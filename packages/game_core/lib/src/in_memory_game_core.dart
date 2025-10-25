import 'dart:async';

import 'package:meta/meta.dart';

import 'game_core.dart';
import 'game_level.dart';
import 'player_stats.dart';
import 'progression_system.dart';

/// InMemoryGameCore implements [GameCore] with in-memory state.
/// Useful for testing or simple implementations.
class InMemoryGameCore implements GameCore {
  InMemoryGameCore({
    GameState initialState = GameState.notReady,
    GameLevel? initialLevel,
    PlayerStats? stats,
    DifficultyProgressionSystem? progression,
    List<String>? wordList,
  })  : _state = initialState,
        _currentLevel = initialLevel,
        _playerStats = stats ?? InMemoryPlayerStats(),
        _progression = progression ?? 
            DifficultyProgressionSystem(wordList: wordList ?? []);

  GameState _state;
  GameLevel? _currentLevel;
  final PlayerStats _playerStats;
  final DifficultyProgressionSystem _progression;
  final Set<String> _foundWords = {};

  @override
  GameLevel? get currentLevel => _currentLevel;

  @override
  GameState get state => _state;

  @override
  PlayerStats get playerStats => _playerStats;

  final _stateController = StreamController<GameState>.broadcast();

  @override
  Stream<GameState> get stateStream => _stateController.stream;

  @override
  Future<bool> initializeLevel([GameLevel? level]) async {
    if (level != null) {
      return _initializeWithLevel(level);
    } else {
      return loadNextLevel();
    }
  }

  @override
  Future<bool> loadNextLevel() async {
    try {
      final level = _progression.generateNextLevel();
      return _initializeWithLevel(level);
    } catch (e) {
      _updateState(GameState.error);
      return false;
    }
  }

  Future<bool> _initializeWithLevel(GameLevel level) async {
    if (level.targetWords.isEmpty ||
        level.boardData.isEmpty ||
        level.gridWidth <= 0 ||
        level.gridHeight <= 0) {
      _updateState(GameState.error);
      return false;
    }

    _currentLevel = level;
    _foundWords.clear();
    _updateState(GameState.ready);
    return true;
  }

  @override
  bool submitWord(String word) {
    if (_state != GameState.playing && _state != GameState.ready) return false;
    if (_state == GameState.ready) _updateState(GameState.playing);

    final upperWord = word.toUpperCase();
    if (!_currentLevel!.targetWords.contains(upperWord)) return false;
    if (_foundWords.contains(upperWord)) return false;

    _foundWords.add(upperWord);
    if (_foundWords.length == _currentLevel!.targetWords.length) {
      _progression.onLevelCompleted();
      _updateState(GameState.levelComplete);
    }

    return true;
  }

  @override
  bool revealHint() {
    if (_state != GameState.playing && _state != GameState.ready) return false;
    // TODO: Implement hint logic with board data
    return false;
  }

  @override
  void pauseGame() {
    if (_state == GameState.playing) {
      _updateState(GameState.paused);
    }
  }

  @override
  void resumeGame() {
    if (_state == GameState.paused) {
      _updateState(GameState.playing);
    }
  }

  @override
  void resetLevel() {
    if (_currentLevel != null) {
      _foundWords.clear();
      _updateState(GameState.ready);
    }
  }

  @override
  Future<bool> saveGame() async {
    // In-memory implementation doesn't persist state
    return true;
  }

  @override
  Future<bool> loadGame() async {
    // In-memory implementation doesn't persist state
    return true;
  }

  void _updateState(GameState newState) {
    _state = newState;
    _stateController.add(newState);
  }

  @visibleForTesting
  Set<String> get foundWords => Set.unmodifiable(_foundWords);
}

/// Simple in-memory implementation of [PlayerStats]
class InMemoryPlayerStats implements PlayerStats {
  int _currentLevel = 1;
  int _levelsCompleted = 0;
  int _totalScore = 0;
  final Map<int, int> _highScores = {};
  final Map<int, double> _progress = {};

  @override
  int get currentLevel => _currentLevel;

  @override
  int get levelsCompleted => _levelsCompleted;

  @override
  int get totalScore => _totalScore;

  @override
  int getHighScore(int levelId) => _highScores[levelId] ?? 0;

  @override
  double getLevelProgress(int levelId) => _progress[levelId] ?? 0.0;

  @override
  Future<void> updateLevelStats({
    required int levelId,
    required int score,
    required int wordsFound,
    required int totalWords,
    required Duration timeSpent,
  }) async {
    final oldHighScore = getHighScore(levelId);
    if (score > oldHighScore) {
      _highScores[levelId] = score;
      _totalScore += score - oldHighScore;
    }

    _progress[levelId] = wordsFound / totalWords;
    if (_progress[levelId] == 1.0) _levelsCompleted++;
  }

  @override
  Future<bool> saveStats() async => true;

  @override
  Future<bool> loadStats() async => true;
}