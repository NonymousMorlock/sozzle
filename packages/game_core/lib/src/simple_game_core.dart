import 'dart:async';

import 'game_core_interface.dart';
import 'game_state.dart';
import 'repository.dart';

/// A small, test-friendly GameCore implementation.
class SimpleGameCore implements GameCore {
  final GameRepository? repository;
  late GameState _current = const Idle();
  final _controller = StreamController<GameState>.broadcast();

  SimpleGameCore({this.repository});

  @override
  Stream<GameState> get state => _controller.stream;

  @override
  GameState get currentState => _current;

  void _emit(GameState s) {
    _current = s;
    if (!_controller.isClosed) _controller.add(s);
  }

  @override
  Future<void> startLevel(String levelId) async {
    // Optionally ensure level exists via repository
    if (repository != null) {
      final level = await repository!.loadLevel(levelId);
      if (level == null) throw StateError('Level not found: $levelId');
    }
    _emit(PlayingLevel(levelId));
  }

  @override
  Future<void> levelWon({int score = 0}) async {
    final s = _current;
    if (s is! PlayingLevel) throw StateError('Not currently playing a level');
    _emit(LevelWon(s.levelId, score: score));
    // Persist result
    if (repository != null) {
      await repository!.saveLevelResult(s.levelId, score);
    }
  }

  @override
  Future<void> goIdle() async {
    _emit(const Idle());
  }

  @override
  Future<void> dispose() async {
    await _controller.close();
  }
}
